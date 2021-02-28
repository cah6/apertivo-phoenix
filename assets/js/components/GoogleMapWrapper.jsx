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
        for (const item of newVisible) {
          if (!markers.has(item.id)) {
            var newMarker = new google.maps.Marker({
              position: {
                lat: item.latLng.latitude,
                lng: item.latLng.longitude,
              },
              map: map,
              title: ".",
            });
            markers.set(item.id, newMarker);
          }
        }
      });
    }
  });

  return <div id="map"></div>;
}

function itemsToMarkers(map, values) {
  for (let [key, value] of Object.entries(values)) {
    new google.maps.Marker({ position: value, map: map, title: key });
  }
}

export default GoogleMapWrapper;
