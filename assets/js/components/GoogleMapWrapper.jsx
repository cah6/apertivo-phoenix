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
      zoom: 11,
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
          if (!markers.has(item.id)) {
            var newMarker = new google.maps.Marker({
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
              var selectedId = item.id;

              pushEvent("marker_clicked", selectedId);

              // set icon thicker for selected item
              markers.forEach((marker, key) => {
                marker.setIcon(makeIcon(selectedId == key));
              });

              var el = document.getElementById(`reel-item-${selectedId}`);
              el.scrollIntoView({ behavior: "smooth" });
            });
            markers.set(item.id, newMarker);
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
