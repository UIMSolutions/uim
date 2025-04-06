module uim.core.datatypes.json.keys;

import uim.core;

@safe:

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// #region keys
// Get keys from json object
string[] keys(Json json) {
  return json.isObject
    ? json.byKeyValue.map!(kv => kv.key).array : null;
}
unittest {
  auto json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": "h"}]}`);
  assert(json.keys.hasAllKeys("a", "c", "e"));
  assert(!json.keys.hasAllKeys("a", "c", "x"));
}
// #endregion keys

// #region hasKey
// Check if json has key
bool hasAllKeys(Json json, string[] keys...) {
  return hasAllKeys(json, keys.dup, false);
}

// Check if json has key
bool hasAllKeys(Json json, string[] keys) {
  return keys.all!(key => hasKey(json, key, false));
}

bool hasAllKeys(Json json, string[] keys, bool deepSearch) {
  return keys.all!(key => hasKey(json, key, deepSearch));
}

/// Check if Json has key
bool hasAnyKeys(Json json, string[] keys...) {
  return json.hasAnyKeys(keys.dup, false);
}

/// Check if Json has key
bool hasAnyKeys(Json json, string[] keys) {
  return keys.any!(key => hasKey(json, key, false));
}

/// Check if Json has key
bool hasAnyKeys(Json json, string[] keys, bool deepSearch) {
  return keys.any!(key => hasKey(json, key, deepSearch));
}

/// Searching key in json, if depth = true also in subnodes  
bool hasKey(Json json, string key, bool deepSearch = false) {
  if (!json.isObject)
    return false;

  foreach (kv; json.byKeyValue) {
    if (kv.key == key) {
      return true;
    }
    if (deepSearch) {
      if (kv.value.hasKey(key, deepSearch))
        return true;
    }
  }

  return false;
}

unittest {
  auto json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": "h"}]}`);
  assert(json.hasKey("a"));
  assert(json.hasKey("d", true));
  assert(
    !json.hasKey("x", true));
  assert(json.hasAnyKeys(["y", "c"]));
  assert(
    json.hasAnyKeys(["y", "d"], true));
  assert(json.hasAnyKeys("y", "c"));
  assert(!json.hasAnyKeys("x", "y"));
  assert(json.hasAllKeys([
        "a", "c"
      ]));
  assert(json.hasAllKeys(["a", "d"], true));
  assert(json.hasAllKeys("a", "c"));
  assert(!json.hasAllKeys("x", "c"));
}
// #endregion hasKey
