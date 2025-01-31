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
bool hasValues(K, V)(V[K] items, V[K] others) {
  return others.byKeyValue
    .all!(other => other.key in items && items[other.key] == other.value);
}
///
unittest {
  writeln(__FILE__, "/", __LINE__);
  auto testMap = ["a": 1, "b": 2, "c": 3, "d": 4];
  // assert(["a": 1, "b": 2].hasValues(["a": 1, "b": 2]));
  // assert(!["a": 1, "b": 2].hasValues(["a": 1, "b": 3]));
  // assert(!["a": 1, "b": 2].hasValues(["a": 1, "c": 2]));
}

// #region set
  // Returns a updated map with new values
  V[K] set(K, V)(V[K] items, V[K] others) {
    others.each!((key, value) => items.set(key, value));
    return items;
  }

  // returns a updated map with new values
  V[K] set(K, V)(V[K] items, K[] keys, V value) {
    keys.each!(key => items.set(key, value));
    return items;
  }

  // returns a updated map with new value
  V[K] set(K, V)(V[K] items, K key, V value) {
    items[key] = value;
    return items;
  }

  unittest {
    string[string] test = ["a": "A", "b": "B", "c": "C"];
    assert(test.length == 3);

    test.set("d", "D");
    assert(test.length == 4 && test.hasKey("d"));

    test = ["a": "A", "b": "B", "c": "C"];
    test.set(["d", "e", "f"], "x");
    assert(test.length == 6 && test.hasKey("d") && test["f"] == "x");

    test = ["a": "A", "b": "B", "c": "C"];
    test.set("d", "x").set("e", "x").set("f", "x");
    assert(test.length == 6 && test.hasKey("d") && test["f"] == "x");

    test = ["a": "A", "b": "B", "c": "C"];
    test.set(["d": "x", "e": "x", "f": "x"]);
    assert(test.length == 6 && test.hasKey("d") && test["f"] == "x");

    Json[string] test2 = ["a": Json("A"), "b": Json("B"), "c": Json("C")];
    assert(test2.length == 3);

    test2.set("d", Json("x"));
    assert(test2.length == 4 && test2.hasKey("d"));

    test2 = ["a": Json("A"), "b": Json("B"), "c": Json("C")];   
    test2.set(["d", "e", "f"], Json("x"));
    assert(test2.length == 6 && test2.hasKey("d") && test2["f"] == Json("x"));

    test2 = ["a": Json("A"), "b": Json("B"), "c": Json("C")];  
    test2.set("d", Json("x")).set("e", Json("x")).set("f", Json("x"));
    assert(test2.length == 6 && test2.hasKey("d") && test2["f"] == Json("x"));

    test2 = ["a": Json("A"), "b": Json("B"), "c": Json("C")];  
    test2.set(["d": Json("x"), "e": Json("x"), "f": Json("x")]);
    assert(test2.length == 6 && test2.hasKey("d") && test2["f"] == Json("x"));
  }
// #endregion set

// #region merge
  // Returns a new map with merged values for not existing keys
  V[K] merge(K, V)(V[K] items, V[K] merges, K[] keys...) {
    return merge(items, merges, keys.dup);
  }

  // Returns a new map with merged values for not existing keys
  V[K] merge(K, V)(V[K] items, V[K] merges, K[] keys = null) {
    keys.isNull
      ? merges
          .each!((key, value) => items.merge(key, value)) 
      : keys
          .filter!(key => key in merges)
          .each!(key => items.merge(key, merges[key]));

    return items;
  }

  // Returns a new map with merged values for not existing keys
  V[K] merge(K, V)(V[K] items, K[] keys, V value) {
    keys
      .filter!(key => key !in items)
      .each!(key => items.set(key, value));
    return items;
  }

  // Returns a new map with merged values for not existing keys
  V[K] merge(K, V)(V[K] items, K key, V value) {
    if (key !in items) {
      items[key] = value;
    }
    return items;
  }

  unittest {
    string[string] test = ["a": "A", "b": "B"];
    assert(test.length == 2);

    test.merge("c", "C");
    assert(test.length == 3 && test.hasKey("c"));

    test.merge("a", "X");
    assert(test.length == 3);

    test.merge("e", "x").merge("f", "x");
    assert(test.length == 5 && test.hasAllKeys("e", "f"));

    test = ["a": "A", "b": "B"]; // Reset map
    test.merge(["c", "d", "e"], "X");
    assert(test.length == 5 && test.hasAllKeys("c", "d", "e"));

    test.merge(["c", "d", "e"], "x").merge(["f", "g", "h"], "x");
    assert(test.length == 8 && test.hasAllKeys("f", "g", "h"));

    test = ["a": "A", "b": "B"]; // Reset map
    test.merge(["c": "x", "d": "x", "e": "x"]);
    assert(test.length == 5 && test.hasAllKeys("c", "d", "e"));

    test = ["a": "A", "b": "B"]; // Reset map
    test.merge(["c": "x", "d": "x", "e": "x"], "e");
    writeln(test);
    assert(test.length == 3 && test.hasAllKeys("e") && !test.hasAllKeys("c", "d"));

    Json[string] test2 = ["a": Json("A"), "b": Json("B")];
    assert(test2.length == 2);

    test2.merge("c", Json("C"));
    assert(test2.length == 3 && test2.hasKey("c"));

    test2.merge("a", Json("X"));
    assert(test2.length == 3);

    test2.merge("e", Json("x")).merge("f", Json("x"));
    assert(test2.length == 5 && test2.hasAllKeys("e", "f"));

    test2 = ["a": Json("A"), "b": Json("B")]; // Reset map
    test2.merge(["c", "d", "e"], Json("x"));
    assert(test2.length == 5 && test2.hasAllKeys("c", "d", "e"));

    test2.merge(["c", "d", "e"], Json("x")).merge(["f", "g", "h"], Json("x"));
    assert(test2.length == 8 && test2.hasAllKeys("f", "g", "h"));

    test2 = ["a": Json("A"), "b": Json("B")]; // Reset map
    test2.merge(["c": Json("x"), "d": Json("x"), "e": Json("x")]);
    assert(test2.length == 5 && test2.hasAllKeys("c", "d", "e"));

    test2 = ["a": Json("A"), "b": Json("B")]; // Reset map
    test2.merge(["c": Json("x"), "d": Json("x"), "e": Json("x")], "e");
    writeln(test2);
    assert(test2.length == 3 && test2.hasAllKeys("e") && !test2.hasAllKeys("c", "d"));
  }
