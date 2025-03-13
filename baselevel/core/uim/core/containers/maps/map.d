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



string toHTML(T)(T[string] items, bool sorted = NOTSORTED) {
  return items.sortKeys(sorted ? "ASC" : "NONE")
    .map!(key => `%s="%s"`.format(key, items[key]))
    .join(" ");
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  // assert(["a": 1, "b": 2].toHTML(SORTED) == `a="1" b="2"`);
}

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
  T[string] set(T)(T[string] items, T[string] newItems) {
    newItems.each!((key, value) => items.set(key, value));
    return items;
  }

  T[string] set(T)(T[string] items, string[] keys, T value) {
    keys.each!(key => items.set(key, value));
    return items;
  }

  T[string] set(T)(T[string] items, string key, T value) {
    items[key] = value;
    return items;
  }

  unittest {
    auto map = ["1": 1, "2": 2, "3": 3];
    assert(map.length == 3);

    map.set("4", 4);
    assert(map.length == 4 && map.hasKey("4"));

    map.set("5", 5).set("6", 6);
    assert(map.length == 6 && map.hasAllKeys("4", "5", "6"));

    map = ["1": 1, "2": 2, "3": 3];
    map.set(["5", "6"], 0);
    assert(map.length == 5 && map.hasAllKeys("5", "6"));

    map = ["1": 1, "2": 2, "3": 3];
    map.set(["4": 4, "5": 5, "6": 6]);
    assert(map.length == 6 && map.hasAllKeys("4", "5", "6"));
  }
// #endregion set

// #region merge
  T[string] merge(T)(T[string] items, T[string] newItems) {
    newItems.each!((key, value) => items.merge(key, value));
    return items;
  }

  T[string] merge(T)(T[string] items, string[] keys, T value) {
    keys.each!(key => items.merge(key, value));
    return items;
  }

  T[string] merge(T)(T[string] items, string key, T value) {
    items[key] = value;
    return items;
  }

  unittest {
    auto map = ["1": 1, "2": 2, "3": 3];
    assert(map.length == 3);

    map.merge("4", 4);
    assert(map.length == 4 && map.hasKey("4"));

    map.merge("3", 0);
    assert(map.length == 4 && map["3"] == 3);

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
T[string] update(T)(T[string] items, T[string] newItems) {
    newItems.each!((key, value) => items.update(key, value));
    return items;
  }

  T[string] update(T)(T[string] items, string[] keys, T value) {
    keys.each!(key => items.update(key, value));
    return items;
  }

  T[string] update(T)(T[string] items, string key, T value) {
    items[key] = value;
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
string keyByValue(T)(T[string] items, Json searchValue) {
  foreach (key, value; items) {
    if (value == searchValue)
      return key;
  }
  // return Null!K;
  return Json(null);
}
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
T[] values(T)(T[string] items, string[] keys...) {
  return items.values(keys.dup);
}

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

  map = ["1": 1, "2": 2, "3": 3];
  assert(map.length == 3);
  assert(map.values("2", "1", "1", "3") == [2, 1, 1, 3]);
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
