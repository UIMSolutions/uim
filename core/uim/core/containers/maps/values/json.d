﻿/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.containers.maps.values.json;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

// #region set
  V[K] set(K, V:Json)(V[K] items, K key, bool value) {
    return set(items, key, Json(value));
  }

  V[K] set(K, V:Json)(V[K] items, K key, long value) {
    return set(items, key, Json(value));
  }

  V[K] set(K, V:Json)(V[K] items, K key, double value) {
    return set(items, key, Json(value));
  }

  V[K] set(K, V:Json)(V[K] items, K key, string value) {
    return set(items, key, Json(value));
  }

  V[K] set(K, V:Json)(V[K] items, K key, Json value) {
    items[key] = value;
    return items;
  }

  V[K] set(K, V:Json)(V[K] items, K key, Json[] value) {
    return set(items, key, Json(value));
  }

  V[K] set(K, V:Json)(V[K] items, K key, Json[string] value) {
    return set(items, key, Json(value));
  }

  unittest {
    Json[string] testmap;

    Json x = Json.emptyObject;
    x["1"] = true;

    assert(set(testmap, "a", "A")["a"] == "A");
    assert(set(testmap, "a", "A").set("b", "B")["b"] == "B");
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
  assert(testItems.length == 0);
  // assert(!testItems.setNull(["null", "key"]).isNull(["null", "key"]));
  // TODO assert(!testItems.setNull("nullKey").isNull("nullKey"));
  assert(testItems.set("bool", true).isBoolean("bool"));
  assert(testItems.set("Bool", true).getBoolean("Bool"));
  assert(testItems.set("long", 1).isLong("long"));
  assert(testItems.set("Long", 2).getLong("Long") == 2);
  assert(testItems.set("double", 1.1).isDouble("double"));
  assert(testItems.set("Double", 2.2).getDouble("Double") == 2.2);
  assert(testItems.set("string", "1-1").isString("string"));
  assert(testItems.set("String", "2-2").getString("String") != "2.2");

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
  /* assert(testItems.set("bool", true).getBoolean("bool"));
  assert(testItems.set("bool", true).getBoolean("bool"));
  assert(testItems.set("long", 1).getLong("long") == 1);
  assert(testItems.set("double", 0.1).getDouble("double") == 0.1);
  assert(testItems.set("string", "A").getString("string") == "A");
  assert(testItems.set("a", "A").set("b", "B").hasAllKeys("a", "b"));
  assert(testItems.set("a", "A").set("b", "B").getString("b") == "B");
  assert(testItems.set("a", "A").set("b", "B").getString("b") != "C"); 
  // TODO assert(testItems.set("strings", ["x": "X", "y": "Y", "z": "Z"]) != Json(null));
} */
// #endregion setter