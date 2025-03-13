/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.keys.map;

@safe:
import uim.core;

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// #region sortKeys
// Returns the keys of a map sorted in ascending or descending order.
pure string[] sortedKeys(T)(ref T[string] items, SortDir dir = SortDir.ASC) {
  switch (dir) {
  case SortDir.ASC:
    return items.keys.sort!("a < b").array;
  case SortDir.DESC:
    return items.keys.sort!("a > b").array;
  default: 
    return items.keys;
  }
}
unittest {
  string[string] testMap = ["a": "A", "b": "B"];
  assert(testMap.sortedKeys == ["a", "b"]);
  assert(testMap.sortedKeys(SortDir.DESC) == ["b", "a"]);
}
// #endregion sortedKeys

// #region withoutKeys
// Returns a new map without the specified keys
pure T[string] withoutKeys(T)(T[string] entries, string[] keys...) {
  return withoutKeys(entries, keys.dup);
}

// Returns a new map without the specified keys
pure T[string] withoutKeys(T)(T[string] entries, string[] keys) {
  T[string] results = entries.dup;
  keys
    .filter!(key => entries.hasKey(key))
    .each!(key => results.remove(key));

  return results;
}

// Returns a new map without the specified key
pure T[string] withoutKey(T)(T[string] entries, string key) {
  T[string] results = entries.dup;
  results.remove(key);
  return results;
}
unittest {
  auto base = ["a": 1, "b": 2, "c": 3];
  assert(base.length == 3);
  assert(base.hasKey("a") && base.hasKey("b") && base.hasKey("c"));

  auto result = base.withoutKey("a");
  assert(result.length == 2 && !result.hasKey("a") && result.hasKey("b") && result.hasKey("c"));

  result = base.withoutKeys(["b", "a"]);
  assert(result.length == 1 && !result.hasKey("a") && !result.hasKey("b") && result.hasKey("c"));

  result = base.withoutKeys("a", "c", "b");
  assert(result.length == 0 && !result.hasKey("a") && !result.hasKey("b") && !result.hasKey("c"));

  result = base.withoutKeys(["a", "c", "b"]);
  assert(result.length == 0 && !result.hasKey("a") && !result.hasKey("b") && !result.hasKey("c"));
}
// #endregion withoutKeys

// #region filter
// returns a new map with only the specified keys
pure T[string] filterKeys(T)(T[string] entries, string[] keys...) {
  return filterKeys(entries, keys.dup);
}

// returns a new map with only the specified keys
pure T[string] filterKeys(T)(T[string] entries, string[] keys) {
  T[string] results;
  keys
    .filter!(key => entries.hasKey(key))
    .each!(key => results[key] = entries[key]);

  return results;
}

// returns a new map with only the specified keys
pure T[string] filterKey(T)(T[string] entries, string key) {
  T[string] results;
  if (entries.hasKey(key)) {
    results[key] = entries[key];
  }
  return results;
}

unittest {
  auto base = ["a": 1, "b": 2, "c": 3];
  assert(base.length == 3);
  assert(base.hasKey("a") && base.hasKey("b") && base.hasKey("c"));

  auto result = base.filterKeys("b", "c");
  assert(result.length == 2 && !result.hasKey("a") && result.hasKey("b") && result.hasKey("c"));

  result = base.filterKeys(["b", "c"]);
  assert(result.length == 2);
  assert(!result.hasKey("a") && result.hasKey("b") && result.hasKey("c"));

  result = base.filterKey("c");
  assert(result.length == 1 && !result.hasKey("a") && !result.hasKey("b") && result.hasKey("c"));

  result = base.filterKey("c");
  assert(result.length == 1 && !result.hasKey("a") && !result.hasKey("b") && result.hasKey("c"));
}
// #endregion filter

// #region renameKey(s)
// Returns a new map with the specified key(s) renamed
T[string] renameKeys(T)(T[string] items, string[string] keyMapping) {
  keyMapping.each!((fromKey, toKey) {
      items.renameKey(fromKey, toKey);
  });
  return items;
}

