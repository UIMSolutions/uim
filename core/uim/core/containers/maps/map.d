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
string[] sortKeys(K, V)(V[K] items, string mode = "ASC") {
  switch (mode) {
  case "NONE":
    return items.keys;
  case "DESC":
    return items.keys.sort!("a > b").array;
  default: // ASC
    return items.keys.sort!("a < b").array;
  }
}

unittest {
  string[string] testMap = ["a": "A", "b": "B"];
  assert(testMap.sortKeys == ["a", "b"]);
  assert(testMap.sortKeys("DESC") == ["b", "a"]);
}
// #endregion sortKeys

pure size_t[V] indexAA(V)(V[] values, size_t startPos = 0) {
  size_t[V] results;
  foreach (i, value; values)
    results[value] = i + startPos;
  return results;
}

unittest {
  assert(["a", "b", "c"].indexAA == ["a": 0UL, "b": 1UL, "c": 2UL]);
  assert(["a", "b", "c"].indexAA(1) == ["a": 1UL, "b": 2UL, "c": 3UL]);
}

pure size_t[V] indexAAReverse(V)(V[] values, size_t startPos = 0) {
  size_t[V] results;
  foreach (i, value; values)
    results[i + startPos] = value;
  return results;
}

unittest {
  // Add Test
}

// #region hasKeys
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

bool hasAnyKeys(K, V)(V[K] base, K[] keys...) {
  return base.hasAnyKeys(keys.dup);
}

