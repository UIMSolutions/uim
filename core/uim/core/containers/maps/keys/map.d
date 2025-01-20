/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.keys.map;

@safe:
import uim.core;

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

// #region notfilter
V[K] notFilterByKeys(K, V)(V[K] entries, K[] keys...) {
  return notFilterByKeys(entries, keys.dup);
}

V[K] notFilterByKeys(K, V)(V[K] entries, K[] keys) {
  V[K] results = entries.dup;
  keys
    .filter!(key => results.hasKey(key))
    .each!(key => results.remove(key));

  return results;
}

V[K] notFilterByKey(K, V)(V[K] entries, K key) {
  V[K] results;

  return !entries.hasKey(key)
    ? results.set(key, entries.get(key))
    : results;
}

unittest {
  assert(["a": 1, "b": 2].length == 2);
  assert(["a": 1, "b": 2].hasKey("a"));
  assert(["a": 1, "b": 2].hasKey("b"));

/*   assert(["a": 1, "b": 2].notFilterByKey("b").length == 1);
  assert(["a": 1, "b": 2].hasKey("a"));
  assert(!["a": 1, "b": 2].hasKey("b"));

  assert(["a": 1, "b": 2].notFilterByKeys("b").length == 1);
  assert(["a": 1, "b": 2].hasKey("a"));
  assert(!["a": 1, "b": 2].hasKey("b")); */
}
// #endregion notfilter

// #region filter
V[K] filterByKeys(K, V)(V[K] entries, K[] keys...) {
  return filterByKeys(entries, keys.dup);
}

V[K] filterByKeys(K, V)(V[K] entries, K[] keys) {
  V[K] results;
  keys
    .filter!(key => entries.hasKey(key))
    .each!(key => results[key] = entries[key]);

  return results;
}

V[K] filterByKey(K, V)(V[K] entries, K key) {
  V[K] results;

  return entries.hasKey(key)
    ? results.set(key, entries[key])
    : results;
}

unittest {
  assert(["a": 1, "b": 2].length == 2);
  assert(["a": 1, "b": 2].hasKey("a"));
  assert(["a": 1, "b": 2].hasKey("b"));

  assert(["a": 1, "b": 2].filterByKey("a").length == 1);
  assert(["a": 1, "b": 2].hasKey("a"));
  assert(!["a": 1, "b": 2].hasKey("c"));

  assert(["a": 1, "b": 2].filterByKeys("a").length == 1);
  assert(["a": 1, "b": 2].hasKey("a"));
  assert(!["a": 1, "b": 2].hasKey("c"));
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
