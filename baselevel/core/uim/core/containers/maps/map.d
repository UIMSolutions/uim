/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.map;

@safe:
import uim.core;

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

enum SORTED = true;
enum NOTSORTED = false;

// #region sortKeys
// Returns the keys of a map sorted in ascending or descending order.
string[] sortedKeys(T)(T[string] items, SortDir dir = SortDir.ASC) {
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

// #region newWithoutKeys
// Returns a new map without the specified keys
T[string] newWithoutKeys(T)(T[string] items, string[] keys...) {
  return newWithoutKeys(items, keys.dup);
}

// Returns a new map without the specified keys
T[string] newWithoutKeys(T)(T[string] items, string[] keys) {
  T[string] results = items.dup;
  keys
    .each!(key => results = results.newWithoutKey(key));

  return results;
}

// Returns a new map without the specified key
T[string] newWithoutKey(T)(T[string] items, string key) {
  T[string] results = items.dup;
  results.remove(key);
  return results;
}
unittest {
  auto base = ["a": 1, "b": 2, "c": 3];
  assert(base.length == 3);
  assert(base.hasKey("a") && base.hasKey("b") && base.hasKey("c"));

  auto result = base.newWithoutKey("a");
  assert(result.length == 2 && !result.hasKey("a") && result.hasKey("b") && result.hasKey("c"));

  result = base.newWithoutKeys(["b", "a"]);
  assert(result.length == 1);
  assert(!result.hasKey("a") && !result.hasKey("b") && result.hasKey("c"));
  assert(result.length == 1 && !result.hasKey("a") && !result.hasKey("b") && result.hasKey("c"));

  result = base.newWithoutKeys("a", "c", "b");
  assert(result.length == 0 && !result.hasKey("a") && !result.hasKey("b") && !result.hasKey("c"));

  result = base.newWithoutKeys(["a", "c", "b"]);
  assert(result.length == 0 && !result.hasKey("a") && !result.hasKey("b") && !result.hasKey("c"));
}
// #endregion newWithoutKeys

// #region withKeys
// returns a new map with only the specified keys
T[string] withKeys(T)(T[string] items, string[] keys...) {
  return withKeys(items, keys.dup);
}

// returns a new map with only the specified keys
T[string] withKeys(T)(T[string] items, string[] keys) {
  T[string] results;
  keys
    .filter!(key => items.hasKey(key))
    .each!(key => results[key] = items[key]);

  return results;
}

// returns a new map with only the specified keys
T[string] newWithKey(T)(T[string] items, string key) {
  T[string] results;
  if (items.hasKey(key)) {
    results[key] = items[key];
  }
  return results;
}

unittest {
  auto base = ["a": 1, "b": 2, "c": 3];
  assert(base.length == 3);
  assert(base.hasKey("a") && base.hasKey("b") && base.hasKey("c"));

  auto result = base.withKeys("b", "c");
  assert(result.length == 2 && !result.hasKey("a") && result.hasKey("b") && result.hasKey("c"));

  result = base.withKeys(["b", "c"]);
  assert(result.length == 2);
  assert(!result.hasKey("a") && result.hasKey("b") && result.hasKey("c"));

  result = base.newWithKey("c");
  assert(result.length == 1 && !result.hasKey("a") && !result.hasKey("b") && result.hasKey("c"));

  result = base.newWithKey("c");
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

// #region hasKey(s)
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
// #endregion hasKey(s)

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

// #region positions
size_t[][T] positions(T)(T[] values) {
  size_t[][T] results;
  foreach (i, value; values) {
    if (!results.hasKey(value)) {
      size_t[] positions = [i];
      results[value] = positions;
    }
    else {
      results[value] ~= i;
    }
  }
  return results;
}
unittest {
  assert(["a", "b", "c"].positions == ["a": [0UL], "b": [1UL], "c": [2UL]]);
  assert(["a", "b", "c", "c"].positions == ["a": [0UL], "b": [1UL], "c": [2UL, 3UL]]);
}
// #endregion positions

string toSqlUpdate(T)(T[string] items, bool sorted = NOTSORTED) {
  return items.sortKeys
    .map!(key => `%s=%s`.format(key, items[key]))
    .join(",");
}

unittest {
  auto map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);

  // assert(["a": 1, "b": 2].toSqlUpdate(SORTED) == `a=1,b=2`);
}

/// Checks if key exists and has values
bool hasValue(T)(T[string] items, string key, T value) {
  return (key in items)
    ? items[key] == value : false;
}

unittest {
  auto map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);

  // assert(["a": 1, "b": 2].hasValue("a", 1));
  // assert(!["a": 2, "b": 2].hasValue("a", 1));
  // assert(["a": 1, "b": 1].hasValue("a", 1));
  // assert(!["a": 2, "b": 1].hasValue("a", 1));
  // assert(["a": 1, "b": 2].hasValue("b", 2));
}

