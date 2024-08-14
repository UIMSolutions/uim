/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.containers.maps.string;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;

/// Renames keys to prefix~key
STRINGAA addKeyPrefix(STRINGAA entries, string prefix) {
  STRINGAA results;
  foreach (key, value; entries)
    results[prefix ~ key] = value;
  return results;
}

version (test_uim_core) {
  unittest {
    assert(["a": "1"].addKeyPrefix("x") == ["xa": "1"]);
    assert(["a": "1", "b": "2"].addKeyPrefix("x").hasKey("xb"));
  }
}

/// Selects only entries, where key starts with prefix. Creates a new DSTRINGAA
STRINGAA allStartsWith(STRINGAA entries, string prefix) {
  STRINGAA results;
  foreach (k, v; entries)
    if (k.startsWith(prefix))
      results[k] = v;
  return results;
}

version (test_uim_core) {
  unittest {
    assert(allStartsWith(["preA": "a", "b": "b"], "pre") == ["preA": "a"]);
    assert(["preA": "a", "b": "b"].allStartsWith("pre") == ["preA": "a"]);
  }
}

/// Opposite of selectStartsWith: Selects only entries, where key starts not with prefix. Creates a new DSTRINGAA
STRINGAA allStartsNotWith(STRINGAA entries, string prefix) { // right will overright left
  STRINGAA results;
  foreach (k, v; entries)
    if (!k.startsWith(prefix))
      results[k] = v;
  return results;
}

version (test_uim_core) {
  unittest {
    assert(allStartsNotWith(["preA": "a", "b": "b"], "pre") == ["b": "b"]);
    assert(["preA": "a", "b": "b"].allStartsNotWith("pre") == ["b": "b"]);
  }
}

STRINGAA allEndsWith(STRINGAA entries, string postfix) { // right will overright left
  STRINGAA results;
  foreach (k, v; entries)
    if (k.endsWith(postfix))
      results[k] = v;
  return results;
}

version (test_uim_core) {
  unittest {
    /// TODO #test Add Tests
  }
}

STRINGAA allEndsNotWith(STRINGAA entries, string postfix) { // right will overright left
  STRINGAA results;
  foreach (k, v; entries)
    if (!k.endsWith(postfix))
      results[k] = v;
  return results;
}

version (test_uim_core) {
  unittest {
    /// TODO Add Tests
  }
}

STRINGAA filterByKeys(STRINGAA entries, string[] keys...) {
  return filterByKeys(entries, keys.dup);
}

STRINGAA filterByKeys(STRINGAA entries, string[] keys) {
  STRINGAA results;
  keys
    .filter!(key => key in entries)
    .each!(key => results[key] = entries[key]);
    
  return results;
}

version (test_uim_core) {
  unittest {
    assert(["a": "1", "b": "2"].filterByKeys("a") == ["a": "1"]);
  }
}
STRINGAA notFilterByKeys(STRINGAA entries, string[] keys...) {
  return notFilterByKeys(entries, keys.dup);
}

STRINGAA notFilterByKeys(STRINGAA entries, string[] keys) {
  STRINGAA results = entries.dup;
  keys
    .filter!(key => key in entries)
    .each!(key => results.remove(key));

  return results;
}

version (test_uim_core) {
  unittest {
    assert(["a": "1", "b": "2"].notFilterByKeys("a") == ["b": "2"]);
  }
}

// #region filter
STRINGAA filterByValues(STRINGAA entries, string[] values...) {
  return filterByValues(entries, values.dup);
}

STRINGAA filterByValues(STRINGAA entries, string[] someValues) {
  STRINGAA results;
  foreach (myValue; someValues) {
    entries.byKeyValue
      .filter!(kv => kv.value == myValue)
      .each!(kv => results[kv.key] = entries[kv.key]);
  }
  return results;
}

