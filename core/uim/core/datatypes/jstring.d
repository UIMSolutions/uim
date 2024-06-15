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

Json[string] merge(Json[string] originValues, Json mergeValues) {
  Json[string] mergedValues = originValues.dup;
  if (!mergeValues.isObject) {
    return mergedValues;
  }

  mergeValues.byKeyValue
    .filter!(kv => kv.key !in originValues)
    .each!(kv => mergedValues[kv.key] = kv.value);

  return mergedValues;
}

Json[string] merge(Json[string] baseData, string key, Json value) {
  Json[string] mergedValues = baseData.dup;
  if (key !in baseData) {
    mergedValues[key] = value;
  }
  return mergedValues;
}

Json[string] copy(Json[string] origin) {
  Json[string] results;
  origin.byKeyValue
    .each!(kv => results[kv.key] = kv.value);

  return results;
}

bool getBoolean(Json[string] values, string key, bool defaultValue = false) {
  return key in values 
    ? values[key].get!bool
    : defaultValue;
}

long getLong(Json[string] values, string key, long defaultValue = 0) {
  return key in values 
    ? values[key].get!long
    : defaultValue;
}

double getDouble(Json[string] values, string key, double defaultValue = 0.0) {
  return key in values 
    ? values[key].get!double
    : defaultValue;
}

string getString(Json[string] values, string key, string defaultValue = null) {
  return key in values 
    ? values[key].get!string
    : defaultValue;
}
unittest {
  Json[string] values;
  values["a"] = Json("A");
  values["b"] = "B".toJson;
  assert(values.getString("a") == "A");
  assert(values.getString("b") != "A");
  assert(values.getString("b") == "B");
}

Json[] getArray(Json[string] values, string key, Json[] defaultValue = null) {
  return key in values 
    ? values[key].get!(Json[])
    : defaultValue;
}

Json[string] getMap(Json[string] values, string key, Json[string] defaultValue = null) {
  return key in values 
    ? values[key].get!(Json[string])
    : defaultValue;
}

bool isEmpty(Json[string] values, string  key) {
  return (key !in values || values[key].isNull);
}

Json getJson(Json[string] values, string key, Json defaultValue = Json(null)) {
  return key in values 
    ? values[key]
    : defaultValue;
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