/***********************************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              
	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       
	Authors: Ozan Nurettin Süel (UIManufaktur)										                          
***********************************************************************************************************************/
module uim.core.containers.maps.map;

@safe:
import uim.core;

enum SORTED = true;
enum NOTSORTED = false;

// #region sortKeys
string[] sortKeys(T)(T[string] items, string mode = "ASC") {
  switch(mode) {
    case "DESC": return items.keys.sort("a > b").array;
    default: return items.keys.sort.array;
  }
}
unittest {
  string[string] testMap = ["a":"A", "b":"B"];
  assert(testMap.sortKeys == ["a", "b"]);
  assert(testMap.sortKeys("DESC") == ["b", "a"]);
}
// #endregion sortKeys

/// get keys of an associative array
/// sorted = false (default) returns an unsorted array, sorted = true returns a sorted array
string[] getKeys(T)(T[string] aa, bool sorted = false) {
  string[] results = aa.keys;

  return sorted
    ? results.sort.array : results;
}
///
unittest {
  // getKeys(aa) == aa.keys; getKeys(aa, true) == aa.keys.sort.array	

  // Using scalars
  assert([1: 4, 2: 5, 3: 6].getKeys(true) == [1, 2, 3]);
  assert([1: "4", 2: "5", 3: "6"].getKeys(true) == [1, 2, 3]);
  assert(["1": 4, "2": 5, "3": 6].getKeys(true) == ["1", "2", "3"]);
  assert(["1": "4", "2": "5", "3": "6"].getKeys(true) == ["1", "2", "3"]);

  // Using objects
  class DTest {
  }

  auto a = new DTest;
  auto b = new DTest;
  auto c = new DTest;
  assert([1: a, 2: b, 3: c].getKeys(true) == [1, 2, 3]);
}

/// get values of an associative array - currently not working für objects
V[] getValues(T)(T[string] aa, bool sorted = NOTSORTED) {
  V[] results = aa.values.map!(v => v).array;

  return sorted
    ? results.sort.array : results;
}

version (test_uim_core) {
  unittest {
    assert([1: 4, 2: 5, 3: 6].getValues(SORTED) == [4, 5, 6]);
    assert([1: "4", 2: "5", 3: "6"].getValues(SORTED) == ["4", "5", "6"]);
    assert(["1": 4, "2": 5, "3": 6].getValues(SORTED) == [4, 5, 6]);
    assert(["1": "4", "2": "5", "3": "6"].getValues(SORTED) == [
        "4", "5", "6"
      ]);
  }
}

// Add Items from array
T[string] add(T)(T[string] origin, T[string] newValues, bool shouldOverwrite = false) {
  T[string] results = origin.dup;
  newValues.byKeyValue
    .filter!(kv => shouldOverwrite || (kv.key !in results))
    .each!(kv => results[kv.key] = kv.value);
  return results;
}
///
unittest {
  assert([1: "b", 2: "C"].add([3: "f"]) == [1: "b", 2: "C", 3: "f"]);
  assert(["a": "A", "c": "C"].add(["e": "f"]) == [
      "a": "A",
      "c": "C",
      "e": "f"
    ]);
  assert(["a": "A", "c": "C"].add(["e": "f"])
      .add(["g": "h"]) == ["a": "A", "c": "C", "e": "f", "g": "h"]);
}

/// remove subItems from baseItems if key and value of item are equal
T[string] sub(T)(T[string] baseItems, T[string] subItems) {
  T[string] results = baseItems.dup;
  foreach (k, v; subItems)
    if ((k in results) && (results[k] == v))
      results.remove(k);
  return results;
}
///
unittest {
  assert([1: "4", 2: "5", 3: "6"].sub([1: "5", 2: "5", 3: "6"]) == [
      1: "4"
    ]);
}

pure size_t[T] indexAA(T)(T[] values, size_t startPos = 0) {
  size_t[T] results;
  foreach (i, value; values)
    results[value] = i + startPos;
  return results;
}

version (test_uim_core) {
  unittest {
    assert(["a", "b", "c"].indexAA == ["a": 0UL, "b": 1UL, "c": 2UL]);
    assert(["a", "b", "c"].indexAA(1) == ["a": 1UL, "b": 2UL, "c": 3UL]);
  }
}

pure size_t[T] indexAAReverse(T)(T[] values, size_t startPos = 0) {
  size_t[T] results;
  foreach (i, value; values)
    results[i + startPos] = value;
  return results;
}

