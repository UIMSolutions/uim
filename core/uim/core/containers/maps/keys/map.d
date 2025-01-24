/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.keys.map;

@safe:
import uim.core;

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

// #region sortKeys

// Returns the keys of a map sorted in ascending or descending order.
pure K[] sortKeys(K, V)(V[K] items, SortDir dir = SortDir.ASC) {
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
  assert(testMap.sortKeys == ["a", "b"]);
  assert(testMap.sortKeys(SortDir.DESC) == ["b", "a"]);
}
// #endregion sortKeys

// #region withoutKeys
// Returns a new map without the specified keys
pure V[K] withoutKeys(K, V)(V[K] entries, K[] keys...) {
  return withoutKeys(entries, keys.dup);
}

// Returns a new map without the specified keys
pure V[K] withoutKeys(K, V)(V[K] entries, K[] keys) {
  V[K] results = entries.dup;
  keys
    .filter!(key => entries.hasKey(key))
    .each!(key => results.remove(key));

  return results;
}

// Returns a new map without the specified key
pure V[K] withoutKey(K, V)(V[K] entries, K key) {
  V[K] results = entries.dup;
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
pure V[K] filterKeys(K, V)(V[K] entries, K[] keys...) {
  return filterKeys(entries, keys.dup);
}

// returns a new map with only the specified keys
pure V[K] filterKeys(K, V)(V[K] entries, K[] keys) {
  V[K] results;
  keys
    .filter!(key => entries.hasKey(key))
    .each!(key => results[key] = entries[key]);

  return results;
}

// returns a new map with only the specified keys
pure V[K] filterKey(K, V)(V[K] entries, K key) {
  V[K] results;
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

// #region replaceKey
V[K] replaceKey(K, V)(V[K] entries, K[] originalPath, K[] newPath) {
  if (originalPath.length != newPath.length) {
    return entries;
  }

  // TODO 
  return entries;
}

V[K] replaceKey(K, V)(V[K] entries, K originalKey, K newKey) {
  if (!entries.hasKey(originalKey)) {
    return entries;
  }

  V value = entries.shift(originalKey);
  entries.set(newKey, value);

  return entries;
}

///
unittest {
  auto testMap = MapHelper.create!(string, Json)
    .set("a", "A")
    .set("obj", MapHelper.create!(string, Json).set("b", "B"));

  assert(!testMap.hasKey("A"));
  assert(testMap.getString("a") == "A");
  assert(testMap.replaceKey("a", "A"));
  assert(testMap.hasKey("A"));
  assert(testMap.getString("A") == "A");
}
// #endregion replaceKey

// #region hasKeys
bool hasAllKeys(K, V)(V[K] base, K[] keys...) {
  return base.hasAllKeys(keys.dup);
}

bool hasAllKeys(K, V)(V[K] base, string[] keys) {
  return keys.all!(key => base.hasKey(key));
}
///
unittest {
  assert(["a": 1, "b": 2, "c": 3].hasAllKeys(["a", "b", "c"]));
  assert(!["a": 1, "b": 2, "c": 3].hasAllKeys(["x", "b", "c"]));

  assert(["a": "A", "c": "C"].hasAllKeys("a"));
  assert(["a": "A", "c": "C"].hasAllKeys("a", "c"));

  assert(["a": "A", "c": "C"].hasAllKeys(["a"]));
  assert(["a": "A", "c": "C"].hasAllKeys(["a", "c"]));

  assert(!["a": "A", "c": "C"].hasAllKeys("x"));
  assert(!["a": "A", "c": "C"].hasAllKeys("x", "c"));

  assert(!["a": "A", "c": "C"].hasAllKeys(["x"]));
  assert(!["a": "A", "c": "C"].hasAllKeys(["x", "c"]));
}

bool hasAnyKeys(K, V)(V[K] base, string[] keys...) {
  return base.hasAnyKeys(keys.dup);
}

bool hasAnyKeys(K, V)(V[K] base, string[] keys) {
  return keys.any!(key => base.hasKey(key));
}
///
unittest {
  assert(["a": "A", "c": "C"].hasAnyKeys("a"));
  assert(["a": "A", "c": "C"].hasAnyKeys("a", "x"));

  assert(["a": "A", "c": "C"].hasAnyKeys(["a"]));
  assert(["a": "A", "c": "C"].hasAnyKeys(["a", "x"]));

  assert(!["a": "A", "c": "C"].hasAnyKeys("x"));
  assert(!["a": "A", "c": "C"].hasAnyKeys("x", "y"));

  assert(!["a": "A", "c": "C"].hasAnyKeys(["x"]));
  assert(!["a": "A", "c": "C"].hasAnyKeys(["x", "y"]));
}
// #endregion hasKey
