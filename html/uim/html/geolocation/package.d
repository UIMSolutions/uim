/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.html.geolocation;

import uim.html;
@safe:


/*
<script>
var x = document.getElementById("demo");
function getLocation() {
  if (navigator.geolocation) {
     navigator.geolocation.getCurrentPosition(showPosition);
  } else {
     x.innerHTML = "Geolocation is not supported by this browser.";
   }
}

 function showPosition(position) {
  x.innerHTML = "Latitude: " + position.coords.latitude + 
  "<br>Longitude: " + position.coords.longitude; 
 }
</script>
*/

/*
function showError(error) {
  switch(error.code) {
    case error.PERMISSION_DENIED:
       x.innerHTML = "User denied the request for Geolocation."
       break;
    case error.POSITION_UNAVAILABLE:
       x.innerHTML = "Location information is unavailable."
      break;
    case error.TIMEOUT:
       x.innerHTML = "The request to get user location timed out."
       break;
    case error.UNKNOWN_ERROR:
      x.innerHTML = "An unknown error occurred."
      break;
   }
 } 
 */

 /* function showPosition(position) {
  var latlon = position.coords.latitude + "," + position.coords.longitude;

  var img_url = "https://maps.googleapis.com/maps/api/staticmap?center=
   "+latlon+"&zoom=14&size=400x300&sensor=false&key=YOUR_KEY";

   document.getElementById("mapholder").innerHTML = "<img src='"+img_url+"'>";
 }
 */

 /*
 The getCurrentPosition() method returns an object on success. The latitude, longitude and accuracy properties are always returned. The other properties are returned if available:


Property

Returns

coords.latitude The latitude as a decimal number (always returned) 
coords.longitude The longitude as a decimal number (always returned) 
coords.accuracy The accuracy of position (always returned) 
coords.altitude The altitude in meters above the mean sea level (returned if available) 
coords.altitudeAccuracy The altitude accuracy of position (returned if available) 
coords.heading The heading as degrees clockwise from North (returned if available) 
coords.speed The speed in meters per second (returned if available) 
timestamp The date/time of the response (returned if available) 
*/

/*
The Geolocation object also has other interesting methods:
•watchPosition() - Returns the current position of the user and continues to return updated position as the user moves (like the GPS in a car).
•clearWatch() - Stops the watchPosition() method.

The example below shows the watchPosition() method. You need an accurate GPS device to test this (like smartphone): 

<script>
var x = document.getElementById("demo");
function getLocation() {
   if (navigator.geolocation) {
    navigator.geolocation.watchPosition(showPosition);
  } else {
     x.innerHTML = "Geolocation is not supported by this browser.";
   }
}
 function showPosition(position) {
  x.innerHTML = "Latitude: " + position.coords.latitude + 
  "<br>Longitude: " + position.coords.longitude; 
 }
</script>
*/