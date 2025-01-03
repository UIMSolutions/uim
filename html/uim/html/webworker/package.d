/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.html.webworker;

import uim.html;
@safe:

/* 
<!DOCTYPE html>
<html>
<body>

<p>Count numbers: <output id="result"></output></p>
<button onclick="startWorker()">Start Worker</button> 
<button onclick="stopWorker()">Stop Worker</button>

<script>
var w;

function startWorker() {
   if (typeof(Worker) !== "undefined") {
    if (typeof(w) == "undefined") {
       w = new Worker("demo_workers.js");
     }
    w.onmessage = function(event) {
       document.getElementById("result").innerHTML = event.data;
    };
  } else {
     document.getElementById("result").innerHTML = "Sorry! No Web Worker support.";
   }
}

function stopWorker() { 
  w.terminate();
  w = undefined;
}
</script>

</body>
</html> 
*/