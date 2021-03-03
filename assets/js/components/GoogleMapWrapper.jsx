import React, { useEffect, useState } from "react";

function GoogleMapWrapper(props) {
  const { pushEvent, handleEvent } = props;

  const [markers, setMarkers] = useState(new Map());

  useEffect(() => {
    var map = new google.maps.Map(document.getElementById("map"), {
      center: {
        lat: 42.3314,
        lng: -83.0458,
      },
      zoom: 14,
      disableDefaultUI: true,
      clickableIcons: false,
    });

    google.maps.event.addListenerOnce(map, "idle", function () {
      pushEvent("bounds_changed", map.getBounds().toJSON());
    });

    map.addListener("dragend", () => {
      pushEvent("bounds_changed", map.getBounds().toJSON());
    });

    map.addListener("zoom_changed", () => {
      pushEvent("bounds_changed", map.getBounds().toJSON());
    });

    if (handleEvent) {
      handleEvent("new_results", (payload) => {
        var newVisible = payload.data;
        newVisible.forEach(function (item, index) {
          // in the future, maybe diff to remove non-visible markers
          const marker = markers.get(item.id);
          if (marker == undefined) {
            const newMarker = new google.maps.Marker({
              position: {
                lat: item.lat,
                lng: item.lng,
              },
              map: map,
              title: "",
              label: (index + 1).toString(),
              icon: makeIcon(false),
            });

            const infoWindow = new google.maps.InfoWindow({
              content: makeInfoWindow(item),
            });

            newMarker.addListener("mouseover", function () {
              infoWindow.open(map, this);
            });

            newMarker.addListener("mouseout", function () {
              infoWindow.close();
            });

            newMarker.addListener("click", () => {
              const selectedId = item.id;

              pushEvent("item_selected", { id: selectedId });

              // set icon thicker for selected item
              markers.forEach((marker, key) => {
                marker.setIcon(makeIcon(selectedId == key));
              });

              document
                .getElementById(`reel-item-${selectedId}`)
                .scrollIntoView({
                  behavior: "smooth",
                });
            });
            markers.set(item.id, newMarker);
          } else {
            marker.setLabel((index + 1).toString());
          }
        });
      });

      handleEvent("set_selected_icon", (payload) => {
        const selectedId = payload.id;
        markers.forEach((marker, key) => {
          const isSelected = selectedId == key;
          marker.setIcon(makeIcon(isSelected));
          if (isSelected) {
            map.panTo(marker.getPosition());
            // pushEvent("bounds_changed", map.getBounds().toJSON());
          }
        });

        document
          .getElementById(`reel-item-${selectedId}`)
          .scrollIntoView({ behavior: "smooth", inline: "center" });
      });
    }
  });

  return <div id="map"></div>;
}

function makeIcon(isSelected) {
  var strokeWeight = isSelected ? 4 : 2;
  return {
    path: "M 100,0 0,100 -100,0 0,-100 100,0 z",
    fillColor: "white",
    fillOpacity: 0.8,
    scale: 0.2,
    strokeColor: "black",
    strokeWeight: strokeWeight,
  };
}

function makeInfoWindow(item) {
  const daysActive = ["M", "T", "W"];
  return `
<box-l style="--borderWidth: 0px; --padding: 0.5rem">
  <h3>${item.restaurant}</h3>
  ${makeDayList(daysActive)}
</box-l>
  `;
}

function makeDayList(activeDays) {
  const items = activeDays.map((day) => makeDay(day)).join("");
  return `<cluster-l style="--space: 0.5rem"><ul>${items}</ul></cluster-l>`;
}

function makeDay(day) {
  return `<li class="day-active">${day}</li>`;
}

export default GoogleMapWrapper;
