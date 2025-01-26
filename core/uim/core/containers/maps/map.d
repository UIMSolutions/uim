/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.map;

import uim.core;
@safe:

enum SORTED = true;
enum NOTSORTED = false;

size_t[V] indexAA(V)(V[] values, size_t startPos = 0) {
  size_t[V] results;
  foreach (i, value; values)
    results[value] = i + startPos;
  return results;
}

unittest {
  assert(["a", "b", "c"].indexAA == ["a": 0UL, "b": 1UL, "c": 2UL]);
  assert(["a", "b", "c"].indexAA(1) == ["a": 1UL, "b": 2UL, "c": 3UL]);
}

size_t[V] indexAAReverse(V)(V[] values, size_t startPos = 0) {
  size_t[V] results;
  foreach (i, value; values)
    results[i + startPos] = value;
  return results;
}

unittest {
  // Add Test
}

// #region hasValue
bool hasAllValues(K, V)(V[K] items, V[] values...) {
  return items.hasAllValues(values.dup);
}

bool hasAllValues(K, V)(V[K] items, V[] values) {
  return values.all!(value => items.hasValue(value));
}

bool hasAnyValues(K, V)(V[K] items, V[] values...) {
  return items.hasAnyValues(values.dup);
}

bool hasAnyValues(K, V)(V[K] items, V[] values) {
  return values.any!(value => items.hasValue(value));
}

bool hasValue(K, V)(V[K] items, V value) {
  return items.byKeyValue.any!(item => item.value == value);
}

unittest {
  // assert(["a": Json("A"), "c": Json("C")].hasValue("A"));
}
// #endregion hasAllValues

string toJSONString(K, V)(V[K] values, bool sorted = NOTSORTED) {
  string result = "{" ~ MapHelper.sortedKeys(values)
    .map!(key => `"%s": %s`.format(key, values[key]))
    .join(",") ~ "}";

  return result;
}

unittest {
  // assert(["a": 1, "b": 2].toJSONString(SORTED) == `{"a": 1,"b": 2}`);
}

string toHTML(K, V)(V[K] items, bool sorted = NOTSORTED) {

  return items.sortKeys(sorted ? "ASC" : "NONE")
    .map!(key => `%s="%s"`.format(key, items[key]))
    .join(" ");
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  // assert(["a": 1, "b": 2].toHTML(SORTED) == `a="1" b="2"`);
}

string toSqlUpdate(K, V)(V[K] items, bool sorted = NOTSORTED) {
  return items.sortKeys
    .map!(key => `%s=%s`.format(key, items[key]))
    .join(",");
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  // assert(["a": 1, "b": 2].toSqlUpdate(SORTED) == `a=1,b=2`);
}

/// Checks if key exists and has values
bool hasValue(K, V)(V[K] items, K key, V value) {
  return (key in items)
    ? items[key] == value : false;
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  // assert(["a": 1, "b": 2].hasValue("a", 1));
  // assert(!["a": 2, "b": 2].hasValue("a", 1));
  // assert(["a": 1, "b": 1].hasValue("a", 1));
  // assert(!["a": 2, "b": 1].hasValue("a", 1));
  // assert(["a": 1, "b": 2].hasValue("b", 2));
}

// Checks if values exist in base
bool hasValues(K, V)(V[K] items, V[K] otherItems) {
  return otherItems.byKeyValue
    .all!(other => other.key in items && items[other.key] == other.value);
}
///
unittest {
  writeln(__FILE__, "/", __LINE__);
  // assert(["a": 1, "b": 2].hasValues(["a": 1, "b": 2]));
  // assert(!["a": 1, "b": 2].hasValues(["a": 1, "b": 3]));
  // assert(!["a": 1, "b": 2].hasValues(["a": 1, "c": 2]));
}

V[K] setValues(K, V)(V[K] target, V[K] someValues) {
  // IN Check
  if (someValues.length == 0) {
    return target;
  }

  // BODY
  auto result = target;
  someValues.byKeyValue
    .each!(kv => result[kv.key] = kv.value);

  // OUT
  return result;
}
///
unittest {
  // TODO 
}

