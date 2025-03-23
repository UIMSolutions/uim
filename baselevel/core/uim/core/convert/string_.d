/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.convert.string_;

import uim.core;
@safe:

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// #region toStrings
string[] toStrings(Json json) {
  if (!json.isArray) return null; 
  return json.byValue.array.toStrings;
}

string[] toStrings(Json[] jsons) {
  return jsons.map!(json => json.toString).array;
}
unittest {
  auto json1 = `{"name": "Example1", "id": 1}`.parseJsonString;
  auto json2 = `{"name": "Example2", "id": 2}`.parseJsonString;
  auto json3 = `{"name": "Example3", "id": 3}`.parseJsonString;

  auto jsons = [json1, json2, json3];
  assert(jsons.toStrings == [json1.toString, json2.toString, json3.toString]); 
}

string[] toStrings(UUID[] uuids) {
  return uuids.map!("a.toString").array;
}
unittest {
  auto id1 = randomUUID;
  auto id2 = randomUUID;
  auto id3 = randomUUID;

  auto uuids = [id1, id2, id3];
  assert(uuids.toStrings == [id1.toString, id2.toString, id3.toString]);
}
// #endregion toStrings

// #region toString
string toString(Json json, string[] keys = null) {
  if (!json.isObject) return json.toString; 
  
  if (keys.length == 0) keys = json.keys;
  Json result = Json.emptyObject;
  keys
    .filter!(key => json.hasKey(key))
    .each!(key => result[key] = json[key]);
  return result.toString; 
}

string toString(Json[] jsons) {
  return Json(jsons).toString;
}

string toString(UUID[] uuids) {
  return uuids.map!("a.toString").array.toString;
}

string toString(string[] values) {
  return "\"["~values.map!(value => `\"%s\"`.format(value)).join(",")~"]\"";
}

string toString(string[string] items) {
  Json json = Json.emptyObject;
  items.each!((key, value) => json[key] = value);
  return json.toString;
}

string toString(Json[string] items, string[] keys = null) {
  if (keys.length == 0) keys = items.keys;

  Json json = Json.emptyObject;
  keys
    .filter!(key => items.hasKey(key))
    .each!(key => json[key] = items[key]);
  return json.toString; 
}

/* string toString(T)(T value, size_t length = 0, string fillTxt = "0") {
//    if (isFloatingPoint!T) {
  string result = fill(length, fillTxt);

  import std.conv;

  string convert = to!string(value);
  result = convert.length < length
    ? result[0 .. $ - convert.length] ~ convert : convert;

  return result;
} */

unittest {
  // TODO
  // writeln((1.01).toString);
  //   assert((1.0).toString == "1.0");
  //   assert((1.0).toString == "1.0");
  //   assert((1.0).toString(10, "X") == "XXXXXXX1.0");
}

// #endregion toString

unittest {
/*   auto jsons = [Json(1), Json("x"), Json(true)];
  auto txt = jsons.toString;
  assert(jsons.toStrings == ["1", "\"x\"", "true"]);

  assert(jsons.toJson.toStrings == ["1", "\"x\"", "true"]);

  writeln("UUIDs:", [randomUUID, randomUUID, randomUUID].toStrings);
  writeln("UUIDs:", [randomUUID, randomUUID, randomUUID].toString); */
}