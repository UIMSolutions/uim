/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.values.json;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

// #region set
  Json[string] set(Json[string] items, Json[string] newItems) {
    newItems.byKeyValue.each!(item => items[item.key] = item.value);
    return items;
  }

  Json[string] set(Json[string] items, string[] keys, bool value) {
    return set(items, keys, Json(value));
  }
  unittest {
/*     Json[string] testmap;
    // assert(set(testmap, ["a", "b"], true)["a"].getBoolean == true);
    // assert(set(testmap, ["c", "d"], false)["c"].getBoolean == false); */
  }

  Json[string] set(Json[string] items, string key, bool value) {
    return set(items, key, Json(value));
  }
  unittest {
    Json[string] testmap;
    // assert(set(testmap, "a", true)["a"].getBoolean == true);
    // assert(set(testmap, "b", false)["b"].getBoolean == false);
  }

  // #region set(..., int value)
    Json[string] set(Json[string] items, string[] keys, int value) {
      return set(items, keys, Json(value));
    }
    unittest {
      Json[string] testmap;
      // assert(set(testmap, ["a", "b"], 1)["a"].getLong == 1);
      // assert(set(testmap, ["c", "d"], 2)["c"].getLong == 2);
    }
    
    Json[string] set(Json[string] items, string key, int value) {
      return set(items, key, Json(value));
    }
    unittest {
      Json[string] testmap;
      // assert(set(testmap, "a", 1)["a"].getLong == 1);
      // assert(set(testmap, "b", 2)["b"].getLong == 2);
    }
  // #endregion set(..., int value)

  // #region set(..., long value)
    Json[string] set(Json[string] items, string[] keys, long value) {
      return set(items, keys, Json(value));
    }
    unittest {
      Json[string] testmap;
      // assert(set(testmap, ["a", "b"], 1)["a"].getLong == 1);
      // assert(set(testmap, ["c", "d"], 2)["c"].getLong == 2);
    }
    
    Json[string] set(Json[string] items, string key, long value) {
      return set(items, key, Json(value));
    }
    unittest {
      Json[string] testmap;
      // assert(set(testmap, "a", 1)["a"].getLong == 1);
      // assert(set(testmap, "b", 2)["b"].getLong == 2);
    }
  // #endregion set(..., long value)

  Json[string] set(Json[string] items, string[] keys, double value) {
    return set(items, keys, Json(value));
  }
  unittest {
    Json[string] testmap;
    // assert(set(testmap, ["a", "b"], 1.1)["a"].getDouble == 1.1);
    // assert(set(testmap, ["c", "d"], 2.1)["c"].getDouble == 2.1);
  }
  
  Json[string] set(Json[string] items, string key, double value) {
    return set(items, key, Json(value));
  }
  unittest {
    Json[string] testmap;
    // assert(set(testmap, "a", 1.1)["a"].getDouble == 1.1);
    // assert(set(testmap, "b", 2.1)["b"].getDouble == 2.1);
  }

  // #region set(..., string value)
    Json[string] set(Json[string] items, string[] keys, string value) {
      return set(items, keys, Json(value));
    }
    unittest {
      Json[string] testmap;
      // assert(set(testmap, ["a", "b"], "one")["a"].getString == "one");
      // assert(set(testmap, ["c", "d"], "two")["c"].getString == "two");
    }

    Json[string] set(Json[string] items, string key, string value) {
      return set(items, key, Json(value));
    }
    unittest {
      Json[string] testmap;
      // assert(set(testmap, "a", "one")["a"].getString == "one");
      // assert(set(testmap, "b", "two")["b"].getString == "two");
    }
  // #endregion set(..., string value)

  Json[string] set(Json[string] items, string key, string[] value) {
    return set(items, key, value.map!(v => Json(v)).array);
  }

  Json[string] set(Json[string] items, string key, Json[] value) {
    return set(items, key, Json(value));
  }

  Json[string] set(Json[string] items, string key, string[string] value) {
    Json[string] map;
    value.byKeyValue.each!(kv => map.set(kv.key, kv.value));
    return map;
  }

  Json[string] set(Json[string] items, string key, Json[string] value) {
    return set(items, key, Json(value));
  }

  Json[string] set(Json[string] items, string[] keys, Json value) {
    keys.each!(key => items.set(key, value));
    return items;
  }

  Json[string] set(Json[string] items, string key, Json value) {
    items[key] = value;
    return items;
  }

  unittest {
    Json[string] testmap;

    Json x = Json.emptyObject;
    x["1"] = true;

    // writeln("testMap => ", testmap);
    // assert(set(testmap, "a", "A")["a"].getString == "A");
    // assert(set(testmap, ["b", "c"], "bc")["b"].getString == "bc");
    // writeln("testMap => ", testmap);
    // assert(set(testmap, "one", 1)["one"].getLong == 1);
    // assert(set(testmap, ["hundred", "hundred1"], 100)["hundred"].getLong == 100);
    // writeln("testMap => ", testmap);
    // assert(set(testmap, "one.dot", 1.0)["one.dot"].getDouble == 1.0);
    // assert(set(testmap, ["hundred.dot", "hundred1.dot"], 100.1)["hundred.dot"].getDouble == 100.1);
    // writeln("testMap => ", testmap);
    // assert(set(testmap, "json", Json("X"))["json"].getString == "X");
    // assert(set(testmap, ["json.a", "json.b"], Json(100))["json.a"].getLong == 100);
    // writeln("testMap => ", testmap);
  }