// #region hasValue
  // Checks if values exist in base
  bool hasAllValues(T)(T[string] items, T[string] checkItems) {
    return items.hasAllValues(checkItems.values);
  }

  bool hasAllValues(T)(T[string] items, T[] values...) {
    return items.hasAllValues(values.dup);
  }

  bool hasAllValues(T)(T[string] items, T[] values) {
    return values.all!(value => items.hasValue(value));
  }

  bool hasAnyValue(T)(T[string] items, T[string] checkItems) {
    return items.hasAnyValue(checkItems.values);
  }

  bool hasAnyValue(T)(T[string] items, T[] values...) {
    return items.hasAnyValue(values.dup);
  }

  bool hasAnyValue(T)(T[string] items, T[] values) {
    return values.any!(value => items.hasValue(value));
  }

  bool hasValue(T)(T[string] items, T check) {
    foreach(key, value; items) {
      if (check == value) return true;
    }
    return false;
  }

  unittest {
    auto map = ["1": 1, "2": 2, "3": 3];

    assert(map.hasValue(1)); 
    assert(!map.hasValue(5)); 

    assert(map.hasAnyValue(1, 2)); 
    assert(!map.hasAnyValue(6, 5)); 
    assert(map.hasAnyValue(1, 5)); 

    assert(map.hasAnyValue([1, 2])); 
    assert(!map.hasAnyValue([6, 5])); 
    assert(map.hasAnyValue([1, 5])); 

    assert(!map.hasAllValues(1, 5)); 
    assert(!map.hasAllValues(6, 5)); 
    assert(map.hasAllValues(1, 2)); 

    assert(!map.hasAllValues([1, 5])); 
    assert(!map.hasAllValues([6, 5])); 
    assert(map.hasAllValues([1, 2])); 
  }
// #endregion hasValue

// #region set
  T[string] set(T, V)(T[string] items, V[string] newItems) {
    newItems.each!((key, value) => items.set(key, value));
    return items;
  }

  T[string] set(T, V)(T[string] items, string[] keys, V value) {
    keys.each!(key => items.set(key, value));
    return items;
  }

  T[string] set(T : Json, V)(T[string] items, string key, V value) if (!is(V == T)) {
    items.set(key, value.toJson);
    return items;
  }

  T[string] set(T : string, V)(T[string] items, string key, V value) if (!is(V == T)) {
    items.set(key, value.toString);
    return items;
  }

  T[string] set(T, V)(T[string] items, string key, V value) if (is(V == T)) {
    items[key] = value;
    return items;
  }

  unittest {
    int[string] map1 = new int[string];
    map1.set("1", 1);
    assert(map1.length == 1 && map1.hasKey("1") && map1["1"] == 1);
    map1.set("1", 2);
    assert(map1.length == 1 && map1.hasKey("1") && map1["1"] == 2);

    string[string] map2 = new string[string];
    map2.set("1", "1");
    assert(map2.length == 1 && map2.hasKey("1") && map2["1"] == "1");
    map2.set("1", "2");
    assert(map2.length == 1 && map2.hasKey("1") && map2["1"] == "2");
    map2.set("1", 3);
    assert(map2.length == 1 && map2.hasKey("1") && map2["1"] == "3");

    Json[string] map3 = new Json[string];
    map3.set("1", Json("1"));
    assert(map3.length == 1 && map3.hasKey("1") && map3["1"] == Json("1"));
    map3.set("1", Json("2"));
    assert(map3.length == 1 && map3.hasKey("1") && map3["1"] == Json("2"));
    map3.set("1", 3);
    assert(map3.length == 1 && map3.hasKey("1") && map3["1"] == Json(3));

    auto map = ["1": 1, "2": 2, "3": 3];
    assert(map.length == 3);
    map.set(["4": 4]);
    assert(map.length == 4 && map.hasKey("4") && map["4"] == 4);
    assert(map.length == 4 && map.hasAllKeys("1", "2", "3", "4"));

    map = ["1": 1, "2": 2, "3": 3];
    map.set(["5", "6"], 0);
    assert(map.length == 5 && map.hasAllKeys("5", "6"));

    map = ["1": 1, "2": 2, "3": 3];
    map.set(["4": 4, "5": 5, "6": 6]);
    assert(map.length == 6 && map.hasAllKeys("4", "5", "6"));
  }
