/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.string_;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;

STRINGAA allEndsNotWith(string[string] entries, string postfix) { // right will overright left
  STRINGAA results;
  entries.byKeyValue
    .filter!(item => !item.key.endsWith(postfix))
    .each!(item => results[item.key] = item.value);
  return results;
}

unittest {
  /// TODO Add Tests
}

// #region filter
STRINGAA filterByValues(string[string] entries, string[] values...) {
  return filterByValues(entries, values.dup);
}

STRINGAA filterByValues(string[string] entries, string[] someValues) {
  STRINGAA results;
  foreach (myValue; someValues) {
    entries.byKeyValue
      .filter!(kv => kv.value == myValue)
      .each!(kv => results[kv.key] = entries[kv.key]);
  }
  return results;
}

unittest {
  assert(["a": "1", "b": "2"].filterByValues("1") == ["a": "1"]);
  assert(["a": "1", "b": "2"].filterByValues("0").empty);
  // TODO    assert(["a": "1", "b": "2", "c": "3"].filterByValues("1", "2") == ["a": "1"]);
  assert(["a": "1", "b": "2", "c": "3"].filterByValues("0").empty);
}
// #endregion filter

string toString(string[string] aa) {
  return "%s".format(aa);
}


  unittest {
    /// Add Tests
  }


string aa2String(string[string] atts, string sep = "=") {
  string[] strings;
  foreach (k, v; atts)
    strings ~= k ~ sep ~ "\"" ~ v ~ "\"";
  return strings.join(" ");
}

unittest {
  /// Add Tests
}

string value(string[string] keyValues, string[] keys...) {
  foreach (k; keys)
    if (k in keyValues)
      return keyValues[k];
  return null;
}

unittest {
  /// TODO Add Tests
}



// #region update
STRINGAA update(string[string] items, string key, bool value) {
  return items.update(key, to!string(value));
}

STRINGAA update(string[string] items, string key, long value) {
  return items.update(key, to!string(value));
}

STRINGAA update(string[string] items, string key, double value) {
  return items.update(key, to!string(value));
}

STRINGAA update(string[string] items, string key, Json value) {
  return items.update(key, value.toString);
}

STRINGAA update(string[string] items, string key, string value = null) {
  items[key] = value;
  return items;
}

unittest {
  string[string] testmap = ["a": "a", "b": "b"];
  assert(update(testmap, "a", "A")["a"] == "A");
}
// #endregion update

// #region merge
STRINGAA merge(string[string] items, string key, bool value) {
  return items.merge(key, to!string(value));
}

STRINGAA merge(string[string] items, string key, long value) {
  return items.merge(key, to!string(value));
}

STRINGAA merge(string[string] items, string key, double value) {
  return items.merge(key, to!string(value));
}

STRINGAA merge(string[string] items, string key, Json value) {
  return items.merge(key, value.toString);
}

STRINGAA merge(string[string] items, string key, string value = null) {
  items[key] = value;
  return items;
}

unittest {
  string[string] testmap;
  assert(merge(testmap, "a", "A")["a"] == "A");
}
// #endregion merge


