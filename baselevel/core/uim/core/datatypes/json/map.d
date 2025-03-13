/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.datatypes.json.map;

import uim.core;

@safe:
version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// #region set
// #region set multi
ref set(T)(ref Json map, T[string] newItems) {
  newItems.each!((key, value) => map.set(key, value));
  return map;
}

ref set(T)(ref Json map, string[] keys, T value) {
  keys.each!(key => map.set(key, value));
  return map;
}
/* unittest {
  Json json = Json.emptyObject;
  json.set([
    "A", Json("a"),
    "B", Json("b"),
    "C", Json("c"),
    ]);
  assert(json["A"] == Json("a") && json["B"] == Json("b") && json["C"] == Json("c"));

  json = Json.emptyObject;
  json.set([
    "A", "a",
    "B", "b",
    "C", "c",
    ]);
  assert(json["A"] == Json("a") && json["B"] == Json("b") && json["C"] == Json("c"));

  json = Json.emptyObject;
  json.set(["A", "B", "C"], Json("x"));
  assert(json["A"] == Json("x") && json["B"] == Json("x") && json["C"] == Json("x"));

  json = Json.emptyObject;
  json.set(["A", "B", "C"], "x");
  assert(json["A"] == Json("x") && json["B"] == Json("x") && json["C"] == Json("x"));
}
 */// #endregion set multi

// #region set single 
ref setNull(ref Json json, string key) {
  return json.set(key, Json(null));
}
ref set(T)(ref Json map, string key, T value) {
  return map.set(key, value.toJson);
}
ref set(T)(ref Json json, string key, T[] value) {
  return map.set(key, value.toJson);
}
ref set(T)(ref Json json, string key, T[string] value) {
  return map.set(key, value.toJson);
}
ref set(T:Json)(ref Json map, string key, T value) {
  map[key] = value;
  return map;
}
/* unittest {
  Json json = Json.emptyObject;
  assert(json.set("bool", true).getBoolean("bool"));
  assert(json.set("bool", true).getBoolean("bool"));
  assert(json.set("long", 1).getLong("long") == 1);
  assert(json.set("double", 0.1).getDouble("double") == 0.1);
  assert(json.set("string", "A").getString("string") == "A");
  assert(json.set("strings", ["x": "X", "y": "Y", "z": "Z"]) != Json(null));
  writeln(json);
} */
// # endregion set single 

/* unittest {
  Json map = Json.emptyObject;
  map["a"] = "A";
  map["b"] = "B";
  map["c"] = "C";
  assert(map.length == 3);

  map.set("d", Json("x"));
  assert(map.length == 4 && map.hasKey("d"));

  map.set("e", Json("x")).set("f", Json("x"));
  assert(map.length == 6 && map.hasAllKeys("d", "e", "f"));

  map = Json.emptyObject;
  map["a"] = "A";
  map["b"] = "B";
  map["c"] = "C";
  map.set(["d", "e", "f"], Json("x"));
  assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x"));

  map = Json.emptyObject;
  map["a"] = "A";
  map["b"] = "B";
  map["c"] = "C";
  map.set("d", Json("x")).set("e", Json("x")).set("f", Json("x"));
  assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x"));

  map = Json.emptyObject;
  map["a"] = "A";
  map["b"] = "B";
  map["c"] = "C";
  map.set(["d": Json("x"), "e": Json("x"), "f": Json("x")]);
  assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x"));
} */
// #region set Json
