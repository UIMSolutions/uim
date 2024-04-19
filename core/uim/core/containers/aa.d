/***********************************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              
	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                          
***********************************************************************************************************************/
module uim.core.containers.aa;

@safe:
import uim.core;

enum SORTED = true;
enum NOTSORTED = false;

/// get keys of an associative array
/// sorted = false (default) returns an unsorted array, sorted = true returns a sorted array
K[] getKeys(K, V)(V[K] aa, bool sorted = false) {
  K[] results = aa.keys;
  if (sorted)
    return results.sort.array;
  return results;
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
  if (sorted)
    return results.sort.array;
  return results;
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
T[S] add(T, S)(T[S] origin, T[S] newValues, bool shouldOverwrite = false) {
  T[S] results = origin.dup;
  newValues.byKeyValue
    .filter!(kv => shouldOverwrite || (kv.key !in results))
    .each!(kv => results[kv.key] = kv.value);
  return results;
}
///
unittest {
  assert([1: "b", 2: "d"].add([3: "f"]) == [1: "b", 2: "d", 3: "f"]);
  assert(["a": "b", "c": "d"].add(["e": "f"]) == [
      "a": "b",
      "c": "d",
      "e": "f"
    ]);
  assert(["a": "b", "c": "d"].add(["e": "f"])
      .add(["g": "h"]) == ["a": "b", "c": "d", "e": "f", "g": "h"]);
}

/// remove subItems from baseItems if key and value of item are equal
T[S] sub(T, S)(T[S] baseItems, T[S] subItems) {
  T[S] results = baseItems.dup;
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

/// remove subItems from baseItems if key exists
T[S] removeByKeys(T, S)(T[S] baseItems, S[] subItems...) {
  return removeByKeys(baseItems, subItems);
}
///
unittest {
  assert([1: "4", 2: "5", 3: "6"].removeByKeys(2, 3) == [1: "4"]);
}

/// remove subItems from baseItems if key exists
T[S] removeByKeys(T, S)(T[S] baseItems, S[] subItems) {
  T[S] results = baseItems.dup;
  subItems.each!((key) => results.remove(key));
  return results;
}
///
unittest {
  assert([1: "4", 2: "5", 3: "6"].removeByKeys([2, 3]) == [1: "4"]);
}

/// remove subItems from baseItems if key exists
T[S] removeByKeys(T, S)(T[S] baseItems, T[S] subItems) {
  T[S] results = baseItems.dup;
  subItems.byKeyValue
    .each!(kv => results.remove(kv.key));
  return results;
}
///
  unittest {
    assert([1: "4", 2: "5", 3: "6"].removeByKeys([2: "x", 3: "y"]) == [
        1: "4"
      ]);
  }

/// remove subItems from baseItems if value exists
T[S] removeByValues(T, S)(T[S] baseItems, T[S] subItems) {
  T[S] results = baseItems.dup;
  foreach (k, v; subItems) {
    baseItems.byKeyValue
      .filter!(kv => v == kv.value)
      .each!(kv => results.remove(kv.key));
  }
  return results;
}

version (test_uim_core) {
  unittest {
    assert([1: "4", 2: "5", 3: "6"].removeByValues([2: "5", 3: "6"]) == [
        1: "4"
      ]);
    assert([7: "4", 8: "5", 9: "6"].removeByValues([2: "5", 3: "6"]) == [
        7: "4"
      ]);
    assert([7: "4", 8: "5", 9: "6"].removeByValues([2: "2", 3: "2"]) != [
        7: "4"
      ]);

    assert([1: 4, 2: 5, 3: 6].removeByValues([2: 5, 3: 6]) == [1: 4]);
    assert([7: 4, 8: 5, 9: 6].removeByValues([2: 5, 3: 6]) == [7: 4]);
    assert([7: 4, 8: 5, 9: 6].removeByValues([2: 2, 3: 2]) != [7: 4]);
  }
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
  bool hasAllKeys(T, S)(T[S] base, S[] keys...) {
    return base.hasAllKeys(keys.dup);
  }

  bool hasAllKeys(T, S)(T[S] base, S[] keys) {
    return keys.all!(key => base.hasKey(key));
  }
  ///
  unittest {
    assert(["a": 1, "b": 2, "c": 3].hasAllKeys(["a", "b", "c"]));
    assert(!["a": 1, "b": 2, "c": 3].hasAllKeys(["x", "b", "c"]));

    assert(["a": "b", "c": "d"].hasAllKeys("a"));
    assert(["a": "b", "c": "d"].hasAllKeys("a", "c"));
    assert(["a": "b", "c": "d"].hasAllKeys(["a"]));
    assert(["a": "b", "c": "d"].hasAllKeys(["a", "c"]));

    assert(!["a": "b", "c": "d"].hasAllKeys("x"));
    assert(!["a": "b", "c": "d"].hasAllKeys("x", "c"));
    assert(!["a": "b", "c": "d"].hasAllKeys(["x"]));
    assert(!["a": "b", "c": "d"].hasAllKeys(["x", "c"]));

  }
// #endregion hasAllKeys

// #region hasAnyKey
  bool hasAnyKeys(T, S)(T[S] base, S[] keys...) {
    return base.hasAnyKeys(keys.dup);
  }

  bool hasAnyKeys(T, S)(T[S] base, S[] keys) {
    return keys.any!(key => base.hasKey(key));
  }
  ///
  unittest {
    assert(["a": "b", "c": "d"].hasAnyKeys("a"));
    assert(["a": "b", "c": "d"].hasAnyKeys("a", "x"));
    assert(["a": "b", "c": "d"].hasAnyKeys(["a"]));
    assert(["a": "b", "c": "d"].hasAnyKeys(["a", "x"]));

    assert(!["a": "b", "c": "d"].hasAnyKeys("x"));
    assert(!["a": "b", "c": "d"].hasAnyKeys("x", "y"));
    assert(!["a": "b", "c": "d"].hasAnyKeys(["x"]));
    assert(!["a": "b", "c": "d"].hasAnyKeys(["x", "y"]));
  }
// #endregion hasAnyKey

bool hasKey(T, S)(T[S] base, S key) {
  return (key in base)
    ? true : false;
}
///
unittest {
  assert(["a": "b", "c": "d"].hasKey("a"));
  assert(!["a": "b", "c": "d"].hasKey("x"));
}

bool hasValue(T, S)(T[S] base, S value...) {
  foreach (v; base.getValues)
    if (v == value) {
      return true;
    }
  return false;
}

// #region hasAllValues
  bool hasAllValues(T, S)(T[S] base, S[] values...) {
    return base.hasAllValues(values);
  }

  bool hasAllValues(T, S)(T[S] base, S[] values) {
    return values.all!(value => base.hasValue(value));
  }
  unittest {
    assert(["a": "b", "c": "d"].hasAllValues("b"));
    assert(["a": "b", "c": "d"].hasAllValues("b", "d"));
    assert(["a": "b", "c": "d"].hasAllValues(["b"]));
    assert(["a": "b", "c": "d"].hasAllValues(["b", "d"]));
  }
// #endregion hasAllValues



pure string toJSONString(T)(T[string] values, bool sorted = NOTSORTED) {
  string result = "{" ~ values
    .getKeys(sorted)
    .map!(key => `"%s":%s`.format(key, values[key]))
    .join(",") ~ "}";

  return result;
}

unittest {
  assert(["a": 1, "b": 2].toJSONString(SORTED) == `{"a":1,"b":2}`);
}

pure string toHTML(T)(T[string] values, bool sorted = NOTSORTED) {
  string result = values
    .getKeys(sorted)
    .map!(key => `%s="%s"`.format(key, values[key])).join(" ");

  return result;
}

unittest {
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
  assert(["a": 1, "b": 2].toSqlUpdate(SORTED) == `a=1,b=2`);
}

/// Checks if key exists and has values
pure bool isValue(T, S)(T[S] base, S key, T value) {
  if (key in base) {
    return (base[key] == value);
  }
  return false;
}
  ///
  unittest {
    // TODO 
  }

version (test_uim_core) {
  unittest {
    assert(["a": 1, "b": 2].isValue("a", 1));
    assert(!["a": 2, "b": 2].isValue("a", 1));
    assert(["a": 1, "b": 1].isValue("a", 1));
    assert(!["a": 2, "b": 1].isValue("a", 1));
    assert(["a": 1, "b": 2].isValue("b", 2));
  }
}

// Checks if values exist in base
pure bool isValues(T, S)(T[S] base, T[S] values) {
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
    assert(["a": 1, "b": 2].isValues(["a": 1, "b": 2]));
    assert(!["a": 1, "b": 2].isValues(["a": 1, "b": 3]));
    assert(!["a": 1, "b": 2].isValues(["a": 1, "c": 2]));
  }

V[K] merge(K, V)(V[K] sourceValues, V[K] mergeValues, bool overwrite = false) {
  auto result = sourceValues.dup;
  if (mergeValues is null)
    return result;

  foreach (k, v; mergeValues) {
    if (overwrite)
      result[k] = v;
    else {
      if (k !in result)
        result[k] = v;
    }
  }

  return result;
}
  ///
  unittest {
    // TODO 
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

// #region update
  /// Creates a new updated array without changing the origin array
  /// Params:
  ///   origin = array to update
  ///   updates = array fpr update
  /// Returns: 
  /// 
  /// Params:
  ///   updated new array
  V[K] update(K, V)(V[K] originalValues, V[K] updates) {
    V[K] updatedValues = originalValues.dup;
    updatedValues.byKeyValue
      .each!(kv => updatedValues[kv.key] = kv.value);

    return updatedValues;
  }
  ///
  unittest {
    // TODO 
  }

  V[K] update(K, V)(V[K] originalValues, K key, v newValue) {
    V[K] updatedValues = originalValues.dup;
    updatedValues[key] = newValue;

    return updatedValues;
  }
  ///
  unittest {
    // TODO 
  }
// #endregion update

V ifNull(K, V)(V[K] map, K key, V defaultValue) {
  return key in map 
    ? (!map[k].isNull ? map[k] : defaultValue)
    : defaultValue;
}