version (test_uim_core) {
  unittest {
    assert(["a": "1", "b": "2"].filterByValues("1") == ["a": "1"]);
    assert(["a": "1", "b": "2"].filterByValues("0").empty);
    assert(["a": "1", "b": "2", "c": "3"].filterByValues("1", "2") == ["a": "1"]);
    assert(["a": "1", "b": "2", "c": "3"].filterByValues("0").empty);
  }
}
// #endregion filter

string toString(STRINGAA aa) {
  return "%s".format(aa);
}

version (test_uim_core) {
  unittest {
    /// Add Tests
  }
}

string aa2String(STRINGAA atts, string sep = "=") {
  string[] strings;
  foreach (k, v; atts)
    strings ~= k ~ sep ~ "\"" ~ v ~ "\"";
  return strings.join(" ");
}

version (test_uim_core) {
  unittest {
    /// Add Tests
  }
}

string getValue(STRINGAA keyValues, string[] keys...) {
  foreach (k; keys)
    if (k in keyValues)
      return keyValues[k];
  return null;
}

version (test_uim_core) {
  unittest {
    /// TODO Add Tests
  }
}

// #region set
STRINGAA set(STRINGAA items, string key, bool value) {
  return items.set(key, to!string(value));
}

STRINGAA set(STRINGAA items, string key, long value) {
  return items.set(key, to!string(value));
}

STRINGAA set(STRINGAA items, string key, double value) {
  return items.set(key, to!string(value));
}

STRINGAA set(STRINGAA items, string key, Json value) {
  return items.set(key, value.toString);
}

STRINGAA set(STRINGAA items, string key, string value = null) {
  items[key] = value;
  return items;
}

unittest {
  string[string] testmap;
  assert(set(testmap, "a", "A")["a"] == "A");
  assert(set(testmap, "a", "A").set("b", "B")["b"] == "B");
}
// #endregion set

// #region update
STRINGAA update(STRINGAA items, string key, bool value) {
  return items.update(key, to!string(value));
}

STRINGAA update(STRINGAA items, string key, long value) {
  return items.update(key, to!string(value));
}

STRINGAA update(STRINGAA items, string key, double value) {
  return items.update(key, to!string(value));
}

STRINGAA update(STRINGAA items, string key, Json value) {
  return items.update(key, value.toString);
}

STRINGAA update(STRINGAA items, string key, string value = null) {
  items[key] = value;
  return items;
}

unittest {
  string[string] testmap = ["a": "a", "b", "b"];
  assert(update(testmap, "a", "A")["a"] == "A");
}
// #endregion update

// #region merge
STRINGAA merge(STRINGAA items, string key, bool value) {
  return items.merge(key, to!string(value));
}

STRINGAA merge(STRINGAA items, string key, long value) {
  return items.merge(key, to!string(value));
}

STRINGAA merge(STRINGAA items, string key, double value) {
  return items.merge(key, to!string(value));
}

STRINGAA merge(STRINGAA items, string key, Json value) {
  return items.merge(key, value.toString);
}

STRINGAA merge(STRINGAA items, string key, string value = null) {
  items[key] = value;
  return items;
}

unittest {
  string[string] testmap;
  assert(merge(testmap, "a", "A")["a"] == "A");
}
// #endregion merge

// #region lowerKeys
T[string] lowerKeys(T)(ref T[string] items) {
  items.keys.each!(key => items.lowerKey(key));                  
  return items;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ;
}

T[string] lowerKeys(T)(ref T[string] items, string[] keys...) {
  return lowerKeys(items, keys.dup);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ;
}

T[string] lowerKeys(T)(ref T[string] items, string[] keys) {
  keys.each!(key => items.lowerKey(key));                  
  return items;
}

T[string] lowerKey(T)(ref T[string] items, string key) {
  if (key !in items)  {
    return items;
  }
  
  auto value = items[key];
  items.remove(key);
  return items.set(key.lower, value);
}

unittest {
  int[string] testmap = ["one": 1, "Two": 2, "thRee": 3];
  assert(testmap.lowerKey("Two")["two"] == 2);
  assert(testmap.lowerKeys["three"] == 3);
}
// #endregion lowerKeys