// #region ifNull
Json ifNull(K, V)(V[K] map, K key, Json defaultValue) {
  return key in map
    ? (!map[key].isNull ? map[key] : defaultValue) : defaultValue;
}
// #endregion ifNull

// #region hasKey
bool hasAnyKey(K, V)(V[K] map, K[] keys...) {
  return hasAnyKey(map, keys.dup);
}

unittest {
  STRINGAA testMap = [
    "a": "A", "b": "B", "c": "C"
  ];
  // assert(testMap.hasAnyKey("a", "b"));
  // assert(testMap.hasAnyKey("a", "x"));
  // assert(testMap.hasAnyKey("x", "y"));
}

bool hasAnyKey(K, V)(V[K] map, K[] keys) {
  return keys.any!(key => hasKey(map, key));
}

bool hasKey(K, V)(V[K] map, K key) {
  return (key in map) ? true : false;
}

unittest {
  STRINGAA testMap = [
    "a": "A", "b": "B", "c": "C"
  ];
  // assert(testMap.hasKey("a"));
  // assert(testMap.hasAnyKey("a", "b"));
  // assert(testMap.hasAnyKey("a", "x"));
  // assert(testMap.hasAllKeys("a", "b"));
  // assert(!testMap.hasAllKeys("a", "x"));
}
// #endregion hasKey

// #region set
V[K] set(K, V)(V[K] items, K[] keys, V value)
    /* if (
      (!is(K == string) && !is(V == Json)) &&
    (!is(K == string) && !is(V == string))) */ {
      auto results = items.dup;
  keys.each!(key => results.set(key, value));
  return results;
}

V[K] set(K, V)(V[K] items, K key, V value)
    /* if (
      (!is(K == string) && !is(V == Json)) &&
    (!is(K == string) && !is(V == string))) */ {
  items[key] = value;
  return items;
}

unittest {
  string[string] base = ["a": "A", "b": "B", "c": "C"];
  assert(base.length == 3);

  auto test = base.set("d", "D");
  assert(test.length == 4 && test.hasKey("d"));

  test = base.set(["d", "e", "f"], "x");
  assert(test.length == 6 && test.hasKey("d") && test["f"] == "x");

  Json[string] base2 = ["a": Json("A"), "b": Json("B"), "c": Json("C")];
  assert(base2.length == 3);

  auto test2 = base2.set("d", Json("x"));
  assert(test2.length == 4 && test2.hasKey("d"));

  test2 = base2.set(["d", "e", "f"], Json("x"));
  assert(test2.length == 6 && test2.hasKey("d") && test2["f"] == "x");
}
// #endregion set

// #region merge
/+ Merge new items if key not exists +/
V[K] merge(K, V)(V[K] items, V[K] mergeItems, K[] keys = null) {
  auto results = items.dup;
  keys.isNull
    ? mergeItems.byKeyValue
    .each!(item => results = results.merge(item.key, item.value)) : mergeItems.byKeyValue
    .filter!(item => !keys.has(item.key))
    .each!(item => results = results.merge(item.key, item.value));

  return results;
}

V[K] merge(K, V)(V[K] items, K[] keys, V value) {
  auto results = items.dup;
  keys
    .filter!(key => !(key in results))
    .each!(key => results[key] = value);
  return results;
}

V[K] merge(K, V)(V[K] items, K key, V value) {
  auto results = items.dup;
  if (key !in results) {
    results[key] = value;
  }
  return results;
}

unittest {
  string[string] base = ["a": "A", "b": "B"];
  assert(base.length == 2);

  auto test = base.merge("c", "C");
  assert(test.length == 3 && test.hasKey("c"));
  test = test.merge("a", "X");
  assert(test.length == 3);

  Json[string] base2 = ["a": Json("A"), "b": Json("B")];
  assert(base2.length == 2);

  auto test2 = base2.merge("c", Json("C"));
  assert(test2.length == 3 && test2.hasKey("c"));
  test2 = test2.merge("a", Json("X"));
  assert(test2.length == 3);
}
// #endregion merge

// #region update
// Returns a new map with updated values
V[K] update(K, V)(V[K] items, V[K] updateItems, K[] excludedKeys = null) {
  V[K] results = items.dup;
  updateItems.byKeyValue
    .filter!(updateItem => !excludedKeys.has(updateItem.key))
    .each!(updateItem => results = results.update(updateItem.key, updateItem.value));

  return results;
}

