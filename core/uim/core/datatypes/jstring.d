module uim.core.datatypes.jstring;

import uim.core;

@safe:

Json[string] setKeys(Json[string] values, string[] keys, Json defaultValue = Json(null)) {
  keys.each!(key => values.set(key, defaultValue));
  return values;
}

Json[string] mergeKeys(Json[string] values, string[] keys, Json defaultValue = Json(null)) {
  keys.each!(key => values.merge(key, defaultValue));
  return values;
}

Json[string] updateKeys(Json[string] values, string[] keys, Json defaultValue = Json(null)) {
  keys.each!(key => update.merge(key, defaultValue));
  return values;
}

Json[string] copy(Json[string] values, string[] keys = null) {
  if (keys.length == 0) {
    return values.dup;
  }

  Json[string] results;
  keys
    .filter!(key => values.hasKey(key))
    .each!(key => results[key] = values[key]);

  return results;
}

// #region merge
Json[string] merge(Json[string] values, Json[string] valuesToMerge) {
  valuesToMerge.byKeyValue
    .each!(kv => values.merge(kv.key, kv.value));

  return values;
}

Json[string] merge(Json[string] values, Json valuesToMerge) {
  if (!valuesToMerge.isObject) {
    return values;
  }

  valuesToMerge.byKeyValue
    .each!(kv => values.merge(kv.key, kv.value));

  return values;
}

Json[string] merge(Json[string] values, string key, bool value) {
  if (key !in values) {
    values[key] = Json(value);
  }
  return values;
}

Json[string] merge(Json[string] values, string key, long value) {
  if (key !in values) {
    values[key] = Json(value);
  }
  return values;
}

Json[string] merge(Json[string] values, string key, double value) {
  if (key !in values) {
    values[key] = Json(value);
  }
  return values;
}

Json[string] merge(Json[string] values, string key, string value) {
  if (key !in values) {
    values[key] = Json(value);
  }
  return values;
}

Json[string] merge(Json[string] values, string key, Json value) {
  if (key !in values) {
    values[key] = value;
  }
  return values;
}
// #endregion merge



// #region Getter
Json getJson(Json[string] values, string key) {
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
  Json[string] jMap;
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

bool getBoolean(Json[string] values, string key, bool defaultValue = false) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!bool : defaultValue;
}

int getInteger(Json[string] values, string key, int defaultValue = 0) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!int : defaultValue;
}

long getLong(Json[string] values, string key, long defaultValue = 0) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!long : defaultValue;
}

double getDouble(Json[string] values, string key, double defaultValue = 0.0) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!double : defaultValue;
}

string getString(Json[string] values, string key, string defaultValue = null) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!string : defaultValue;
}

unittest {
  Json[string] values;
  values["a"] = Json("A");
  values["b"] = "B".toJson;
  assert(values.getString("a") == "A");
  assert(values.getString("b") != "A");
  assert(values.getString("b") == "B");
}

// #region getStrings
STRINGAA getStrings(Json[string] values, string[] keys...) {
  return getStrings(values, keys.dup);
}

STRINGAA getStrings(Json[string] values, string[] keys) {
  STRINGAA results;
  keys.each!(key => results[key] = values.getString(key));
  return results;
}

unittest {
  Json[string] values;
  values["a"] = Json("A");
  values["b"] = "B".toJson;
  assert(values.getStrings(["a"]) == ["a": "A"]);
}
// #endregion getStrings

Json getJson(Json[string] values, string key, Json defaultValue = Json(null)) {
  return key in values
    ? values[key] : defaultValue;
}

Json[] getArray(Json[string] values, string key, Json[] defaultValue = null) {
  auto json = getJson(values, key);
  return !json.isNull
    ? json.get!(Json[]) : defaultValue;
}

Json[string] getMap(Json[string] values, string key, Json[string] defaultValue = null) {
  auto json = getJson(values, key);
  return !json.isNull && json.isObject
    ? json.get!(Json[string]) : defaultValue;
}

unittest {
  Json json = Json.emptyObject;
  json["a"] = "A";
  json["one"] = 1;

  Json[string] jsonMain = ["x": json];

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

bool isEmpty(Json[string] values, string key) {
  return (key !in values || values[key].isNull);
}

Json[string] filterKeys(Json[string] values, string[] keys) {
  if (keys.length == 0) {
    return values.dup;
  }

  Json[string] filteredData;
  keys
    .filter!(key => key in values)
    .each!(key => filteredData[key] = values[key]);

  return filteredData;
}

// #region setter
Json[string] setNull(Json[string] map, string key) {
  map[key] = Json(null);
  return map;
}

Json[string] set(Json[string] map, string key, bool value) {
  map[key] = Json(value);
  return map;
}

Json[string] set(Json[string] map, string key, int value) {
  map[key] = Json(value);
  return map;
}

Json[string] set(Json[string] map, string key, long value) {
  map[key] = Json(value);
  return map;
}

Json[string] set(Json[string] map, string key, float value) {
  map[key] = Json(value);
  return map;
}

Json[string] set(Json[string] map, string key, double value) {
  map[key] = Json(value);
  return map;
}

Json[string] set(Json[string] map, string key, string value) {
  map[key] = Json(value);
  return map;
}

Json[string] set(Json[string] map, string key, Json value) {
  map[key] = value;
  return map;
}

Json[string] set(Json[string] map, string key, Json[] value) {
  map[key] = value;
  return map;
}

Json[string] set(T)(Json[string] map, string key, T[string] value) {
  Json[string] convertedValues;
  value.byKeyValue.each!(kv => convertedValues[kv.key] = Json(kv.value));
  map.set(key, convertedValues);
  return map;
}

Json[string] set(Json[string] map, string key, Json[string] value) {
  map[key] = value;
  return map;
}

unittest {
  Json[string] json;
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
Json[string] toJsonMap(bool[string] values, string[] excludeKeys = null) {
  Json[string] result;
  values.byKeyValue
      .filter!(kv => !excludeKeys.any!(key => values.hasKey(key)))
      .each!(kv => result[kv.key] = Json(kv.value));
  return result;
} 

Json[string] toJsonMap(long[string] values, string[] excludeKeys = null) {
  Json[string] result;
  values.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => values.hasKey(key)))
    .each!(kv => result[kv.key] = Json(kv.value));
  return result;
} 

Json[string] toJsonMap(double[string] values, string[] excludeKeys = null) {
  Json[string] result;
  values.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => values.hasKey(key)))
    .each!(kv => result[kv.key] = Json(kv.value));
  return result;
} 

Json[string] toJsonMap(string[string] values, string[] excludeKeys = null) {
  Json[string] result;
  values.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => values.hasKey(key)))
    .each!(kv => result[kv.key] = Json(kv.value));
  return result;
} 
unittest {
  assert(["a": "A", "b":"B"].toJsonMap.length == 2);
  assert(["a": "A", "b":"B"].toJsonMap.getString("a") == "A");
  assert(["a": "A", "b":"B"].toJsonMap(["b"]).length == 1);
  assert(["a": "A", "b":"B"].toJsonMap(["b"]).getString("a") == "A");
}
// #endregion convert

bool isScalar(string key) {
  return hasKey(key) && get(key).isScalar;
}