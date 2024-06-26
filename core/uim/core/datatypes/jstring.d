module uim.core.datatypes.jstring;

import uim.core;

@safe:

Json[string] data(Json[string] values, string[] keys = null) {
  if (keys.length == 0) {
    return values.dup;
  }

  Json[string] results;
  keys
    .filter!(key => key in values)
    .each!(key => results[key] = values[key]);

  return results;
}

// #region merge
Json[string] merge(Json[string] originValues, Json valuesToMerge) {
  Json[string] mergedValues = originValues.dup;
  if (!valuesToMerge.isObject) {
    return mergedValues;
  }

  valuesToMerge.byKeyValue
    .each!(kv => mergedValues = mergedValues.merge(kv.key, kv.value));

  return mergedValues;
}

Json[string] merge(Json[string] baseData, string key, Json value) {
  Json[string] mergedValues = baseData.dup;
  if (key !in baseData) {
    mergedValues[key] = value;
  }
  return mergedValues;
}
// #endregion merge

Json[string] copy(Json[string] origin) {
  Json[string] results;
  origin.byKeyValue
    .each!(kv => results[kv.key] = kv.value);

  return results;
}

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
  /*     assert(jsonMain.getMap("x")["A"].getString == "A");
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
Json[string] setNull(Json[string] json, string key) {
  json[key] = Json(null);
  return json;
}

Json[string] set(Json[string] json, string key, bool value) {
  json[key] = Json(value);
  return json;
}

Json[string] set(Json[string] json, string key, int value) {
  json[key] = Json(value);
  return json;
}

Json[string] set(Json[string] json, string key, long value) {
  json[key] = Json(value);
  return json;
}

Json[string] set(Json[string] json, string key, float value) {
  json[key] = Json(value);
  return json;
}

Json[string] set(Json[string] json, string key, double value) {
  json[key] = Json(value);
  return json;
}

Json[string] set(Json[string] json, string key, string value) {
  json[key] = Json(value);
  return json;
}

Json[string] set(Json[string] json, string key, Json value) {
  json[key] = value;
  return json;
}

Json[string] set(Json[string] json, string key, Json[] value) {
  json[key] = value;
  return json;
}

Json[string] set(T)(Json[string] json, string key, T[string] value) {
  Json[string] convertedValues;
  value.byKeyValue.each!(kv => convertedValues[kv.key] = Json(kv.value));
  json.set(key, convertedValues);
  return json;
}

Json[string] set(Json[string] json, string key, Json[string] value) {
  json[key] = value;
  return json;
}

unittest {
  Json[string] json;
  assert(json.set("bool", true).getBoolean("bool"));
  assert(json.set("bool", true).getBoolean("bool"));
  assert(json.set("long", 1).getLong("long") == 1);
  assert(json.set("double", 0.1).getDouble("double") == 0.1);
  assert(json.set("string", "A").getString("string") == "A");
  // TODO assert(json.set("strings", ["x": "X", "y": "Y", "z": "Z"]) != Json(null));
  writeln(json);
}
// #endregion setter
