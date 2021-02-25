import React, { useEffect } from "react";

function GoogleMapWrapper(props) {
  useEffect(() => {
    var map = new google.maps.Map(document.getElementById("map"), {
      center: {
        lat: -34.397,
        lng: 150.644,
      },
      zoom: 5,
    });

    map.addListener("dragend", () => {
      console.log(map.getBounds());
    });
  });

  return <div id="map" class="column"></div>;
}

export default GoogleMapWrapper;