// Returns a new map with the specified key(s) renamed
T[string] renameKeys(T)(T[string] items, string[] fromKeys, string[] toKeys) {
  if (fromKeys.length <= toKeys.length) {
    fromKeys.each!((i, key) => items.renameKey(key, toKeys[i])); 
  }
  else { // keys.length > others.length)
    toKeys.each!((i, other) => items.renameKey(fromKeys[i], other)); 
  }
  return items;
}

// Returns a new map with the specified key(s) renamed
T[string] renameKey(T)(T[string] items, string fromKey, string toKey) {
  if (!items.hasKey(fromKey)) {
    return items;
  }

  T value = items.shift(fromKey);
  items[toKey] = value;

  return items;
}
unittest {
  auto testMap = ["a": 1, "b": 2, "c": 3, "d": 4];
  assert(testMap.hasAllKeys("a", "b", "c", "d"));
  testMap.renameKey("a", "x");
  assert(testMap.hasAllKeys("x", "b", "c", "d") && !testMap.hasKey("a"));

  testMap = ["a": 1, "b": 2, "c": 3, "d": 4];
  assert(testMap.hasAllKeys("a", "b", "c", "d"));
  testMap.renameKeys(["a", "b"], ["x", "y"]); // keys.length == others.length
  assert(testMap.hasAllKeys("x", "y", "c", "d") && !testMap.hasAnyKey("a", "b"));

  testMap = ["a": 1, "b": 2, "c": 3, "d": 4];
  assert(testMap.hasAllKeys("a", "b", "c", "d"));
  testMap.renameKeys(["a", "b"], ["x", "y", "z"]); // keys.length < others.length
  assert(testMap.hasAllKeys("x", "y", "c", "d") && !testMap.hasAnyKey("a", "b"));

  testMap = ["a": 1, "b": 2, "c": 3, "d": 4];
  assert(testMap.hasAllKeys("a", "b", "c", "d"));
  testMap.renameKeys(["a", "b", "c"], ["x", "y"]); // keys.length > others.length
  assert(testMap.hasAllKeys("x", "y", "c", "d") && !testMap.hasAnyKey("a", "b"));

  testMap = ["a": 1, "b": 2, "c": 3, "d": 4];
  assert(testMap.hasAllKeys("a", "b", "c", "d"));
  testMap.renameKeys(["a": "x", "b": "y"]); 
  assert(testMap.hasAllKeys("x", "y", "c", "d") && !testMap.hasAnyKey("a", "b"));

  auto jsonMap = ["a": Json(1), "b": Json(2), "c": Json(3), "d": Json(4)];
  assert(jsonMap.hasAllKeys("a", "b", "c", "d"));
  jsonMap.renameKey("a", "x");
  assert(jsonMap.hasAllKeys("x", "b", "c", "d") && !jsonMap.hasKey("a"));

  jsonMap = ["a": Json(1), "b": Json(2), "c": Json(3), "d": Json(4)];
  assert(jsonMap.hasAllKeys("a", "b", "c", "d"));
  jsonMap.renameKeys(["a", "b"], ["x", "y"]); // keys.length == others.length
  assert(jsonMap.hasAllKeys("x", "y", "c", "d") && !jsonMap.hasAnyKey("a", "b"));

  jsonMap = ["a": Json(1), "b": Json(2), "c": Json(3), "d": Json(4)];
  assert(jsonMap.hasAllKeys("a", "b", "c", "d"));
  jsonMap.renameKeys(["a", "b"], ["x", "y", "z"]); // keys.length < others.length
  assert(jsonMap.hasAllKeys("x", "y", "c", "d") && !jsonMap.hasAnyKey("a", "b"));

  jsonMap = ["a": Json(1), "b": Json(2), "c": Json(3), "d": Json(4)];
  assert(jsonMap.hasAllKeys("a", "b", "c", "d"));
  jsonMap.renameKeys(["a", "b", "c"], ["x", "y"]); // keys.length > others.length
  assert(jsonMap.hasAllKeys("x", "y", "c", "d") && !jsonMap.hasAnyKey("a", "b"));

  jsonMap = ["a": Json(1), "b": Json(2), "c": Json(3), "d": Json(4)];
  assert(jsonMap.hasAllKeys("a", "b", "c", "d"));
  jsonMap.renameKeys(["a": "x", "b": "y"]); 
  assert(jsonMap.hasAllKeys("x", "y", "c", "d") && !jsonMap.hasAnyKey("a", "b"));
}
// #endregion renameKey(s)