// #endregion set

// Old stuff

// #region set
/* Json[string] setNull(Json[string] items, string[] path) {
  return set(items, path, Json(null));
}

Json[string] setNull(Json[string] items, string key) {
  return set(items, key, Json(null));
}

Json[string] setPath(T)(Json[string] items, string[] path, T value) {
  set(items, path, Json(value));
  return items;
}

Json[string] setPath(Json[string] items, string[] path, Json value) {
  if (path.length == 0) {
    return items;
  }

  if (path.length == 1) {
    return set(items, path[0], value);
  } */

  /*   Json json = Json.emptyObject;
  return set(items, path[0], json.set(path[1..$], value));                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
 */
/*   return null;
}  * /

Json[string] set(T)(Json[string] items, string key, T[string] value) {
  Json[string] convertedValues;
  value.byKeyValue.each!(kv => convertedValues[kv.key] = Json(kv.value));
  map.set(key, convertedValues);
  return items;
}

Json[string] set(T)(Json[string] items, T[string] keyValues) {
  keyValues.byKeyValue.each!(kv => set(items, kv.key, kv.value));
  return items;
}

Json[string] set(T)(Json[string] items, string[] keys, T value) {
  keys.each!(key => set(items, key, value));
  return items;
}

Json[string] set(T)(Json[string] items, string key, T value) {
  Json json = value.toJson;
  return set(items, key, json);
}

Json[string] set(Json[string] items, string key, Json value) {
  items[key] = value;
  return items;
}

unittest {
  Json[string] testItems;
  // assert(testItems.length == 0);
  // assert(!testItems.setNull(["null", "key"]).isNull(["null", "key"]));
  // TODO // assert(!testItems.setNull("nullKey").isNull("nullKey"));
  // assert(testItems.set("bool", true).isBoolean("bool"));
  // assert(testItems.set("Bool", true).getBoolean("Bool"));
  // assert(testItems.set("long", 1).isLong("long"));
  // assert(testItems.set("Long", 2).getLong("Long") == 2);
  // assert(testItems.set("double", 1.1).isDouble("double"));
  // assert(testItems.set("Double", 2.2).getDouble("Double") == 2.2);
  // assert(testItems.set("string", "1-1").isString("string"));
  // assert(testItems.set("String", "2-2").getString("String") != "2.2");

  /* Json[string] set(T)(Json[string] items, T[string] keyValues) {
  keyValues.byKeyValue.each!(kv => set(items, kv.key, kv.value));
  return items;
}

Json[string] set(T)(Json[string] items, string[] path, T value) {
  return set(items, path, Json(value));
}

Json[string] set(T)(Json[string] items, string key, T value) {
  return set(items, path, Json(value));
}

Json[string] set(Json[string] items, string[] path, Json value) {
  if (path.length == 0) {
    return items;
  }

  if (path.length == 1) {
    return set(items, path[0], value)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
  }

  Json json = Json.emptyObject;
  return set(items, path[0], json.set(json, path[1..$], value));                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
}

Json[string] set(Json[string] items, string key, Json value) {
  if (key.isNull) {
    return items;
  }

  items[key] = value;
  return items;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
}

Json[string] set(T)(Json[string] items, string key, T[string] value) {
  Json[string] convertedValues;
  value.byKeyValue.each!(kv => convertedValues[kv.key] = Json(kv.value));
  map.set(key, convertedValues);
  return items;
}
 * /

  // TODO
  /* // assert(testItems.set("bool", true).getBoolean("bool"));
  // assert(testItems.set("bool", true).getBoolean("bool"));
  // assert(testItems.set("long", 1).getLong("long") == 1);
  // assert(testItems.set("double", 0.1).getDouble("double") == 0.1);
  // assert(testItems.set("string", "A").getString("string") == "A");
  // assert(testItems.set("a", "A").set("b", "B").hasAllKeys("a", "b"));
  // assert(testItems.set("a", "A").set("b", "B").getString("b") == "B");
  // assert(testItems.set("a", "A").set("b", "B").getString("b") != "C"); 
  // TODO // assert(testItems.set("strings", ["x": "X", "y": "Y", "z": "Z"]) != Json(null));
} */
// #endregion setter