// #endregion merge

// #region update
  // Returns a new map with updated values for existing keys
  V[K] update(K, V)(V[K] items, V[K] merges, K[] keys...) {
    return update(items, merges, keys.dup);
  }

  // Returns a new map with updated values for existing keys
  V[K] update(K, V)(V[K] items, V[K] merges, K[] keys = null) {
    keys.isNull
      ? merges
          .each!((key, value) => items.update(key, value)) 
      : keys
          .filter!(key => key in merges)
          .each!(key => items.update(key, merges[key]));

    return items;
  }

  // Returns a new map with updated values for existing keys
  V[K] update(K, V)(V[K] items, K[] keys, V value) {
    keys
      .each!(key => items.update(key, value));
    return items;
  }

  // Returns a new map with updated values for existing keys
  V[K] update(K, V)(V[K] items, K key, V value) {
    if (key in items) {
      items[key] = value;
    }
    return items;
  }

  unittest {
    string[string] test = ["a": "A", "b": "B", "c": "C"];
    assert(test.length == 3 && test.hasAllKeys("a", "b", "c") && test["a"] == "A");

    test.update("a", "x").update("d", "x").update("e", "x").update("f", "x");
    assert(test.length == 3 && !test.hasAnyKey("d", "e", "f") && test["a"] == "x");

    test = ["a": "A", "b": "B", "c": "C"]; // Reset map
    test.update(["c", "d", "e"], "x");
    assert(test.length == 3 && !test.hasAnyKey("d", "e", "f") && test["a"] != "x" && test["c"] == "x");

    test = ["a": "A", "b": "B", "c": "C"]; // Reset map
    test.update(["a", "b", "c"], "x").update(["d", "e", "f"], "x");
    assert(test.length == 3 && !test.hasAnyKey("d", "e", "f") && test["a"] == "x" && test["c"] == "x");

    test = ["a": "A", "b": "B", "c": "C"]; // Reset map
    test.update(["c": "x", "d": "x", "e": "x"]);
    assert(test.length == 3 && !test.hasAnyKey("d", "e", "f") && test["a"] != "x" && test["c"] == "x");

    test = ["a": "A", "b": "B", "c": "C"]; // Reset map
    test.update(["c": "x", "d": "x", "e": "x"], "c", "e");
    assert(test.length == 3 && !test.hasAnyKey("d", "e", "f") && test["a"] != "x" && test["c"] == "x");

    Json[string] test2 = ["a": Json("A"), "b": Json("B"), "c": Json("C")];
    assert(test2.length == 3 && test2.hasAllKeys("a", "b", "c") && test2["a"] == "A");

    test2.update("a", Json("x")).update("d", Json("x")).update("e", Json("x")).update("f", Json("x"));
    assert(test2.length == 3 && !test2.hasAnyKey("d", "e", "f") && test2["a"] == Json("x"));

    test2 = ["a": Json("A"), "b": Json("B"), "c": Json("C")]; // Reset map
    test2.update(["c", "d", "e"], Json("x"));
    assert(test2.length == 3 && !test2.hasAnyKey("d", "e", "f") && test2["a"] != Json("x") && test2["c"] == Json("x"));

    test2 = ["a": Json("A"), "b": Json("B"), "c": Json("C")]; // Reset map
    test2.update(["a", "b", "c"], Json("x")).update(["d", "e", "f"], Json("x"));
    assert(test2.length == 3 && !test2.hasAnyKey("d", "e", "f") && test2["a"] == Json("x") && test2["c"] == Json("x"));

    test2 = ["a": Json("A"), "b": Json("B"), "c": Json("C")]; // Reset map
    test2.update(["c": Json("x"), "d": Json("x"), "e": Json("x")]);
    assert(test2.length == 3 && !test2.hasAnyKey("d", "e", "f") && test2["a"] != Json("x") && test2["c"] == Json("x"));

    test2 = ["a": Json("A"), "b": Json("B"), "c": Json("C")]; // Reset map
    test2.update(["c": Json("x"), "d": Json("x"), "e": Json("x")], "c", "e");
    assert(test2.length == 3 && !test2.hasAnyKey("d", "e", "f") && test2["a"] != Json("x") && test2["c"] == Json("x"));
  }
// #endregion update

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
