module uim.core.datatypes.jmap;

import uim.core;

@safe:

alias JMAP = Json[string];

unittest { // inherited from uim.core.containers.map
  JMAP values = [
    "a": Json("A"),
    "b": Json("B"),
    "c": Json("C")
    ];

  assert(values.sortedKeys == ["a", "b", "c"]);

  JMAP setKeys(JMAP values, string[] keys, Json defaultValue = Json(null)) {
  keys.each!(key => values.set(key, defaultValue));
  return values;
}

JMAP mergeKeys(JMAP values, string[] keys, Json defaultValue = Json(null)) {
  keys.each!(key => values.merge(key, defaultValue));
  return values;
}

JMAP updateKeys(JMAP values, string[] keys, Json defaultValue = Json(null)) {
  keys.each!(key => values.updateKey(key, defaultValue));
  return values;
}
}

JMAP copy(JMAP values, string[] keys = null) {
  if (keys.length == 0) {
    return values.dup;
  }

  JMAP results;
  keys
    .filter!(key => values.hasKey(key))
    .each!(key => results[key] = values[key]);

  return results;
}

// #region merge
JMAP merge(JMAP values, JMAP valuesToMerge) {
  valuesToMerge.byKeyValue
    .each!(kv => values.merge(kv.key, kv.value));

  return values;
}

JMAP merge(JMAP values, Json valuesToMerge) {
  if (!valuesToMerge.isObject) {
    return values;
  }

  valuesToMerge.byKeyValue
    .each!(kv => values.merge(kv.key, kv.value));

  return values;
}

JMAP merge(JMAP values, string key, bool value) {
  if (key !in values) {
    values[key] = Json(value);
  }
  return values;
}

JMAP merge(JMAP values, string key, long value) {
  if (key !in values) {
    values[key] = Json(value);
  }
  return values;
}

JMAP merge(JMAP values, string key, double value) {
  if (key !in values) {
    values[key] = Json(value);
  }
  return values;
}

JMAP merge(JMAP values, string key, string value) {
  if (key !in values) {
    values[key] = Json(value);
  }
  return values;
}

JMAP merge(JMAP values, string key, Json value) {
  if (key !in values) {
    values[key] = value;
  }
  return values;
}
// #endregion merge

// #region Getter
Json getJson(JMAP values, string key) {
  key = key.strip;
  if (values.hasKey(key)) {
    return values[key];
  }
  if (key.contains(".")) {
    string[] keys = std.string.split(key, ".");
    if (values.hasKey(keys[0])) {
      auto json = getJson(values, keys[0]);
      return keys.length > 1 && !json.isNull
        ? uim.core.datatypes.json.getJson(json, keys[1 .. $].join(".")) : json;
    }
  }
  return Json(null);
}

unittest {
  JMAP jMap;
  jMap["a"] = Json("a");
  jMap["b"] = Json("b");
  jMap["a.b"] = Json("a.b");

  auto jObj = Json.emptyObject;
  jObj["c"] = "c";
  jObj["d"] = "d";
  jObj["c.d"] = "c.d";
  jObj["x"] = jObj;

  jMap["z"] = jObj;

  assert(jMap.getString("a") == "a");
  assert(jMap.getString("b") != "a");
  assert(jMap.getString("a.b") == "a.b");
  assert(jMap.getString("z.c") == "c");
  assert(jMap.getString("z.d") != "c");
  assert(jMap.getString("z.c.d") == "c.d");
  assert(jMap.getString("z.x.c") == "c");
  assert(jMap.getString("z.x.d") != "c");
  assert(jMap.getString("z.x.c.d") == "c.d");
  writeln("z.x.c.d = ", jMap.getString("z.x.c.d"));
}

bool getBoolean(JMAP values, string key, bool defaultValue = false) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!bool : defaultValue;
}

int getInteger(JMAP values, string key, int defaultValue = 0) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!int : defaultValue;
}

long getLong(JMAP values, string key, long defaultValue = 0) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!long : defaultValue;
}

double getDouble(JMAP values, string key, double defaultValue = 0.0) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!double : defaultValue;
}

string getString(JMAP values, string key, string defaultValue = null) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!string : defaultValue;
}

unittest {
  JMAP values;
  values["a"] = Json("A");
  values["b"] = "B".toJson;
  assert(values.getString("a") == "A");
  assert(values.getString("b") != "A");
  assert(values.getString("b") == "B");
}

// #region getStrings
STRINGAA getStrings(JMAP values, string[] keys...) {
  return getStrings(values, keys.dup);
}

STRINGAA getStrings(JMAP values, string[] keys) {
  STRINGAA results;
  keys.each!(key => results[key] = values.getString(key));
  return results;
}

unittest {
  JMAP values;
  values["a"] = Json("A");
  values["b"] = "B".toJson;
  assert(values.getStrings(["a"]) == ["a": "A"]);
}
// #endregion getStrings