version (test_uim_core) {
  unittest {
    // Add Test
  }
}

// #region hasAllKeys
bool hasAllKeys(T)(T[string] base, string[] keys...) {
  return base.hasAllKeys(keys.dup);
}

bool hasAllKeys(T)(T[string] base, string[] keys) {
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
// #endregion hasAllKeys

// #region hasAnyKey
bool hasAnyKeys(T)(T[string] base, V[] keys...) {
  return base.hasAnyKeys(keys.dup);
}

bool hasAnyKeys(T)(T[string] base, V[] keys) {
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
// #endregion hasAnyKey

bool hasKey(T)(T[string] base, K key) {
  return (key in base)
    ? true : false;
}
///
unittest {
  assert(["a": "A", "c": "C"].hasKey("a"));
  assert(!["a": "A", "c": "C"].hasKey("x"));
}

// #region hasValue
bool hasAllValues(T)(T[string] items, V[] values...) {
  return items.hasAllValues(values);
}

bool hasAllValues(T)(T[string] items, V[] values) {
  return values.all!(value => items.hasValue(value));
}

bool hasAnyValues(T)(T[string] items, V[] values...) {
  return items.hasAnyValues(values);
}

bool hasAnyValues(T)(T[string] items, V[] values) {
  return values.any!(value => items.hasValue(value));
}

bool hasValue(T)(T[string] items, V value) {
  return items.byKeyValue.any!(item => item.value == value);
}

unittest {
  assert(["a": "A", "c": "C"].hasValue("A"));
  assert(!["a": "A", "c": "C"].hasValue("x"));

  assert(["a": "A", "c": "C"].hasAnyValues("A"));
  assert(["a": "A", "c": "C"].hasAnyValues("A", "x"));
  assert(["a": "A", "c": "C"].hasAnyValues(["A"]));
  assert(["a": "A", "c": "C"].hasAnyValues(["A", "x"]));
  assert(!["a": "A", "c": "C"].hasAnyValues(["x", "y"]));

  assert(["a": "A", "c": "C"].hasAllValues("A"));
  assert(["a": "A", "c": "C"].hasAllValues("A", "C"));
  assert(["a": "A", "c": "C"].hasAllValues(["A"]));
  assert(["a": "A", "c": "C"].hasAllValues(["A", "C"]));
  assert(!["a": "A", "c": "C"].hasAllValues(["A", "x"]));
  assert(!["a": "A", "c": "C"].hasAllValues(["x", "y"]));
}
// #endregion hasAllValues

pure string toJSONString(T)(T[string] values, bool sorted = NOTSORTED) {
  string result = "{" ~ values
    .getKeys(sorted)
    .map!(key => `"%s": %s`.format(key, values[key]))
    .join(",") ~ "}";

  return result;
}

unittest {
  assert(["a": 1, "b": 2].toJSONString(SORTED) == `{"a": 1,"b": 2}`);
}

pure string toHTML(T)(T[string] values, bool sorted = NOTSORTED) {
  string result = values
    .getKeys(sorted)
    .map!(key => `%s="%s"`.format(key, values[key])).join(" ");

  return result;
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  assert(["a": 1, "b": 2].toHTML(SORTED) == `a="1" b="2"`);
}

pure string toSqlUpdate(T)(T[string] values, bool sorted = NOTSORTED) {
  string result = values
    .getKeys(sorted)
    .map!(key => `%s=%s`.format(key, values[key]))
    .join(",");

  return result;
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  assert(["a": 1, "b": 2].toSqlUpdate(SORTED) == `a=1,b=2`);
}

/// Checks if key exists and has values
pure bool isValue(T)(T[string] base, K key, V value) {
  return (key in base)
    ? base[key] == value : false;
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  assert(["a": 1, "b": 2].isValue("a", 1));
  assert(!["a": 2, "b": 2].isValue("a", 1));
  assert(["a": 1, "b": 1].isValue("a", 1));
  assert(!["a": 2, "b": 1].isValue("a", 1));
  assert(["a": 1, "b": 2].isValue("b", 2));
}

// Checks if values exist in base
pure bool isValues(T)(T[string] base, T[string] values) {
  foreach (k; values.getKeys) {
    if (k !in base) {
      return false;
    }
    if (base[k] != values[k]) {
      return false;
    }
  }
  return true;
}
///
unittest {
  writeln(__FILE__, "/", __LINE__);
  assert(["a": 1, "b": 2].isValues(["a": 1, "b": 2]));
  assert(!["a": 1, "b": 2].isValues(["a": 1, "b": 3]));
  assert(!["a": 1, "b": 2].isValues(["a": 1, "c": 2]));
}

bool isEmpty(V, K)(T[string] someValues) {
  return (someValues.length == 0);
}
///
unittest {
  STRINGAA map = ["a":"A", "b": "B"];
  assert(map.length == 2, "Wrong length: Should be 2");
  map.clear;
  assert(map.length == 0, "Wrong length: Should be 0");
  assert(map.isEmpty, "Wrong result for isEmpty: Should be true");
}

T[string] setValues(T)(T[string] target, T[string] someValues) {
  // IN Check
  if (someValues.isEmpty) {
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
V ifNull(T)(T[string] map, K key, V defaultValue) {
  return key in map
    ? (!map[k].isNull ? map[k] : defaultValue) : defaultValue;
}
// #endregion ifNull

// #region isSet
bool isSetAny(T)(T[string] map, string[] keys...) {
  return isSetAny(map, keys.dup);
}

bool isSetAny(T)(T[string] map, string[] keys) {
  return keys.any!(key => isSet(map, key));
}

bool isSetAll(T)(T[string] map, string[] keys...) {
  return isSetAll(map, keys.dup);
}

bool isSetAll(T)(T[string] map, string[] keys) {
  return keys.all!(key => isSet(map, key));
}

bool isSet(T)(T[string] map, K key) {
  return (key in map) ? true : false;
}

unittest {
  STRINGAA testMap = [
    "a": "A", "b": "B", "c": "C"
  ];
  assert(testMap.isSet("a"));
  assert(testMap.isSetAny("a", "b"));
  assert(testMap.isSetAny("a", "x"));
  assert(testMap.isSetAll("a", "b"));
  assert(!testMap.isSetAll("a", "x"));
}
// #endregion isSet

// #region set
T[string] set(T)(T[string] values, string[] keys, V value = Null!V) {
  keys.each!(key => values.set(key, value));
  return values;
}

T[string] set(T)(T[string] values, K key, V value = Null!V) if (!isType!Json) {
  values[key] = value;
  return values;
}

unittest {
  string[string] testmap;
  // TODO 
  /* assert(set(testmap, "a", "A")["a"] == "A");
  assert(set(testmap, "a", "A").set("b", "B")["b"] == "B"); */
}
// #endregion set

// #region merge
/+ Merge new items if key not exists +/
T[string] merge(T)(T[string] items, T[string] mergeItems, string[] includedKeys = null) {
  includedKeys.isNull
    ? mergeItems.byKeyValue.each!(item => items.merge(item.key, item.value)) : mergeItems
    .byKeyValue
    .filter!(item => !includedKeys.has(item.key))
    .each!(item => items.merge(item.key, item.value));

  return items;
}

T[string] merge(T)(T[string] items, string[] keys, V value) {
  keys.each!(key => items.merge(key, value));
  return items;
}

T[string] merge(T)(T[string] items, K key, V value) {
  if (!items.hasKey(key)) {
    items[key] = value;
  }
  return items;
}

unittest {
  string[string] map = ["a": "A", "b": "B"];
  assert(map.length == 2);
  assert(map.merge("c", "C"));
  assert(map.length == 3);
  assert(map.merge("a", "X"));
  assert(map.length == 3);
}
// #endregion merge

// #region update
T[string] update(T)(T[string] items, T[string] updateItems, string[] excludedKeys = null) {
  updateItems.byKeyValue
    .filter!(updateItem => !excludedKeys.has(updateItem.key))
    .each!(updateItem => update(items, updateItem.key, updateItem.value));

  return items;
}

T[string] update(T)(T[string] items, K key, V value) {
  if (key in items) {
    items[key] = value;
  }
  return items;
}
///
unittest {
  assert(["a": "A", "b": "B", "c": "C"].length == 3);

  assert(["a": "A", "b": "B", "c": "C"].update("a", "x").length == 3);
  assert(["a": "A", "b": "B", "c": "C"].update("a", "x")["a"] == "x");

  assert(["a": "A", "b": "B", "c": "C"].update("x", "y").length == 3);

  assert(["a": "A", "b": "B", "c": "C"].update(["a": "x"]).length == 3);
  assert(["a": "A", "b": "B", "c": "C"].update(["a": "x"])["a"] == "x");

  assert(["a": "A", "b": "B", "c": "C"].update(["a": "x", "b": "y"], ["b"]).length == 3);
  assert(["a": "A", "b": "B", "c": "C"].update(["a": "x", "b": "y"], ["b"])["a"] == "x");
  assert(["a": "A", "b": "B", "c": "C"].update(["a": "x", "b": "y"], ["b"])["b"] == "B");
}
// #endregion update

// #region updateKeys
/+ Update existing keys +/
T[string] update(T)(T[string] values, string[] keys, V value = Null!V) {
  keys.each!(key => values.update(key, value));
  return values;
}

unittest {
  assert(["a": "A", "b": "B", "c": "C"].length == 3);

  assert(["a": "A", "b": "B", "c": "C"].update("a", "x").length == 3);
  assert(["a": "A", "b": "B", "c": "C"].update("a", "x")["a"] == "x");

  assert(["a": "A", "b": "B", "c": "C"].update(["a"], "x").length == 3);
  assert(["a": "A", "b": "B", "c": "C"].update(["a"], "x")["a"] == "x");
  assert(["a": "A", "b": "B", "c": "C"].update(["a", "b"], "x")["b"] == "x");

  assert(["a": "A", "b": "B", "c": "C"].update("a", "x").length == 3);
  assert(["a": "A", "b": "B", "c": "C"].update("a", "x")["a"] == "x");
  assert(["a": "A", "b": "B", "c": "C"].update("a", "x")["b"] != "x");
}
// #endregion updateKeys

// #region remove
T[string] remove(T)(T[string] items, string[] keys...) {
  remove(items, keys.dup);
  return items;
}

T[string] remove(T)(T[string] items, string[] keys) {
  keys.each!(key => remove(items, key));
  return items;
}

T[string] remove(T)(T[string] items, K key) {
  if (hasKey(items, key))
    items.remove(key);
  return items;
}

unittest {
  assert(["a": "A", "b": "B", "c": "C"].length == 3);
  assert(uim.core.containers.map.remove(["a": "A", "b": "B", "c": "C"], "a").length == 2);
  assert(uim.core.containers.map.remove(["a": "A", "b": "B", "c": "C"], "a", "b").length == 1);
  assert(uim.core.containers.map.remove(["a": "A", "b": "B", "c": "C"], "a").length == 2);

  assert(uim.core.containers.map.remove(["a": "A", "b": "B", "c": "C"], "a")["c"] == "C");
  assert(uim.core.containers.map.remove(["a": "A", "b": "B", "c": "C"], "a", "b")["c"] == "C");
  assert(uim.core.containers.map.remove(["a": "A", "b": "B", "c": "C"], "a")["c"] == "C");
}
// #endregion remove

// #region removeByValues
T[string] removeByValues(T)(T[string] items, V[] values...) {
  return removeByValues(items, values.dup);
}

T[string] removeByValues(T)(T[string] items, V[] values) {
  values.each!(value => removeByValue(items, value));
  return items;
}

T[string] removeByValue(T)(T[string] items, V value) {
  return null; // TODO
  /*   return hasValue(items, value)
    ? items.remove(keyByValue(items, value)) : items; */
}

unittest {
  assert(["a": "A", "b": "B", "c": "C"].length == 3);
  /* 
  assert(["a": "A", "b": "B", "c": "C"].removeByValue("A").length == 2);
  assert(["a": "A", "b": "B", "c": "C"].removeByValue("A")["c"] == "C");

  assert(["a": "A", "b": "B", "c": "C"].removeByValues("A").length == 2);
  assert(["a": "A", "b": "B", "c": "C"].removeByValues(["A", "B"]).length == 1);
  assert(["a": "A", "b": "B", "c": "C"].removeByValues("A", "B").length == 1);

  assert(["a": "A", "b": "B", "c": "C"].removeByValues("A")["c"] == "C");
  assert(["a": "A", "b": "B", "c": "C"].removeByValues(["A", "B"])["c"] == "C");
  assert(["a": "A", "b": "B", "c": "C"].removeByValues("A", "B")["c"] == "C"); */
}
// #endregion removeByValues

K keyByValue(T)(T[string] items, V searchValue) {
  foreach (key, value; items) {
    if (value == searchValue)
      return key;
  }
  return Null!K;
}

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

T[string] intersect(T)(T[string] left, Json right) {
  return right.isArray
    ? intersect(left,
      right.toArray.map!(val => val.get!K).array) : null;
}

T[string] intersect(T)(T[string] left, Json right) {
  if (right.isArray) {
    return intersect(left,
      right.toArray.map!(val => val.get!T).array);
  }
  if (right.isObject) {
    return intersect(left,
      right.keys
        .map!(key => val.get(key, Null!T)).array);
  }
  return null;
}

unittest {
  // TODO 
  /* string[string] left = ["a": "A"].set("b", "B").set("c", "C");

  string[] keys = ["a", "x", "y"]; */
  // TODO
  /* assert(left.intersect(keys).length == 1);
  assert(left.intersect(keys)["a"] == "A");
  assert(!left.intersect(keys).hasKey("b"));

  string[string] right = ["a": "A"].set("x", "X").set("y", "Y");
  assert(left.intersect(right).length == 1);
  assert(left.intersect(right)["a"] == "A");
  assert(!intersect(left, right).hasKey("b")); */
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

T[string] diff(T)(T[string] left, Json right) {
  return right.isArray
    ? diff(left,
      right.toArray.map!(val => val.get!K).array) : null;
}

T[string] diff(T)(T[string] left, Json right) {
  if (right.isArray) {
    return diff(left,
      right.toArray.map!(val => val.get!T).array);
  }
  if (right.isObject) {
    return diff(left,
      right.keys
        .map!(key => val.get(key, Null!T)).array);
  }
  return null;
}

unittest {
  // string[string] left = ["a": "A"].set("b", "B").set("c", "C");

  // TODO 
  /*   string[] keys = ["a", "x", "y"];
  assert(left.diff(keys).length == 2);
  assert(left.diff(keys)["b"] == "B");
  assert(!left.diff(keys).hasKey("b"));

  string[string] right =  ["a": "A"].set("x", "X").set("y", "Y");
  assert(left.diff(right).length == 2);
  assert(left.diff(right)["a"] == "A");
  assert(!diff(left, right).hasKey("b")); */
}
// #endregion diff 

T[string] column(V, K)(T[string][] values, K key) {
  return values
    .filter!(value => value.hasKey(key))
    .map!(value => value[key])
    .array;
}

T[string] combine(V, K)(string[] keys, V[] values) {
  T[string] results;
  size_t lastIndex = min(keys.length, values.length);
  for (size_t i = 0; i < lastIndex; i++) {
    results[keys[i]] = values[i];
  }
  return results;
}

// #region filterValues
T[string] filterValues(T)(T[string] items) {
  T[string] results;
  items.byKeyValue
    .filter!(item => !item.value.isNull)
    .each!(item => results[item.key] = item.value);

  return results;
}

T[string] filterValues(T)(T[string] items, bool delegate(K key, V value) check) {
  T[string] results;
  () @trusted {
    items.byKeyValue
      .filter!(item => check(item.key, item.value))
      .each!(item => results[item.key] = item.value);
  }();
  return results;
}

unittest {
  auto testString = ["a": "1", "b": null, "c": "3"];
  assert(testString.filterValues().length == 2);
  writeln(testString.filterValues());

  auto testValues = ["a": 1, "b": 2, "c": 3];
  bool foo(string key, int value) {
    return value > 1;
  }

  assert(testValues.filterValues(&foo).length == 2);
}
// #endregion filterValues

// #region unique
/// Unique - Reduce duplicates in array
T[string] unique(T)(T[string] items) {
  T[string] results;
  V[V] values;
  items.byKeyValue.each!((item) {
    if (!values.hasKey(item.value)) {
      values[item.value] = item.value;
      results[item.key] = item.value;
    }
  });
  return results;
}

unittest {
  assert(["a": "A", "b": "B", "c": "C"].unique.length == 3);
  assert(["a": "A", "b": "B", "c": "C", "d": "C"].unique.length == 3);
}
// #endregion unique

pure T[string] createMap(T)() {
  T[string] map = null;
  return map;
}

T[string] clear(T)(ref T[string] items) {
  items = null;
  return items;
}

// #region shift
V shift(T)(T[string] items, K key) {
  V result = items.value(key);
  items.remove(key);
  return result;
}

unittest {
  STRINGAA testMap = ["a": "A", "b": "B", "c": "C"];
  assert(testMap.length == 3);
  assert(testMap.shift("b") == "B");
  assert(testMap.length == 2);
}
// #endregion shift

V value(T)(T[string] items, K key, V defaultValue = Null!V) {
  return key in items ? items[key] : defaultValue;
}
