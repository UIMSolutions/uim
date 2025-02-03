/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.keys.string_;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;
import uim.core.containers.maps.keys;
import uim.core.containers.maps.values;

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}
/// Add prefix to key
V[K] addPrefixKey(K : string, V)(ref V[K] items, K prefix) {
  items.dup.byKeyValue
    .each!(item => items = items.addPrefixKey(item.key, prefix));
  return items;
}

V[K] addPrefixKey(K, V)(ref V[K] items, K key, K prefix) if (is(K == string)) {
  if (prefix.isEmpty) {
    return items;
  }
  if (key.isEmpty) {
    return items;
  }
  items[prefix ~ key] = items[key];
  items = items.removeKey(key);
  return items;
}

unittest {
/*   assert(["a": "1", "b": "2"].addPrefixKey("b", "x").hasKey("xb"));
  assert(!["a": "1", "b": "2"].addPrefixKey("a", "x").hasKey("a"));
  assert(["a": "1", "b": "2"].addPrefixKey("b", "x")["xb"] == "2");
  assert(["a": "1", "b": "2"].addPrefixKey("b", "x")["a"] == "1"); */

/*   assert(["a": "1"].addPrefixKey("x")["xa"] == "1");
  assert(["a": "1", "b": "2"].addPrefixKey("x").hasKey("xb")); */
}

/// Selects only entries, where key starts with prefix. Creates a new DV[K]
V[K] allKeysStartsWith(K : string, V)(V[K] items, K prefix) {
  V[K] results;
  items.byKeyValue
    .filter!(item => item.key.startsWith(prefix))
    .each!(item => results[item.key] = item.value);
  return results;
}

unittest {
  assert(allKeysStartsWith(["preA": "a", "b": "b"], "pre") == ["preA": "a"]);
  assert(["preA": "a", "b": "b"].allKeysStartsWith("pre") == ["preA": "a"]);
}

// #region keysStartsNotWith
/// Opposite of selectStartsWith: Selects only entries, where key starts not with prefix. Creates a new DV[K]
V[K] keysStartsNotWith(K : string, V)(V[K] entries, K prefix) { // right will overright left
  V[K] results;
  foreach (k, v; entries)
    if (!k.startsWith(prefix))
      results[k] = v;
  return results;
}

unittest {
  assert(keysStartsNotWith(["preA": "a", "b": "b"], "pre") == ["b": "b"]);
  assert(["preA": "a", "b": "b"].keysStartsNotWith("pre") == ["b": "b"]);
}
// #endregion keysStartsNotWith

// #region keysEndsWith
bool allKeysEndsWith(K, V)(ref V[K] items, K postfix) if (is(K == string)) { // right will overright left
  return items.byKeyValue.all!(item => endsWith(item.key, postfix));
}

bool anyKeysEndsWith(K, V)(ref V[K] items, K postfix) if (is(K == string)) { // right will overright left
  return items.byKeyValue.any!(item => endsWith(item.key, postfix));
}

unittest {
/*   assert(allKeysEndsWith(["aPre": "a", "bPre": "b"], "Pre"));
  assert(["aPre": "a", "bPre": "b"].allKeysEndsWith("Pre"));

  assert(!allKeysEndsWith(["a": "a", "bPre": "b"], "Pre"));
  assert(!["aPre": "a", "b": "b"].allKeysEndsWith("Pre"));

  assert(anyKeysEndsWith(["aPre": "a", "b": "b"], "Pre"));
  assert(["aPre": "a", "b": "b"].anyKeysEndsWith("Pre"));

  assert(!anyKeysEndsWith(["a": "a", "b": "b"], "Pre"));
  assert(!["a": "a", "b": "b"].anyKeysEndsWith("Pre")); */
}
// #endregion keysEndsWith

// #region lowerKeys
V[K] lowerKeys(K : string, V)(ref V[K] items) {
  items.keys.each!(key => items.lowerKey(key));
  return items;
  ;
}

V[K] lowerKeys(K, V)(ref V[K] items, K[] keys...) if (is(K == string)) {
  return lowerKeys(items, keys.dup);
}

V[K] lowerKeys(K, V)(ref V[K] items, K[] keys) if (is(K == string)) {
  keys.each!(key => items.lowerKey(key));
  return items;
}

V[K] lowerKey(K, V)(ref V[K] items, K key) if (is(K == string)) {
  if (key !in items) {
    return items;
  }

  auto value = items[key];
  items.remove(key);
  items[key.lower] = value;
  return items;
}

unittest {
  int[string] testmap = ["one": 1, "Two": 2, "thRee": 3];
  assert(testmap.lowerKey("Two")["two"] == 2);
  // assert(testmap.lowerKeys["three"] == 3);
}
// #endregion lowerKeys

// #region upperKeys
V[K] upperKeys(K, V)(ref V[K] items) if (is(K == string)) {
  items.keys.each!(key => items.upperKey(key));
  return items;
  ;
}

V[K] upperKeys(K, V)(ref V[K] items, K[] keys...) if (is(K == string)) {
  return upperKeys(items, keys.dup);
}

V[K] upperKeys(K, V)(ref V[K] items, K[] keys) if (is(K == string)) {
  keys.each!(key => items.upperKey(key));
  return items;
}

V[K] upperKey(K, V)(ref V[K] items, string key) if (is(K == string)) {
  if (key !in items) {
    return items;
  }

  auto value = items[key];
  items.remove(key);
  items[key.upper] = value;
  return items;
}

unittest {
  int[string] testmap = ["one": 1, "Two": 2, "thRee": 3];
  assert(testmap.upperKey("Two")["TWO"] == 2);
  // assert(testmap.upperKeys["three"] == 3);
}
// #endregion upperKeys
