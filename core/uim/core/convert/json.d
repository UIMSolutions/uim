module uim.core.convert.json;

import uim.core;
@safe:

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// #region toJson
Json toJson(bool value) {
  return Json(value);
}

Json toJson(long value) {
  return Json(value);
}

Json toJson(double value) {
  return Json(value);
}

Json toJson(string value) {
  return Json(value);
}

Json toJson(Json value) {
  return value;
}

Json toJson(T)(T[] values) {
  Json json = Json.emptyArray;
  values.each!(value => json ~= value.toJson);
  return json;
}

Json toJson(string aKey, string aValue) {
  Json result = Json.emptyObject;
  result[aKey] = aValue;
  return result;
}

unittest {
  assert(toJson("a", "3")["a"] == "3");
}

// #region UUID 
Json toJson(UUID value) {
  return toJson(value.toString);
}
Json toJson(string aKey, UUID uuid) {
  Json result = Json.emptyObject;
  result[aKey] = uuid.toJson;
  return result;
}
Json toJson(UUID[] uuids) {
  Json result = Json.emptyArray;
  uuids.each!(uuid => result ~= uuid.toJson);
  return result;
}
unittest {
  auto id = randomUUID;
  auto id2 = randomUUID;
  auto id3 = randomUUID;
  auto id4 = randomUUID;
  
  assert(id.toJson.get!string == id.toString);
  assert([id, id2, id3].toJson.has(id));
  assert(![id, id2, id3].toJson.has(id4));

  assert([id, id2, id3].toJson.hasAll(id, id2, id3));
  // assert(id.toJson.get!string == id.toString);

  // assert(UUID(toJson("id", id)["id"].get!string) == id); */
}
// #endregion UUID

/// Special case for managing entities
Json toJson(UUID id, size_t versionNumber) {
  Json result = toJson("id", id);
  result["versionNumber"] = versionNumber;
  return result;
}

unittest {
  auto id = randomUUID;
  assert(toJson(id, 0).getString("id") == id.toString);
  assert("versionNumber" in toJson(id, 0));
  assert(toJson(id, 1)["id"].get!string == id.toString);
  assert(toJson(id, 1)["versionNumber"].get!size_t == 1);
}

Json toJson(bool[] values) {
  auto json = Json.emptyArray;
  values.each!(value => json ~= value);
  return json;
}

unittest {
  assert([true, true, false].toJson.length == 3);
  assert([true, true, false].toJson[0].getBoolean);
}

Json toJson(string[] values) {
  auto json = Json.emptyArray;
  values.each!(value => json ~= value);
  return json;
}

unittest {
  assert(["a", "b", "c"].toJson.length == 3);
  assert(["a", "b", "c"].toJson[0] == "a");
}

Json toJson(string[string] map, string[] excludeKeys = null) {
  Json json = Json.emptyObject;
  map.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => key == kv.key))
    .each!(kv => json[kv.key] = kv.value);
  return json;
}

unittest {
  assert(["a": "1", "b": "2", "c": "3"].toJson.length == 3);
  assert(["a": "1", "b": "2", "c": "3"].toJson["a"] == "1");
}
// #endregion toJson