// #region hasKey
  // Returns true if the map has all the specified keys
  bool hasAllKeys(T)(T[string] base, string[] keys...) {
    return base.hasAllKeys(keys.dup);
  }

  // Returns true if the map has all the specified keys
  bool hasAllKeys(T)(T[string] base, string[] keys) {
    return keys.all!(key => base.hasKey(key));
  }

  // Returns true if the map has any of the specified keys
  bool hasAnyKey(T)(T[string] base, string[] keys...) {
    return base.hasAnyKey(keys.dup);
  }

  // Returns true if the map has any of the specified keys
  bool hasAnyKey(T)(T[string] base, string[] keys) {
    return keys.any!(key => base.hasKey(key));
  }

  // Returns true if the map has the specified key
  bool hasKey(T)(T[string] map, string key) {
    return (key in map) ? true : false;
  }

  unittest {
    auto testMap = ["a": 1, "b": 2, "c": 3, "d": 4];
    assert(testMap.hasKey("a") && !testMap.hasKey("x"));

    assert(testMap.hasAnyKey(["a", "b"]) && testMap.hasAnyKey(["a", "x"]));
    assert(testMap.hasAnyKey("a", "b") && testMap.hasAnyKey("a", "x"));

    assert(testMap.hasAllKeys(["a", "b"]) && !testMap.hasAllKeys(["a", "x"]));
    assert(testMap.hasAllKeys("a", "b") && !testMap.hasAllKeys("a", "x"));

    auto stringMap = ["a": "1", "b": "2", "c": "3", "d": "4"];
    assert(stringMap.hasKey("a") && !stringMap.hasKey("x"));

    assert(stringMap.hasAnyKey(["a", "b"]) && stringMap.hasAnyKey(["a", "x"]));
    assert(stringMap.hasAnyKey("a", "b") && stringMap.hasAnyKey("a", "x"));

    assert(stringMap.hasAllKeys(["a", "b"]) && !stringMap.hasAllKeys(["a", "x"]));
    assert(stringMap.hasAllKeys("a", "b") && !stringMap.hasAllKeys("a", "x"));

    auto jsonMap = ["a": Json(1), "b": Json(2), "c": Json(3), "d": Json(4)];
    assert(jsonMap.hasKey("a") && !jsonMap.hasKey("x"));

    assert(jsonMap.hasAnyKey(["a", "b"]) && jsonMap.hasAnyKey(["a", "x"]));
    assert(jsonMap.hasAnyKey("a", "b") && jsonMap.hasAnyKey("a", "x"));

    assert(jsonMap.hasAllKeys(["a", "b"]) && !jsonMap.hasAllKeys(["a", "x"]));
    assert(jsonMap.hasAllKeys("a", "b") && !jsonMap.hasAllKeys("a", "x"));
  }
// #endregion hasKey