// Returns a new map with updated values
V[K] update(K, V)(V[K] items, K[] keys, V value) {
  V[K] results = items.dup;
  keys.each!(key => results = results.update(key, value));
  return results;
}

// Returns a new map with updated values
V[K] update(K, V)(V[K] items, K key, V value) {
  V[K] results = items.dup;
  if (key in items) {
    results[key] = value;
  }
  return results;
}
///
unittest {
  string[string] base = ["a": "A", "b": "B", "c": "C"];
  assert(base.length == 3);

  auto test = base.update("b", "X");
  assert(test.length == 3 && test.hasKey("b") && test["b"] == "X");

  Json[string] base2 = ["a": Json("A"), "b": Json("B"), "c": Json("C")];
  assert(base2.length == 3);

  auto test2 = base2.update("b", Json("X"));
  assert(test2.length == 3 && test2.hasKey("b")/*  && test2["b"] == "X" */);
}
// #endregion update

// #region remove
V[K] removeKeys(K, V)(V[K] items, K[] keys) {
  V[K] results = items.dup;
  keys.each!(key => removeKey(items, key));
  return items;
}

V[K] removePath(K, V)(V[K] items, K[] path) {
  V[K] results = items.dup;
  return !hasPath(items, path)
    ? items : items.removeKey(path.join("."));
}

V[K] removeKey(K, V)(V[K] items, K key) {
  V[K] results = items.dup;
  if (hasKey(items, key)) {
    items.remove(key);
  }
  return results;
}

unittest {
  /*   // assert(["a": "A", "b": "B", "c": "C"].length == 3);

  // assert(removeKey(["a": "A", "b": "B", "c": "C"], "a").length == 2);
  // assert(["a": "A", "b": "B", "c": "C"].removeKey("a").length == 2);
  // assert(["a": "A", "b": "B", "c": "C"].removeKey("x").length == 3);
  // assert(["a": "A", "b": "B", "c": "C"].removeKey("a")["b"] == "B");
  // assert(["a": "A", "b": "B", "c": "C"].removeKey("a").removeKey("a").length == 2);
  // assert(["a": "A", "b": "B", "c": "C"].removeKey("a").removeKey("b").length == 1);

  // assert(removeKeys(["a": "A", "b": "B", "c": "C"], "a").length == 2);
  // assert(removeKeys(["a": "A", "b": "B", "c": "C"], "a", "b").length == 1);
  // assert(removeKeys(["a": "A", "b": "B", "c": "C"], "a", "c", "b").length == 0);
  // assert(removeKeys(["a": "A", "b": "B", "c": "C"], "a", "b")["c"] == "C"); */
}
// #endregion remove

string keyByValue(K, V)(V[K] items, Json searchValue) {
  foreach (key, value; items) {
    if (value == searchValue)
      return key;
  }
  // return Null!K;
  return Json(null);
}

// #region intersect 
V[K] intersect(K, V)(V[K] left, V[K] right) {
  return left.intersect(right.keys);
}

V[K] intersect(K, V)(V[K] left, string[] right) {
  V[K] result;
  right
    .filter!(key => left.hasKey(key))
    .each!(key => result[key] = left[key]);

  return result;
}

/*   V[K] intersect(V[K] left, Json right) {
    return right.isArray
      ? intersect(left,
        right.toArray.map!(val => val.get!K).array) : null;
  } */

