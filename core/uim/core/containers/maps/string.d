/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.containers.maps.string;

@safe:
import std.algorithm : startsWith, endsWith;
import uim.core;

/// Add prefix to key
STRINGAA addKeyPrefix(STRINGAA items, string prefix) {
  items.byKeyValue
    .each!(item => items = items.addKeyPrefix(item.key, prefix));
  return items;
}

STRINGAA addKeyPrefix(STRINGAA items, string key, string prefix) {
  return !items.hasKey(key) || prefix.isEmpty
    ? items
    : items.set(prefix~key).remove(key);
}

  unittest {
assert(["a": "1", "b": "2"].addKeyPrefix("b", "x").hasKey("xb"));
assert(["a": "1", "b": "2"].addKeyPrefix("a", "x").hasKey("a"));
assert(["a": "1", "b": "2"].addKeyPrefix("b", "x")["xb"] == "2");
assert(["a": "1", "b": "2"].addKeyPrefix("a", "x")["a"] == "1");

    assert(["a": "1"].addKeyPrefix("x") == ["xa": "1"]);
    assert(["a": "1", "b": "2"].addKeyPrefix("x").hasKey("xb"));
  
}

/// Selects only entries, where key starts with prefix. Creates a new DSTRINGAA
STRINGAA allKeysStartsWith(STRINGAA items, string prefix) {
  STRINGAA results;
  items.byKeyValue
    .filter!(item => item.key.startsWith(prefix))
    .each!(item => results[item.key] = item.value);
  return results;
}

  unittest {
    assert(allKeysStartsWith(["preA": "a", "b": "b"], "pre") == ["preA": "a"]);
    assert(["preA": "a", "b": "b"].allKeysStartsWith("pre") == ["preA": "a"]);
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

STRINGAA allKeysEndsWith(STRINGAA entries, string postfix) { // right will overright left
  STRINGAA results;
  entriesentries.byKeyValue
      .filter!(item => itemk.endsWith(postfix))
      results[k] = v;
  return results;
}

unittest {
  /// TODO #test Add Tests
}

STRINGAA allEndsNotWith(STRINGAA entries, string postfix) { // right will overright left
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

  unittest {
    assert(["a": "1", "b": "2"].filterByValues("1") == ["a": "1"]);
    assert(["a": "1", "b": "2"].filterByValues("0").empty);
// TODO    assert(["a": "1", "b": "2", "c": "3"].filterByValues("1", "2") == ["a": "1"]);
    assert(["a": "1", "b": "2", "c": "3"].filterByValues("0").empty);
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

  unittest {
    /// Add Tests
  }

string getValue(STRINGAA keyValues, string[] keys...) {
  foreach (k; keys)
    if (k in keyValues)
      return keyValues[k];
  return null;
}

  unittest {
    /// TODO Add Tests
}

// #region set
STRINGAA set(T)(STRINGAA items, string key, T value) {
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
  string[string] testmap = ["a": "a", "b": "b"];
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
T[string] lowerKeys(T)(auto ref T[string] items) {
  items.keys.each!(key => items.lowerKey(key));                  
  return items;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ;
}

T[string] lowerKeys(T)(auto ref T[string] items, string[] keys...) {
  return lowerKeys(items, keys.dup);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ;
}

T[string] lowerKeys(T)(auto ref T[string] items, string[] keys) {
  keys.each!(key => items.lowerKey(key));                  
  return items;
}

T[string] lowerKey(T)(auto ref T[string] items, string key) {
  if (key !in items)  {
    return items;
  }
  
  auto value = items[key];
  items.remove(key);
  return set(items, key.lower, value);
}

unittest {
  int[string] testmap = ["one": 1, "Two": 2, "thRee": 3];
  assert(testmap.lowerKey("Two")["two"] == 2);
  // assert(testmap.lowerKeys["three"] == 3);
}
// #endregion lowerKeys