bool hasAnyKeys(K, V)(V[K] base, K[] keys) {
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

bool hasKey(K, V)(V[K] base, K key) {
  return (key in base)
    ? true : false;
}
///
unittest {
  assert(["a": "A", "c": "C"].hasKey("a"));
  assert(!["a": "A", "c": "C"].hasKey("x"));
}
// #endregion hasKey

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

pure string toJSONString(K, V)(V[K] values, bool sorted = NOTSORTED) {
  string result = "{" ~ values
    .sortKeys
    .map!(key => `"%s": %s`.format(key, values[key]))
    .join(",") ~ "}";

  return result;
}

unittest {
  assert(["a": 1, "b": 2].toJSONString(SORTED) == `{"a": 1,"b": 2}`);
}

pure string toHTML(K, V)(V[K] items, bool sorted = NOTSORTED) {
  return items.sortKeys(sorted ? "ASC" : "NONE")
    .map!(key => `%s="%s"`.format(key, items[key]))
    .join(" ");
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  assert(["a": 1, "b": 2].toHTML(SORTED) == `a="1" b="2"`);
}

pure string toSqlUpdate(K, V)(V[K] items, bool sorted = NOTSORTED) {
  return items.sortKeys
    .map!(key => `%s=%s`.format(key, items[key]))
    .join(",");
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  assert(["a": 1, "b": 2].toSqlUpdate(SORTED) == `a=1,b=2`);
}

/// Checks if key exists and has values
pure bool isValue(K, V)(V[K] items, K key, V value) {
  return (key in items)
    ? items[key] == value : false;
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
pure bool hasValues(K, V)(V[K] items, V[K] otherItems) {
  return otherItems.byKeyValue
    .all!(other => other.key in items && items[other.key] == otherItems[other.key]);
}
///
unittest {
  writeln(__FILE__, "/", __LINE__);
  assert(["a": 1, "b": 2].hasValues(["a": 1, "b": 2]));
  assert(!["a": 1, "b": 2].hasValues(["a": 1, "b": 3]));
  assert(!["a": 1, "b": 2].hasValues(["a": 1, "c": 2]));
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
V ifNull(K, V)(V[K] map, K key, V defaultValue) {
  return key in map
    ? (!map[k].isNull ? map[k] : defaultValue) : defaultValue;
}
// #endregion ifNull

// #region isSet
bool isSetAny(K, V)(V[K] map, K[] keys...) {
  return isSetAny(map, keys.dup);
}

bool isSetAny(K, V)(V[K] map, K[] keys) {
  return keys.any!(key => isSet(map, key));
}

bool isSetAll(K, V)(V[K] map, K[] keys...) {
  return isSetAll(map, keys.dup);
}

bool isSetAll(K, V)(V[K] map, K[] keys) {
  return keys.all!(key => isSet(map, key));
}

bool isSet(K, V)(V[K] map, K key) {
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
V[K] set(K, V)(V[K] items, K[] keys, V value) {
  keys.each!(key => items.set(key, value));
  return items;
}

V[K] set(K, V)(V[K] items, K key, V value) if (!is(V == Json)) {
  items[key] = value;
  return items;
}

unittest {
  string[string] testmap;
  assert(set(testmap, "a", "A")["a"] == "A");
  assert(set(testmap, "a", "A").set("b", "B")["b"] == "B");
}
// #endregion set

// #region merge
/+ Merge new items if key not exists +/
V[K] merge(K, V)(V[K] items, V[K] mergeItems, K[] keys = null) {
  keys.isNull
    ? mergeItems.byKeyValue
    .each!(item => items.merge(item.key, item.value)) : mergeItems.byKeyValue
    .filter!(item => !keys.has(item.key))
    .each!(item => items.merge(item.key, item.value));

  return items;
}

V[K] merge(K, V)(V[K] items, K[] keys, V value) {
  keys.each!(key => items.merge(key, value));
  return items;
}

V[K] merge(K, V)(V[K] items, K key, V value) {
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
V[K] update(K, V)(V[K] items, V[K] updateItems, string[] excludedKeys = null) {
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
V[K] removeKeys(K, V)(V[K] items, K[] keys...) {
  removeKeys(items, keys.dup);
  return items;
}

V[K] removeKeys(K, V)(V[K] items, K[] keys) {
  keys.each!(key => removeKey(items, key));
  return items;
}

V[K] removeKey(K, V)(V[K] items, K key) {
  if (hasKey(items, key)) {
    items.remove(key);
  }
  return items;
}

unittest {
  assert(["a": "A", "b": "B", "c": "C"].length == 3);
  assert(removeKey(["a": "A", "b": "B", "c": "C"], "a").length == 2);
  assert(removeKeys(["a": "A", "b": "B", "c": "C"], "a", "b").length == 1);
  assert(removeKey(["a": "A", "b": "B", "c": "C"], "a").length == 2);

  assert(removeKey(["a": "A", "b": "B", "c": "C"], "a")["c"] == "C");
  assert(removeKeys(["a": "A", "b": "B", "c": "C"], "a", "b")["c"] == "C");
  assert(removeKey(["a": "A", "b": "B", "c": "C"], "a")["c"] == "C");
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

V[K] intersect(K, V)(V[K] left, string[] right) {
  V[K] result;
  right
    .filter!(key => left.hasKey(key))
    .each!(key => result[key] = left[key]);

  return result;
}

V[K] intersect(K, V)(V[K] left, Json right) {
  return right.isArray
    ? intersect(left,
      right.toArray.map!(val => val.get!K).array) : null;
}

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

  K[] keys = ["a", "x", "y"]; */
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

V[K] diff(K, V)(V[K] left, Json right) {
  return right.isArray
    ? diff(left,
      right.toArray.map!(val => val.get!K).array) : null;
}

V[K] diff(K, V)(V[K] left, Json right) {
  if (right.isArray) {
    return diff(left,
      right.toArray.map!(val => val.get!V).array);
  }
  if (right.isObject) {
    return diff(left,
      right.keys
        .map!(key => val.get(key, Null!V)).array);
  }
  return null;
}

unittest {
  string[string] left = ["a": "A"].set("b", "B").set("c", "C");
  string[] keys = ["a", "x", "y"];

  /* assert(left.diff(keys).length == 2);
  assert(left.diff(keys)["b"] == "B");
  assert(!left.diff(keys).hasKey("b"));

  string[string] right =  ["a": "A"].set("x", "X").set("y", "Y");
  assert(left.diff(right).length == 2);
  assert(left.diff(right)["a"] == "A");
  assert(!diff(left, right).hasKey("b")); */
}
// #endregion diff 

V[K] column(V, K)(V[K][] values, K key) {
  return values
    .filter!(value => value.hasKey(key))
    .map!(value => value[key])
    .array;
}

V[K] combine(V, K)(K[] keys, V[] values) {
  V[K] results;
  size_t lastIndex = min(keys.length, values.length);
  for (size_t i = 0; i < lastIndex; i++) {
    results[keys[i]] = values[i];
  }
  return results;
}

// #region filterValues
V[K] filterValues(K, V)(V[K] items) {
  V[K] results;
  items.byKeyValue
    .filter!(item => !item.value.isNull)
    .each!(item => results[item.key] = item.value);

  return results;
}

V[K] filterValues(K, V)(V[K] items, bool delegate(K key, V value) check) {
  V[K] results;
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
V[K] unique(K, V)(V[K] items) {
  V[K] results;
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

// #region createMap
V[K] createMap(K, V)(V[K] startItems = null) {
  V[K] map = startItems;
  return map;
}

unittest {
  STRINGAA testMap = createMap!(string, string);
  assert(testMap.isEmpty);

  testMap = createMap!(string, string)(["a": "A", "b": "B", "c": "C"]);
  assert(!testMap.isEmpty);
}
// #endregion createMap

// #region clear
V[K] clear(K, V)(auto ref V[K] items) {
  items = null;
  return items;
}

unittest {
  STRINGAA testMap = ["a": "A", "b": "B", "c": "C"];
  assert(testMap !is null);
  assert(testMap.clear is null);
  assert(testMap is null);
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
  V result = items.value(key);
  items.remove(key);
  return result;
}

unittest {
  STRINGAA testMap = ["a": "A", "b": "B", "c": "C"];
  assert(testMap.length == 3);
  assert(testMap.shift("b") == "B");
  assert(testMap.length == 2);

  auto map = testMap.shift(["a", "b", "c"]);
  assert(testMap.length == 0);
  assert(map.length == 2);
  assert(map["a"] == "A");
}
// #endregion shift

V value(K, V)(V[K] items, K key, V defaultValue = Null!V) {
  return key in items ? items[key] : defaultValue;
}

// #region isEmpty
bool isEmpty(K, V)(V[K] items) {
  return items.length == 0;
}

unittest {
  STRINGAA testMap = ["a": "A", "b": "B", "c": "C"];
  assert(!testMap.isEmpty);
  assert(testMap.length == 3);
  assert(testMap.clear.isEmpty);
  assert(testMap.isEmpty);
  assert(testMap.length == 0);

  testMap = createMap!(string, string);
  assert(testMap.isEmpty);
  assert(testMap.length == 0);

  testMap = createMap!(string, string)
    .set("a", "A")
    .set("b", "B");
  assert(!testMap.isEmpty);
  assert(testMap.length == 2);
}
// #endregion isEmpty

V[K] filterByKeys(K, V)(V[K] entries, K[] keys...) {
  return filterByKeys(entries, keys.dup);
}

V[K] filterByKeys(K, V)(V[K] entries, K[] keys) {
  V[K] results;
  keys
    .filter!(key => key in entries)
    .each!(key => results[key] = entries[key]);

  return results;
}

unittest {
  assert(["a": "1", "b": "2"].filterByKeys("a") == ["a": "1"]);
}

V[K] notFilterByKeys(K, V)(V[K] entries, K[] keys...) {
  return notFilterByKeys(entries, keys.dup);
}

V[K] notFilterByKeys(K, V)(V[K] entries, K[] keys) {
  V[K] results = entries.dup;
  keys
    .filter!(key => key in entries)
    .each!(key => results.remove(key));

  return results;
}

unittest {
  assert(["a": "1", "b": "2"].notFilterByKeys("a") == ["b": "2"]);
}

// #region replaceKey
V[K] replaceKey(K, V)(V[K] entries, K[] originalPath, K newPath) {
  keys
    .filter!(key => key in entries)
    .each!(key => results.remove(key));

  return results;
}

V[K] replaceKey(K, V)(V[K] entries, K originalKey, K newKey) {
  keys
    .filter!(key => key in entries)
    .each!(key => results.remove(key));

  return results;
}

///
unittest {
  auto testMap = createMap!(string, Json)
    .set("a", "A")
    .set("obj", createMap!(string, Json).set("b", "B"));

  assert(!testMap.hasKey("A"));
  assert(testMap.getString("a") == "A");
  assert(testMap.replaceKey("a", "A"));
  assert(testMap.hasKey("A"));
  assert(testMap.getString("A") == "A");
}
// #endregion replaceKey
