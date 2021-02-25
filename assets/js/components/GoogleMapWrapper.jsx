import React, { useEffect } from "react";

function GoogleMapWrapper(props) {
  const { pushEvent, handleEvent } = props;
  useEffect(() => {
    var map = new google.maps.Map(document.getElementById("map"), {
      center: {
        lat: -34.397,
        lng: 150.644,
      },
      zoom: 5,
    });

    map.addListener("dragend", () => {
      pushEvent("bounds_changed", map.getBounds().toJSON());
    });

    if (handleEvent) {
      handleEvent("new_map_items", (payload) => itemsToMarkers(map, payload));
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