// #endregion set

// #region merge
  T[string] merge(T, V)(T[string] items, V[string] newItems) {
    newItems.each!((key, value) => items.merge(key, value));
    return items;
  }

  T[string] merge(T, V)(T[string] items, string[] keys, V value) {
    keys.each!(key => items.merge(key, value));
    return items;
  }

  T[string] merge(T : Json, V)(T[string] items, string key, V value) if (!is(V == T)) {
    items.merge(key, value.toJson);
    return items;
  }

  T[string] merge(T : string, V)(T[string] items, string key, V value) if (!is(V == T)) {
    items.merge(key, value.toString);
    return items;
  }

  T[string] merge(T, V)(T[string] items, string key, V value) if (is(V == T)) {
    if (!items.hasKey(key)) 
      items.set(key, value);
    return items;
  }

  unittest {
    auto map = ["1": 1, "2": 2, "3": 3];
    assert(map.length == 3);

    map.merge("4", 4);
    assert(map.length == 4 && map.hasKey("4"));

    map.merge("3", 0);
    assert(map.length == 4);
    assert(map["3"] == 3);

    map = ["1": 1, "2": 2, "3": 3];
    map.merge(["5", "6"], 0);
    assert(map.length == 5 && map.hasAllKeys("5", "6"));
    assert(map.length == 5 && map.hasAnyKey("5", "7"));

    map = ["1": 1, "2": 2, "3": 3];
    map.merge(["4": 4, "5": 5, "6": 6]);
    assert(map.length == 6 && map.hasAllKeys("4", "5", "6"));
  }
// #endregion merge

// #region update
T[string] update(T, V)(T[string] items, V[string] newItems) {
    newItems.each!((key, value) => items.update(key, value));
    return items;
  }

  T[string] update(T, V)(T[string] items, string[] keys, V value) {
    keys.each!(key => items.update(key, value));
    return items;
  }

  T[string] update(T : Json, V)(T[string] items, string key, V value) if (!is(V == T)) {
    items.update(key, value.toJson);
    return items;
  }

  T[string] update(T : string, V)(T[string] items, string key, V value) if (!is(V == T)) {
    items.update(key, value.toString);
    return items;
  }

  T[string] update(T, V)(T[string] items, string key, V value) if (is(V == T)) {
    if (items.hasKey(key)) 
      items.set(key, value);
    return items;
  }


  unittest {
    auto map = ["1": 1, "2": 2, "3": 3];
    assert(map.length == 3);

    map.update("4", 4);
    assert(map.length == 3 && !map.hasKey("4"));

    map.update("1", 0).update("2", 0);
    assert(map.length == 3 && map.hasAllKeys("1", "2", "3") && map["1"] == 0);

    map = ["1": 1, "2": 2, "3": 3];
    map.update(["1", "2"], 0);
    assert(map.length == 3 && map.hasAllKeys("1", "2", "3") && map["1"] == 0);

    map = ["1": 1, "2": 2, "3": 3];
    map.update(["1": 0, "2": 0, "3": 0]);
    assert(map.length == 3 && map.hasAllKeys("1", "2", "3") && map["1"] == 0);
  }
// #endregion update

// #region keyByValue
/* string keyByValue(T)(T[string] items, Json searchValue) {
  foreach (key, value; items) {
    if (value == searchValue)
      return key;
  }
  // return Null!K;
  return Json(null);
} */
// #endregion keyByValue

// #region intersect 
T[string] intersect(T)(T[string] left, T[string] right) {
  return left.intersect(right.keys);
}

T[string] intersect(T)(T[string] left, string[] right) {
  T[string] result;
  right
    .filter!(key => left.hasKey(key))
    .each!(key => result[key] = left[key]);

  return result;
}

/*   T[string] intersect(T[string] left, Json right) {
    return right.isArray
      ? intersect(left,
        right.toArray.map!(val => val.get!K).array) : null;
  } */

T[string] intersect(T)(T[string] left, Json right) {
  if (right.isArray) {
    return intersect(left,
      right.toArray.map!(val => val.get!V).array);
  }
  if (right.isObject) {
    return intersect(left,
      right.keys
        .map!(key => val.get(key, Null!V)).array);
  }
  return null;
}

