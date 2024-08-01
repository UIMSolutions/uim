/***********************************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              
	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       
	Authors: Ozan Nurettin Süel (UIManufaktur)										                          
***********************************************************************************************************************/
module uim.core.containers.map;

@safe:
import uim.core;

enum SORTED = true;
enum NOTSORTED = false;

K[] sortedKeys(K, V)(V[K] items) {
  return items.keys.sort.array;
}

/// get keys of an associative array
/// sorted = false (default) returns an unsorted array, sorted = true returns a sorted array
K[] getKeys(K, V)(V[K] aa, bool sorted = false) {
  K[] results = aa.keys;

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
V[] getValues(K, V)(V[K] aa, bool sorted = NOTSORTED) {
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
V[K] add(K, V)(V[K] origin, V[K] newValues, bool shouldOverwrite = false) {
  V[K] results = origin.dup;
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
V[K] sub(K, V)(V[K] baseItems, V[K] subItems) {
  V[K] results = baseItems.dup;
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
bool hasAllKeys(K, V)(V[K] base, K[] keys...) {
  return base.hasAllKeys(keys.dup);
}

bool hasAllKeys(K, V)(V[K] base, K[] keys) {
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
bool hasAnyKeys(K, V)(V[K] base, V[] keys...) {
  return base.hasAnyKeys(keys.dup);
}

bool hasAnyKeys(K, V)(V[K] base, V[] keys) {
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

bool hasKey(K, V)(V[K] base, K key) {
  return (key in base)
    ? true : false;
}
///
unittest {
  assert(["a": "A", "c": "C"].hasKey("a"));
  assert(!["a": "A", "c": "C"].hasKey("x"));
}

// #region hasValue
bool hasAllValues(K, V)(V[K] items, V[] values...) {
  return items.hasAllValues(values);
}

bool hasAllValues(K, V)(V[K] items, V[] values) {
  return values.all!(value => items.hasValue(value));
}

bool hasAnyValues(K, V)(V[K] items, V[] values...) {
  return items.hasAnyValues(values);
}

bool hasAnyValues(K, V)(V[K] items, V[] values) {
  return values.any!(value => items.hasValue(value));
}

bool hasValue(K, V)(V[K] items, V value) {
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
pure bool isValue(K, V)(V[K] base, K key, V value) {
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
pure bool isValues(K, V)(V[K] base, V[K] values) {
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


bool isEmpty(V, K)(V[K] someValues) {
  return (someValues.length == 0);
}
///
unittest {
  // TODO 
}

V[K] setValues(K, V)(V[K] target, V[K] someValues) {
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

V ifNull(K, V)(V[K] map, K key, V defaultValue) {
  return key in map
    ? (!map[k].isNull ? map[k] : defaultValue) : defaultValue;
}

// #region set
V[K] set(K, V)(V[K] values, K[] keys, V value = Null!V) {
  keys.each!(key => values.set(key, value));
  return values;
}

V[K] set(K, V)(V[K] values, K key, V value = Null!V) {
  values[key] = value;
  return values;
}

unittest {
  string[string] testmap;
  assert(testmap.set("a", "A")["a"] == "A");
  assert(testmap.set("a", "A").set("b", "B")["b"] == "B");
}
// #endregion set

// #region merge
/+ Merge new items if key not exists +/
V[K] merge(K, V)(V[K] items, V[K] mergeItems, K[] includedKeys = null) {
  includedKeys.isNull
    ? mergeItems.byKeyValue.each!(item => items.merge(item.key, item.value))
    : mergeItems.byKeyValue
      .filter!(item => !includedKeys.has(item.key))
      .each!(item => items.merge(item.key, item.value));

  return items;
}

V[K] merge(K, V)(V[K] items, K[] keys, V value = Null!V) {
  keys.each!(key => items.merge(key, value));
  return items;
}

V[K] merge(K, V)(V[K] items, K key, V value = Null!V) {
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
V[K] update(K, V)(V[K] items, V[K] updateItems, K[] excludedKeys = null) {
  updateItems.byKeyValue
    .filter!(updateItem => !excludedKeys.has(updateItem.key))
    .each!(updateItem => update(items, updateItem.key, updateItem.value));

  return items;
}

V[K] update(K, V)(V[K] items, K key, V value) {
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
V[K] update(K, V)(V[K] values, K[] keys, V value = Null!V) {
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
  V[K] remove(K, V)(V[K] items, K[] keys...) {
    remove(items, keys.dup);
    return items;
  }

  V[K] remove(K, V)(V[K] items, K[] keys) {
    keys.each!(key => remove(items, key));
    return items;
  }

  V[K] remove(K, V)(V[K] items, K key) {
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
V[K] removeByValues(K, V)(V[K] items, V[] values...) {
  return removeByValues(items, values.dup);
}

V[K] removeByValues(K, V)(V[K] items, V[] values) {
  values.each!(value => removeByValue(items, value));
  return items;
}

V[K] removeByValue(K, V)(V[K] items, V value) {
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

K keyByValue(K, V)(V[K] items, V searchValue) {
  foreach (key, value; items) {
    if (value == searchValue)
      return key;
  }
  return Null!K;
}

// #region intersect 
V[K] intersect(K, V)(V[K] left, V[K] right) {
  return left.intersect(right.keys);
}

V[K] intersect(K, V)(V[K] left, K[] right) {
  V[K] result;
  right
    .filter!(key => left.hasKey(key))
    .each!(key => result[key] = left[key]);

  return result;
}

V[K] intersect(K, V)(V[K] left, Json right) {
  return right.isArray
    ? intersect(left,
      right.toArray.map!(val => val.get!K).array)
    : null; 
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
  string[string] left = ["a": "A"].set("b", "B").set("c", "C");

  string[] keys = ["a", "x", "y"];
  assert(left.intersect(keys).length == 1);
  assert(left.intersect(keys)["a"] == "A");
  assert(!left.intersect(keys).hasKey("b"));

  string[string] right =  ["a": "A"].set("x", "X").set("y", "Y");
  assert(left.intersect(right).length == 1);
  assert(left.intersect(right)["a"] == "A");
  assert(!intersect(left, right).hasKey("b"));
}
// #endregion intersect 

// #region diff 
// Computes the difference of maps
V[K] diff(K, V)(V[K] left, V[K] right) {
  return left.diff(right.keys);
}

V[K] diff(K, V)(V[K] left, K[] right) {
  V[K] result;
  right
    .filter!(key => !left.hasKey(key))
    .each!(key => result[key] = left[key]);

  return result;
}

V[K] diff(K, V)(V[K] left, Json right) {
  return right.isArray
    ? diff(left,
      right.toArray.map!(val => val.get!K).array)
    : null; 
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
  string[string] left = ["a": "A"].set("b", "B").set("c", "C");

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

V[K] column(V, K)(V[K][] values, K key) {
  return    values
    .filter!(value => value.hasKey(key))
    .map!(value => value[key]).array;
}