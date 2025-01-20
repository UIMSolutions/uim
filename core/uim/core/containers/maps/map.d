/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.map;

@safe:
import uim.core;

enum SORTED = true;
enum NOTSORTED = false;

// #region sortKeys
string[] sortKeys(Json[string] items, string mode = "ASC") {
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

pure size_t[V] indexAA(V)(Json[] values, size_t startPos = 0) {
  size_t[V] results;
  foreach (i, value; values)
    results[value] = i + startPos;
  return results;
}

unittest {
  assert(["a", "b", "c"].indexAA == ["a": 0UL, "b": 1UL, "c": 2UL]);
  assert(["a", "b", "c"].indexAA(1) == ["a": 1UL, "b": 2UL, "c": 3UL]);
}

pure size_t[V] indexAAReverse(V)(Json[] values, size_t startPos = 0) {
  size_t[V] results;
  foreach (i, value; values)
    results[i + startPos] = value;
  return results;
}

unittest {
  // Add Test
}

// #region hasKeys
bool hasAllKeys(Json[string] base, string[] keys...) {
  return base.hasAllKeys(keys.dup);
}

bool hasAllKeys(Json[string] base, string[] keys) {
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

bool hasAnyKeys(Json[string] base, string[] keys...) {
  return base.hasAnyKeys(keys.dup);
}

bool hasAnyKeys(Json[string] base, string[] keys) {
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

bool hasKey(Json[string] base, string key) {
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
bool hasAllValues(Json[string] items, Json[] values...) {
  return items.hasAllValues(values.dup);
}

bool hasAllValues(Json[string] items, Json[] values) {
  return values.all!(value => items.hasValue(value));
}

bool hasAnyValues(Json[string] items, Json[] values...) {
  return items.hasAnyValues(values.dup);
}

bool hasAnyValues(Json[string] items, Json[] values) {
  return values.any!(value => items.hasValue(value));
}

bool hasValue(T)(Json[string] items, T value) {
  return hasValue(items, Json(value));
}

bool hasValue(T:Json)(Json[string] items, T value) {
  return items.byKeyValue.any!(item => item.value == value);
}
unittest {
  assert(["a": Json("A"), "c": Json("C")].hasValue("A"));
}
// #endregion hasAllValues

pure string toJSONString(Json[string] values, bool sorted = NOTSORTED) {
  string result = "{" ~ Map.sortedKeys(values)
    .map!(key => `"%s": %s`.format(key, values[key]))
    .join(",") ~ "}";

  return result;
}

unittest {
  assert(["a": 1, "b": 2].toJSONString(SORTED) == `{"a": 1,"b": 2}`);
}

pure string toHTML(Json[string] items, bool sorted = NOTSORTED) {
  
  return items.sortKeys(sorted ? "ASC" : "NONE")
    .map!(key => `%s="%s"`.format(key, items[key]))
    .join(" ");
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  assert(["a": 1, "b": 2].toHTML(SORTED) == `a="1" b="2"`);
}

pure string toSqlUpdate(Json[string] items, bool sorted = NOTSORTED) {
  return items.sortKeys
    .map!(key => `%s=%s`.format(key, items[key]))
    .join(",");
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  assert(["a": 1, "b": 2].toSqlUpdate(SORTED) == `a=1,b=2`);
}

/// Checks if key exists and has values
pure bool hasValue(T)(Json[string] items, string key, T value) {
  return (key in items)
    ? items[key] == value : false;
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  assert(["a": 1, "b": 2].hasValue("a", 1));
  assert(!["a": 2, "b": 2].hasValue("a", 1));
  assert(["a": 1, "b": 1].hasValue("a", 1));
  assert(!["a": 2, "b": 1].hasValue("a", 1));
  assert(["a": 1, "b": 2].hasValue("b", 2));
}

// Checks if values exist in base
pure bool hasValues(Json[string] items, Json[string] hasItems) {
  return otherItems.byKeyValue
    .all!(other => other.key in items && items[other.key] == hasItems[other.key]);
}
///
unittest {
  writeln(__FILE__, "/", __LINE__);
  assert(["a": 1, "b": 2].hasValues(["a": 1, "b": 2]));
  assert(!["a": 1, "b": 2].hasValues(["a": 1, "b": 3]));
  assert(!["a": 1, "b": 2].hasValues(["a": 1, "c": 2]));
}

Json[string] setValues(Json[string] target, Json[string] someValues) {
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
Json ifNull(Json[string] map, string key, Json defaultValue) {
  return key in map
    ? (!map[k].isNull ? map[k] : defaultValue) : defaultValue;
}
// #endregion ifNull

// #region isSet
bool isSetAny(Json[string] map, string[] keys...) {
  return isSetAny(map, keys.dup);
}

bool isSetAny(Json[string] map, string[] keys) {
  return keys.any!(key => isSet(map, key));
}

bool isSetAll(Json[string] map, string[] keys...) {
  return isSetAll(map, keys.dup);
}

bool isSetAll(Json[string] map, string[] keys) {
  return keys.all!(key => isSet(map, key));
}

bool isSet(Json[string] map, string key) {
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
auto set(Json[string] items, string[] keys, Json value) {
    keys.each!(key => items.set(key, value));
    return items;
  }

  auto set(Json[string] items, string key, Json value) {
    items[key] = value;
    return items;
  }

  unittest {

    /* Json[string] testJson;
  assert(set(testJson, "a", Json("A"))["a"].getString == "A"); */
  }
  // #endregion set

  // #region merge
  /+ Merge new items if key not exists +/
  auto merge(Json[string] items, Json[string] mergeItems, string[] keys = null) {
    keys.isNull
      ? mergeItems.byKeyValue
      .each!(item => items = items.merge(item.key, item.value)) : mergeItems.byKeyValue
      .filter!(item => !keys.has(item.key))
      .each!(item => items = items.merge(item.key, item.value));

    return items;
  }

  auto merge(Json[string] items, string[] keys, Json value) {
    keys.each!(key => items = items.merge(key, value));
    return items;
  }

  auto merge(Json[string] items, string key, Json value) {
    if (key !in items) {
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

    Json[string] testMap;
    assert(testMap.length == 0);
    assert(testMap.merge("one", Json(true)).length == 1);
    assert(testMap.merge("two", Json(false)).length == 2);
    assert(testMap.getBoolean("one"));
    assert(!testMap.getBoolean("two"));

    testMap.clear;
    assert(testMap.length == 0);
    assert(testMap.merge(["a", "b"], Json(true)).length == 2);
    assert(testMap.merge(["c", "d"], Json(false)).length == 4);
    assert(testMap.getBoolean("a"));
    assert(!testMap.getBoolean("c"));
  }
  // #endregion merge

  // #region update
  Json[string] update(Json[string] items, Json[string] updateItems, string[] excludedKeys = null) {
    updateItems.byKeyValue
      .filter!(updateItem => !excludedKeys.has(updateItem.key))
      .each!(updateItem => update(items, updateItem.key, updateItem.value));

    return items;
  }

  Json[string] update(Json[string] items, string key, Json value) {
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
  Json[string] update(Json[string] values, string[] keys, Json value = Json(null)) {
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
  Json[string] removeKeys(Json[string] items, string[] keys...) {
    removeKeys(items, keys.dup);
    return items;
  }

  Json[string] removeKeys(Json[string] items, string[] keys) {
    keys.each!(key => removeKey(items, key));
    return items;
  }

  Json[string] removeKey(Json[string] items, string[] path) {
    if (!hasKey(items, path)) {
      return items;
    }
    return items; // TODO
  }

  Json[string] removeKey(Json[string] items, string key) {
    if (hasKey(items, key)) {
      items.remove(key);
    }
    return items;
  }

  unittest {
    assert(["a": "A", "b": "B", "c": "C"].length == 3);

    assert(removeKey(["a": "A", "b": "B", "c": "C"], "a").length == 2);
    assert(["a": "A", "b": "B", "c": "C"].removeKey("a").length == 2);
    assert(["a": "A", "b": "B", "c": "C"].removeKey("x").length == 3);
    assert(["a": "A", "b": "B", "c": "C"].removeKey("a")["b"] == "B");
    assert(["a": "A", "b": "B", "c": "C"].removeKey("a").removeKey("a").length == 2);
    assert(["a": "A", "b": "B", "c": "C"].removeKey("a").removeKey("b").length == 1);

    assert(removeKeys(["a": "A", "b": "B", "c": "C"], "a").length == 2);
    assert(removeKeys(["a": "A", "b": "B", "c": "C"], "a", "b").length == 1);
    assert(removeKeys(["a": "A", "b": "B", "c": "C"], "a", "c", "b").length == 0);
    assert(removeKeys(["a": "A", "b": "B", "c": "C"], "a", "b")["c"] == "C");
  }
  // #endregion remove

  // #region removeByValues
  Json[string] removeByValues(Json[string] items, Json[] values...) {
    return removeByValues(items, values.dup);
  }

  Json[string] removeByValues(Json[string] items, Json[] values) {
    values.each!(value => removeByValue(items, value));
    return items;
  }

  Json[string] removeByValue(Json[string] items, Json value) {
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

  string keyByValue(Json[string] items, Json searchValue) {
    foreach (key, value; items) {
      if (value == searchValue)
        return key;
    }
    return Null!K;
  }

  // #region intersect 
  Json[string] intersect(Json[string] left, Json[string] right) {
    return left.intersect(right.keys);
  }

  Json[string] intersect(Json[string] left, string[] right) {
    Json[string] result;
    right
      .filter!(key => left.hasKey(key))
      .each!(key => result[key] = left[key]);

    return result;
  }

/*   Json[string] intersect(Json[string] left, Json right) {
    return right.isArray
      ? intersect(left,
        right.toArray.map!(val => val.get!K).array) : null;
  } */

  Json[string] intersect(Json[string] left, Json right) {
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
  Json[string] diff(Json[string] left, Json[string] right) {
    return left.diff(right.keys);
  }

  Json[string] diff(Json[string] left, string[] right) {
    Json[string] result;
    right
      .filter!(key => !left.hasKey(key))
      .each!(key => result[key] = left[key]);

    return result;
  }

/*   Json[string] diff(Json[string] left, Json right) {
    return right.isArray
      ? diff(left,
        right.toArray.map!(val => val.get!K).array) : null;
  } */

  Json[string] diff(Json[string] left, Json right) {
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
    /* assert(left.diff(keys).length == 2);
  assert(left.diff(keys)["b"] == "B");
  assert(!left.diff(keys).hasKey("b"));

  string[string] right =  ["a": "A"].set("x", "X").set("y", "Y");
  assert(left.diff(right).length == 2);
  assert(left.diff(right)["a"] == "A");
  assert(!diff(left, right).hasKey("b")); */
  }
  // #endregion diff 

  Json[string] column(V, K)(Json[string][] values, string key) {
    return values
      .filter!(value => value.hasKey(key))
      .map!(value => value[key])
      .array;
  }

  Json[string] combine(V, K)(string[] keys, Json[] values) {
    Json[string] results;
    size_t lastIndex = min(keys.length, values.length);
    for (size_t i = 0; i < lastIndex; i++) {
      results[keys[i]] = values[i];
    }
    return results;
  }

  // #region filterValues
  Json[string] filterValues(Json[string] items) {
    Json[string] results;
    items.byKeyValue
      .filter!(item => !item.value.isNull)
      .each!(item => results[item.key] = item.value);

    return results;
  }

  Json[string] filterValues(Json[string] items, bool delegate(string key, Json value) check) {
    Json[string] results;
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
  Json[string] unique(Json[string] items) {
    Json[string] results;
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
  Json[string] createMap(Json[string] startItems = null) {
    Json[string] map = startItems;
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
  /* Json[string] clear(Json[string] items) {
  items = null;
  return items;
} */

  unittest {
    STRINGAA testMap = ["a": "A", "b": "B", "c": "C"];
    assert(testMap !is null);

    testMap.clear;
    assert(testMap.length == 0);
  }
  // #endregion clear

  // #region shift
  Json[string] shift(Json[string] items, string[] keys) {
    Json[string] result;
    keys
      .filter!(key => items.hasKey(key))
      .each!(key => result[key] = items.shift(key));
    return result;
  }

  Json shift(Json[string] items, string key) {
    Json result = items.value(key);
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

  Json value(Json[string] items, string key, Json defaultValue = Json(null)) {
    return key in items ? items[key] : defaultValue;
  }

  // #region isEmpty
  bool isEmpty(Json[string] items) {
    return items.length == 0;
  }

  unittest {
    STRINGAA testMap = ["a": "A", "b": "B", "c": "C"];
    assert(!testMap.isEmpty);

    assert(testMap.length == 3);

    testMap.clear;
    assert(testMap.isEmpty);
    assert(testMap.isEmpty);
    assert(testMap.length == 0);

    testMap = createMap!(string, string);
    assert(testMap.isEmpty);
    assert(testMap.length == 0);

    /*   testMap = createMap!(string, string)
    .set("a", "A")
    .set("b", "B");
  assert(!testMap.isEmpty);
  assert(testMap.length == 2); */
  }
  // #endregion isEmpty