V[K] intersect(K, V)(V[K] left, Json right) {
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
  // TODO 
  /* string[string] left = ["a": "A"].set("b", "B").set("c", "C");

  string[] keys = ["a", "x", "y"]; */
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
V[K] diff(K, V)(V[K] left, V[K] right) {
  return left.diff(right.keys);
}

V[K] diff(K, V)(V[K] left, string[] right) {
  V[K] result;
  right
    .filter!(key => !left.hasKey(key))
    .each!(key => result[key] = left[key]);

  return result;
}

/*   V[K] diff(V[K] left, Json right) {
    return right.isArray
      ? diff(left,
        right.toArray.map!(val => val.get!K).array) : null;
  } */

V[K] diff(K, V)(V[K] left, Json right) {
  if (right.isObject) {
    return diff(left,
      right.keys
        .map!(key => val.get(key, Null!V)).array);
  }
  return left;
}

unittest {
  /*   string[string] left = ["a": "A"].set("b", "B").set("c", "C");
  string[] keys = ["a", "x", "y"];
 */
  /* // assert(left.diff(keys).length == 2);
  // assert(left.diff(keys)["b"] == "B");
  // assert(!left.diff(keys).hasKey("b"));

  string[string] right =  ["a": "A"].set("x", "X").set("y", "Y");
  // assert(left.diff(right).length == 2);
  // assert(left.diff(right)["a"] == "A");
  // assert(!diff(left, right).hasKey("b")); */
}
// #endregion diff 

V[K] column(V, K)(V[K][] values, string key) {
  return values
    .filter!(value => value.hasKey(key))
    .map!(value => value[key])
    .array;
}

V[K] combine(V, K)(string[] keys, Json[] values) {
  V[K] results;
  size_t lastIndex = min(keys.length, values.length);
  for (size_t i = 0; i < lastIndex; i++) {
    results[keys[i]] = values[i];
  }
  return results;
}

// #region unique
/// Unique - Reduce duplicates in array
V[K] unique(K, V)(V[K] items) {
  V[K] results;
  V[K] values;
  items.byKeyValue.each!((item) {
    if (!values.hasKey(item.value)) {
      values[item.value] = item.value;
      results[item.key] = item.value;
    }
  });
  return results;
}

unittest {
  // assert(["a": "A", "b": "B", "c": "C"].unique.length == 3);
  // assert(["a": "A", "b": "B", "c": "C", "d": "C"].unique.length == 3);
}
// #endregion unique

// #region createMap
V[K] createMap(K, V)(V[K] startItems = null) {
  V[K] map = startItems;
  return map;
}

unittest {
  STRINGAA testMap = createMap!(string, string);
  // assert(testMap.isEmpty);

  testMap = createMap!(string, string)(["a": "A", "b": "B", "c": "C"]);
  // assert(!testMap.isEmpty);
}
// #endregion createMap

// #region clear
/* V[K] clear(V[K] items) {
  items = null;
  return items;
} */

unittest {
  STRINGAA testMap = ["a": "A", "b": "B", "c": "C"];
  // assert(testMap !is null);

  testMap.clear;
  // assert(testMap.length == 0);
}
// #endregion clear

// #region shift
V[K] shift(K, V)(V[K] items, K[] keys) {
  V[K] result;
  keys
    .filter!(key => items.hasKey(key))
    .each!(key => result[key] = items.shift(key));
  return result;
}

V shift(K, V)(V[K] items, K key) {
  V result;
  if (key in items)
    result = items[key];
  items.remove(key);
  return result;
}

unittest {
  STRINGAA testMap = ["a": "A", "b": "B", "c": "C"];
  // assert(testMap.length == 3);
  // assert(testMap.shift("b") == "B");
  // assert(testMap.length == 2);

  auto map = testMap.shift(["a", "b", "c"]);
  // assert(testMap.length == 0);
  // assert(map.length == 2);
  // assert(map["a"] == "A");
}
// #endregion shift

K value(K, V)(V[K] items, string key, K defaultValue) {
  return key in items ? items[key] : defaultValue;
}

// #region isEmpty
bool isEmpty(K, V)(V[K] items) {
  return items.length == 0;
}

unittest {
  STRINGAA testMap = ["a": "A", "b": "B", "c": "C"];
  // assert(!testMap.isEmpty);

  // assert(testMap.length == 3);

  testMap.clear;
  // assert(testMap.isEmpty);
  // assert(testMap.isEmpty);
  // assert(testMap.length == 0);

  testMap = createMap!(string, string);
  // assert(testMap.isEmpty);
  // assert(testMap.length == 0);

  /*   testMap = createMap!(string, string)
    .set("a", "A")
    .set("b", "B");
  // assert(!testMap.isEmpty);
  // assert(testMap.length == 2); */
}
// #endregion isEmpty