unittest {
  auto map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);

  string[] keys = ["a", "x", "y"]; 
  // TODO
  /* // assert(left.intersect(keys).length == 1);
  // assert(left.intersect(keys)["a"] == "A");
  // assert(!left.intersect(keys).hasKey("b"));

  string[string] right = ["a": "A"].set("x", "X").set("y", "Y");
  // assert(left.intersect(right).length == 1);
  // assert(left.intersect(right)["a"] == "A");
  // assert(!intersect(left, right).hasKey("b")); */
}
// #endregion intersect 

// #region diff 
// Computes the difference of maps
T[string] diff(T)(T[string] left, T[string] right) {
  return left.diff(right.keys);
}

T[string] diff(T)(T[string] left, string[] right) {
  T[string] result;
  right
    .filter!(key => !left.hasKey(key))
    .each!(key => result[key] = left[key]);

  return result;
}

/*   T[string] diff(T[string] left, Json right) {
    return right.isArray
      ? diff(left,
        right.toArray.map!(val => val.get!K).array) : null;
  } */

T[string] diff(T)(T[string] left, Json right) {
  if (right.isObject) {
    return diff(left,
      right.keys
        .map!(key => val.get(key, Null!V)).array);
  }
  return left;
}

unittest {
  auto map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);

  string[] keys = ["a", "x", "y"];

  /* // assert(left.diff(keys).length == 2);
  // assert(left.diff(keys)["b"] == "B");
  // assert(!left.diff(keys).hasKey("b"));

  string[string] right =  ["a": "A"].set("x", "X").set("y", "Y");
  // assert(left.diff(right).length == 2);
  // assert(left.diff(right)["a"] == "A");
  // assert(!diff(left, right).hasKey("b")); */
}
// #endregion diff 

T[string] column(T)(T[string][] values, string key) {
  return values
    .filter!(value => value.hasKey(key))
    .map!(value => value[key])
    .array;
}

T[string] combine(T)(string[] keys, T[] values) {
  T[string] results;
  size_t lastIndex = min(keys.length, values.length);
  for (size_t i = 0; i < lastIndex; i++) {
    results[keys[i]] = values[i];
  }
  return results;
}

// #region createMap
T[string] createMap(T)(T[string] startItems = null) {
  T[string] map = startItems;
  return map;
}

unittest {
  auto map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);

  // testMap = createMap!(string, string)(["a": "A", "b": "B", "c": "C"]);
  // assert(!testMap.isEmpty);
}
// #endregion createMap

// #region clear
/* T[string] clear(T[string] items) {
  items = null;
  return items;
} */

unittest {
  auto map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);

  map.clear;
  // assert(testMap.length == 0);
}
// #endregion clear

// #region shift
T[] shift(T)(T[string] items, string[] keys...) {
  return items.shift(keys.dup);
}

T[] shift(T)(T[string] items, string[] keys) {
  return keys
    .filter!(key => items.hasKey(key))
    .map!(key => items.shift(key))
    .array;
}

T shift(T)(T[string] items, string key) {
  T result;
  if (items.hasKey(key)) {
    result = items[key];
    items.remove(key);
  }
  return result;
}

unittest {
  auto map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);
  assert(map.shift("1") == 1);
  assert(map.length == 2);

  map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);
  assert(map.shift(["1", "2", "3"]) == [1, 2, 3]);
  assert(map.length == 0);

  map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);
  assert(map.shift("2", "1", "3") == [2, 1, 3]);
  assert(map.length == 0);
}
// #endregion shift

// #region value
T[] values(T)(T[string] items, string[] keys) {
  return keys
    .filter!(key => items.hasKey(key))
    .map!(key => items[key])
    .array;
}

/* T value(T)(T[string] items, string key, T defaultValue) {
  return items.hasKey(key) ? items[key] : defaultValue;
} */

unittest {
  auto map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);
  // assert(map.value("1") == 1);
  assert(map.length == 3);

  map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);
  assert(map.values(["1", "2", "3"]) == [1, 2, 3]);
  assert(map.values(["1", "2", "2", "3"]) == [1, 2, 2, 3]);
  assert(map.length == 3);
}
// #endregion value

// #region isEmpty
bool isEmpty(T)(T[string] items) {
  return items.length == 0;
}

unittest {
  auto map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);

  // assert(testMap.length == 3);

  map.clear;
  // assert(testMap.isEmpty);
  // assert(testMap.isEmpty);
  // assert(testMap.length == 0);

  // map = createMap!(string, string);
  // assert(testMap.isEmpty);
  // assert(testMap.length == 0);

  /*   testMap = createMap!(string, string)
    .set("a", "A")
    .set("b", "B");
  // assert(!testMap.isEmpty);
  // assert(testMap.length == 2); */
}
// #endregion isEmpty