// #region removeKey(s)
  T[string] removeKeys(T)(ref T[string] items, string[] keys...) {
    return removeKeys(items, keys.dup);
  }

  T[string] removeKeys(T)(ref T[string] items, string[] keys) {
    keys.each!(key => removeKey(items, key));
    return items;
  }

  T[string] removeKey(T)(ref T[string] items, string key) {
    if (hasKey(items, key)) {
      items.remove(key);
    }
    return items;
  }

  unittest {
    auto testMap = ["a": 1, "b": 2, "c": 3, "d": 4];
    assert(testMap.hasAllKeys("a", "b", "c", "d"));
    testMap.removeKey("a");
    assert(testMap.hasAllKeys("b", "c", "d") && !testMap.hasKey("a"));
    
    testMap = ["a": 1, "b": 2, "c": 3, "d": 4];
    assert(testMap.hasAllKeys("a", "b", "c", "d"));
    testMap.removeKeys(["b", "c"]);
    assert(testMap.hasAllKeys("a", "d") && !testMap.hasAnyKey("b", "c"));

    testMap = ["a": 1, "b": 2, "c": 3, "d": 4];
    assert(testMap.hasAllKeys("a", "b", "c", "d"));
    testMap.removeKeys("b", "c");
    assert(testMap.hasAllKeys("a", "d") && !testMap.hasAnyKey("b", "c"));

    auto stringMap = ["a": "1", "b": "2", "c": "3", "d": "4"];
    assert(stringMap.hasAllKeys("a", "b", "c", "d"));
    stringMap.removeKey("a");
    assert(stringMap.hasAllKeys("b", "c", "d") && !stringMap.hasKey("a"));

    stringMap = ["a": "1", "b": "2", "c": "3", "d": "4"];
    assert(stringMap.hasAllKeys("a", "b", "c", "d"));
    stringMap.removeKeys(["b", "c"]);
    assert(stringMap.hasAllKeys("a", "d") && !stringMap.hasAnyKey("b", "c"));

    stringMap = ["a": "1", "b": "2", "c": "3", "d": "4"];
    assert(stringMap.hasAllKeys("a", "b", "c", "d"));
    stringMap.removeKeys("b", "c");
    assert(stringMap.hasAllKeys("a", "d") && !stringMap.hasAnyKey("b", "c"));

    auto jsonMap = ["a": Json(1), "b": Json(2), "c": Json(3), "d": Json(4)];
    assert(jsonMap.hasAllKeys("a", "b", "c", "d"));
    jsonMap.removeKey("a");
    assert(jsonMap.hasAllKeys("b", "c", "d") && !jsonMap.hasKey("a"));

    jsonMap = ["a": Json(1), "b": Json(2), "c": Json(3), "d": Json(4)];
    assert(jsonMap.hasAllKeys("a", "b", "c", "d"));
    jsonMap.removeKeys(["b", "c"]);
    assert(jsonMap.hasAllKeys("a", "d") && !jsonMap.hasAnyKey("b", "c"));

    jsonMap = ["a": Json(1), "b": Json(2), "c": Json(3), "d": Json(4)];
    assert(jsonMap.hasAllKeys("a", "b", "c", "d"));
    jsonMap.removeKeys("b", "c");
    assert(jsonMap.hasAllKeys("a", "d") && !jsonMap.hasAnyKey("b", "c"));
  }
// #endregion removeKey(s)

  // #region set T[string]
    Json[string] set(T)(Json[string] items, T[string] newItems) {
      newItems.each!((key, value) => items.set(key, Json(value)));
      return items;
    }
    Json[string] set(T)(Json[string] items, T[string] newItems) {
      newItems.each!((key, value) => items.set(key, value));
      return items;
    }
    Json[string] set(T)(Json[string] items, string[] keys, T value) {
      keys.each!(key => items.set(key, value));
      return items;
    }
    Json[string] set(T)(Json[string] items, string key, T value) if (!is(Json == T)) {
      return items.set(key, value.toJson);
    }
    Json[string] set(T)(Json[string] items, string key, T value) if (is(Json == T)) {
      items[key] = value;
      return items;
    }
    unittest {
      Json[string] map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];
      assert(map.length == 3);

      map.set("d", Json("x"));
      assert(map.length == 4 && map.hasKey("d"));

      map.set("e", Json("x")).set("f", Json("x"));
      assert(map.length == 6 && map.hasAllKeys("d", "e", "f"));

      map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];
      map.set(["d", "e", "f"], Json("x"));
      assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x"));

      map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];
      map.set("d", Json("x")).set("e", Json("x")).set("f", Json("x"));
      assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x"));

/*       map = ["a": Json("A"), "b": Json("B"), "c": Json("C")];
      map.set(["d": Json("x"), "e": Json("x"), "f": Json("x")]);
      assert(map.length == 6 && map.hasKey("d") && map["f"] == Json("x")); */
    }
  // #region set T[string]