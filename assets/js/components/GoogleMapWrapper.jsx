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
      zoom: 13,
      disableDefaultUI: true,
    });

    map.addListener("dragend", () => {
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
                lat: item.latLng.latitude,
                lng: item.latLng.longitude,
              },
              map: map,
              title: ".",
              label: (index + 1).toString(),
              icon: makeIcon(false),
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
                .scrollIntoView({ behavior: "smooth" });
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
          }
        });
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

export default GoogleMapWrapper;
