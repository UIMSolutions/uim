module uim.core.datatypes.jstring;

import uim.core;

@safe:

Json[string] merge(Json[string] baseData, Json secondData) {
  Json[string] results;

  secondData.byKeyValue
    .each!(kv => results = results.merge(kv.key, kv.value));

  return results;
}

Json[string] merge(Json[string] baseData, string key, Json value) {
  auto results = baseData.dup;

  if (!results.hasKey(key)) results[key] = value;

  return results;
}

Json[string] copy(Json[string] origin) {
  Json[string] result;
  origin.byKeyValue
    .each!(kv => result[kv.key] = kv.value);

  return result;
}

string getString(Json[string] values, string  key) {
  if (!values.hasKey(key)) {
    return null;
  }

  return values[key].to!string;
}