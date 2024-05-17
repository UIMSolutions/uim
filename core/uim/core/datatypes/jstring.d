module uim.core.datatypes.jstring;

import uim.core;

@safe:

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

string getString(Json[string] values, string  key) {
  return key in values 
    ? values[key].to!string
    : null;
}
unittest {
  Json[string] values;
  values["a"] = Json("A");
  values["b"] = "B".toJson;
  assert(values.getString("a") == "A");
  assert(values.getString("b") != "A");
  assert(values.getString("b") == "B");
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