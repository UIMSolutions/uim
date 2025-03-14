/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.string_;

import uim.core;
@safe:

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// #region allEndsNotWith
string[string] allEndsNotWith(string[string] entries, string postfix) { // right will overright left
  string[string] results;
  entries.byKeyValue
    .filter!(item => !item.key.endsWith(postfix))
    .each!(item => results[item.key] = item.value);
  return results;
}

unittest {
  /// TODO Add Tests
}
// #endregion allEndsNotWith

// #region filterByValues
/* string[string] filterByValues(string[string] entries, string[] values...) {
  return filterByValues(entries, values.dup);
}

string[string] filterByValues(string[string] entries, string[] values) {
  string[string] results;
  foreach (value; values) {
    entries.byKeyValue
      .filter!(kv => kv.value == value)
      .each!(kv => results[kv.key] = entries[kv.key]);
  }
  return results;
}

unittest {
  auto map = ["1": 1, "2": 2, "3": 3];
  assert(map.filterByValues([1, 2]) == ["1": 1, "2": 2]);
  assert(map.filterByValues(1, 2) == ["1": 1, "2": 2]);
} */
// #endregion filterByValues

// #region aa2String
string aa2String(string[string] atts, string sep = "=") {
  string[] strings;
  foreach (k, v; atts)
    strings ~= k ~ sep ~ "\"" ~ v ~ "\"";
  return strings.join(" ");
}

unittest {
  /// Add Tests
}
// #endregion aa2String

// #region update
/*   // returns a updated map with new values
  string[string] update(T)(string[string] items, T[string] others, string[] keys...) {
    return update(items, others, keys.dup);
  }

  // Returns a new map with updated values for existing keys
  string[string] update(T)(string[string] items, T[string] others, string[] keys = null) {
    keys.length == 0
      ? others
      .each!((key, value) => items.update(key, value)) : keys
      .each!(key => items.update(key, others[key]));

    return items;
  }
 */
/*   string[string] update(T)(string[string] items, string[] keys, T value) {
    keys.each!(key => items.update!(K, V)(key, to!string(value)));
    return items;
  }

  string[string] update(T)(string[string] items, string key, T value) if (!is(typeof(T) == string))  {
    return items.update!(K, V)(key, to!string(value));
  }
 */
/* string[string] update(T:Json)(string[string] items, string key, T value) {
  return items.update!(K, V)(key, value.toString);
} */

/* unittest {
    string[string] test = ["a": "A", "b": "B", "c": "C"];
    assert(test.length == 3 && test.hasAllKeys("a", "b", "c") && test["a"] == "A");

    test.update("a", "x").update("d", "x").update("e", "x").update("f", "x");
    assert(test.length == 3 && !test.hasAnyKey("d", "e", "f") && test["a"] == "x");

    test = ["a": "A", "b": "B", "c": "C"]; // Reset map
    update(test, ["c", "d", "e"], "x");
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
} */
// #endregion update

// #region merge
string[string] merge(string[string] items, string key, bool value) {
  return items.merge(key, to!string(value));
}

string[string] merge(string[string] items, string key, int value) {
  return items.merge(key, to!string(value));
}

string[string] merge(string[string] items, string key, long value) {
  return items.merge(key, to!string(value));
}

string[string] merge(string[string] items, string key, double value) {
  return items.merge(key, to!string(value));
}

string[string] merge(string[string] items, string key, Json value) {
  return items.merge(key, value.toString);
}

string[string] merge(string[string] items, string key, string value) {
  if (!items.hasKey(key)) {
    items[key] = value;
  }
  return items;
}

unittest {
  string[string] testmap;
  assert(testmap.merge("a", "A")["a"] == "A");
  assert(testmap.merge("x", true)["x"] == "true");
  assert(testmap.merge("y", 1)["y"] == "1");
  assert(testmap.merge("z", 1.1)["z"] == "1.1");  
  assert(!testmap.hasAnyKey("a", "x", "y", "z"));

  testmap = ["0": ""];
  assert(testmap.merge("a", "A")["a"] == "A");
  assert(testmap.merge("x", true)["x"] == "true");
  assert(testmap.merge("y", 1)["y"] == "1");
  assert(testmap.merge("z", 1.1)["z"] == "1.1");  
  assert(testmap.hasAllKeys("a", "x", "y", "z"));
  assert(!testmap.hasAllKeys("a", "x", "-", "z"));
 }
// #endregion merge