Json getJson(JMAP values, string key, Json defaultValue = Json(null)) {
  return key in values
    ? values[key] : defaultValue;
}

Json[] getArray(JMAP values, string key, Json[] defaultValue = null) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!(Json[]) : defaultValue;
}

JMAP getMap(JMAP values, string key, JMAP defaultValue = null) {
  auto json = getJson(values, key);
  return !json.isNull && json.isObject
    ? json.get!(JMAP) : defaultValue;
}

unittest {
  Json json = Json.emptyObject;
  json["a"] = "A";
  json["one"] = 1;

  JMAP jsonMain = ["x": json];

  assert(jsonMain.getMap("x").getString("a") == "A");
  assert(jsonMain.getMap("x").getString("b") != "A");
  assert(jsonMain.getMap("x").getInteger("one") == 1);
  assert(jsonMain.getMap("x").getInteger("oNe") != 1);

  // TODO 
  /*    assert(jsonMain.getMap("x")["A"].getString == "A");
    assert(jsonMain.getMap("x")["one"].getInteger == 1);
 */
}
// #endregion Getter

bool isEmpty(JMAP values, string key) {
  return (key !in values || values[key].isNull);
}

JMAP filterKeys(JMAP values, string[] keys) {
  if (keys.length == 0) {
    return values.dup;
  }

  JMAP filteredData;
  keys
    .filter!(key => key in values)
    .each!(key => filteredData[key] = values[key]);

  return filteredData;
}

// #region setter
JMAP setNull(JMAP map, string key) {
  map[key] = Json(null);
  return map;
}

JMAP set(JMAP map, string key, bool value) {
  map[key] = Json(value);
  return map;
}

JMAP set(JMAP map, string key, int value) {
  map[key] = Json(value);
  return map;
}

JMAP set(JMAP map, string key, long value) {
  map[key] = Json(value);
  return map;
}

JMAP set(JMAP map, string key, float value) {
  map[key] = Json(value);
  return map;
}

JMAP set(JMAP map, string key, double value) {
  map[key] = Json(value);
  return map;
}

JMAP set(JMAP map, string key, string value) {
  map[key] = Json(value);
  return map;
}

JMAP set(JMAP map, string key, Json value) {
  map[key] = value;
  return map;
}

JMAP set(JMAP map, string key, Json[] value) {
  map[key] = value;
  return map;
}

JMAP set(T)(JMAP map, string key, T[string] value) {
  JMAP convertedValues;
  value.byKeyValue.each!(kv => convertedValues[kv.key] = Json(kv.value));
  map.set(key, convertedValues);
  return map;
}

JMAP set(JMAP map, string key, JMAP value) {
  map[key] = value;
  return map;
}

unittest {
  JMAP json;
  assert(json.set("bool", true).getBoolean("bool"));
  assert(json.set("bool", true).getBoolean("bool"));
  assert(json.set("long", 1).getLong("long") == 1);
  assert(json.set("double", 0.1).getDouble("double") == 0.1);
  assert(json.set("string", "A").getString("string") == "A");
  assert(json.set("a", "A").set("b", "B").hasAllKeys("a", "b"));
  assert(json.set("a", "A").set("b", "B").getString("b") == "B");
  assert(json.set("a", "A").set("b", "B").getString("b") != "C");
  // TODO assert(json.set("strings", ["x": "X", "y": "Y", "z": "Z"]) != Json(null));
  writeln(json);
}
// #endregion setter

// #region convert
JMAP toJsonMap(bool[string] values, string[] excludeKeys = null) {
  JMAP result;
  values.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => values.hasKey(key)))
    .each!(kv => result[kv.key] = Json(kv.value));
  return result;
}

JMAP toJsonMap(long[string] values, string[] excludeKeys = null) {
  JMAP result;
  values.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => values.hasKey(key)))
    .each!(kv => result[kv.key] = Json(kv.value));
  return result;
}

JMAP toJsonMap(double[string] values, string[] excludeKeys = null) {
  JMAP result;
  values.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => values.hasKey(key)))
    .each!(kv => result[kv.key] = Json(kv.value));
  return result;
}

JMAP toJsonMap(string[string] items, string[] excludeKeys = null) {
  JMAP result;
  items.byKeyValue
    .filter!(item => !excludeKeys.has(item.key))
    .each!(item => result[item.key] = Json(item.value));
  return result;
}

unittest {
  assert(["a": "A", "b": "B"].toJsonMap.length == 2);
  assert(["a": "A", "b": "B"].toJsonMap.getString("a") == "A");
  assert(["a": "A", "b": "B"].toJsonMap(["b"]).length == 1);
  assert(["a": "A", "b": "B"].toJsonMap(["b"]).getString("a") == "A");
}
// #endregion convert

bool isScalar(JMAP map, string key) {
  if (map is null) {
    return false;
  }
  return map.hasKey(key) && uim.core.datatypes.json.isScalar(map.getJson(key));
}
