// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"
import run_demo from "./bustracker";

 function init() {
   let root = document.getElementById('root');
   if(root){
     if (navigator.geolocation) {
         navigator.geolocation.watchPosition(showPosition,
            showError,
            { enableHighAccuracy: true }
          );
     }
   }
 }

     function showError(error){
       switch(error.code) {
         case error.PERMISSION_DENIED:
             root.innerHTML = "User denied the request for Geolocation."
             break;
         case error.POSITION_UNAVAILABLE:
             root.innerHTML = "Location information is unavailable."
             break;
         case error.TIMEOUT:
             root.innerHTML = "The request to get user location timed out."
             break;
         case error.UNKNOWN_ERROR:
             root.innerHTML = "An unknown error occurred."
             break;
           }
     }

     function showPosition(position) {
       let lat,lon;
       let channel = socket.channel("tracker:",  window.userName);
       lat= ""+position.coords.latitude ;
       lon= ""+position.coords.longitude;
      // console.log("latitude"+lat+" longitude"+lon);
       run_demo(root, channel,lat,lon);
     }

 // Use jQuery to delay until page loaded.
 $(init);
