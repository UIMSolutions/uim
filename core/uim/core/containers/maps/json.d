/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.json;

import uim.core;
@safe:

// #region set
  // Returns a updated map with new values
 V[K] set(K:string, V:Json, T)(V[K] items, T[K] others) {
    others.each!((key, value) => items[key] = Json(value));
    return items;
  }

  // returns a updated map with new values
  V[K] set(K:string, V:Json, T)(V[K] items, K[] keys, T value) {
    keys.each!(key => items[key] = Json(value));
    return items;
  }
 
  // returns a updated map with new value
  V[K] set(K:string, V:Json, T)(V[K] items, K key, T value) {
    items[key] = Json(value);
    return items;
  }
  unittest {
    Json[string] map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];
    assert(map.length == 3);

    map.set("d", "x");
    assert(map.length == 4 && map.hasKey("d"));

    map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];   
    map.set(["d", "e", "f"], "x");
    assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x"));

    map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];  
    map.set("d", "x").set("e", "x").set("f", "x");
    assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x"));

    map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];  
    map.set(["d": "x", "e": "x", "f": "x"]);
    assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x")); 

    map = ["a": Json(true), "b": Json(false), "c": Json(true)];
    assert(map.length == 3);

    map.set("d", false);
    assert(map.length == 4 && map.hasKey("d"));

    map = ["a": Json(true), "b": Json(false), "c": Json(true)]; // Reset map
    map.set(["d", "e", "f"], "x");
    assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x"));

    map = ["a": Json(true), "b": Json(false), "c": Json(true)]; // Reset map
    map.set("d", true).set("e", true).set("f", true);
    assert(map.length == 6 && map.hasKey("d") && map["f"] == Json(true));

    map = ["a": Json(true), "b": Json(false), "c": Json(true)]; // Reset map
    map.set(["d": true, "e": true, "f": true]);
    assert(map.length == 6 && map.hasKey("d") && map["f"] == Json(true)); 
  }
// #endregion set

// #region update
  // Returns a updated map with updated of existing keys and new values
 V[K] update(K:string, V:Json, T)(V[K] items, T[K] others) {
    others.each!((key, value) => items[key] = Json(value));
    return items;
  }

  // returns a updated map with new values
  V[K] update(K:string, V:Json, T)(V[K] items, K[] keys, T value) {
    keys.each!(key => items[key] = Json(value));
    return items;
  }
 
  // returns a updated map with new value
  V[K] update(K:string, V:Json, T)(V[K] items, K key, T value) {
    items[key] = Json(value);
    return items;
  }
  unittest {
    Json[string] map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];
    assert(map.length == 3);

/*     map.update("d", "x");
    assert(map.length == 3 && !map.hasKey("d") && );
    map.update("d", "x");
    assert(map.length == 3 && !map.hasKey("d"));

    map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];   
    map.update(["d", "e", "f"], "x");
    assert(map.length == 3 && !map.hasAnyKey("d", "e", "f"));

    map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];  
    map.update("d", "x").update("e", "x").update("f", "x");
    assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x"));

    map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];  
    map.update(["d": "x", "e": "x", "f": "x"]);
    assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x")); 

    map = ["a": Json(true), "b": Json(false), "c": Json(true)];
    assert(map.length == 3);

    map.update("d", false);
    assert(map.length == 4 && map.hasKey("d"));

    map = ["a": Json(true), "b": Json(false), "c": Json(true)]; // Reupdate map
    map.update(["d", "e", "f"], "x");
    assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x"));

    map = ["a": Json(true), "b": Json(false), "c": Json(true)]; // Reupdate map
    map.update("d", true).update("e", true).update("f", true);
    assert(map.length == 6 && map.hasKey("d") && map["f"] == Json(true));

    map = ["a": Json(true), "b": Json(false), "c": Json(true)]; // Reupdate map
    map.update(["d": true, "e": true, "f": true]);
    assert(map.length == 6 && map.hasKey("d") && map["f"] == Json(true)); 
 */   }
// #endregion update

// #region ifNull
Json ifNull(K, V)(V[K] map, K key, Json defaultValue) {
  return key in map
    ? (!map[key].isNull ? map[key] : defaultValue) : defaultValue;
}
// #endregion ifNull
