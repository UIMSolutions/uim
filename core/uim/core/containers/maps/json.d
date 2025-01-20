/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.containers.maps.json;

import uim.core;
import uim.core.datatypes.json;

@safe:

alias JMAP = Json[string];

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
// #inherited -> Json[string] merge(Json[string] items, Json[string] valuesToMerge) {

/* Json[string] merge(Json[string] items, Json valuesToMerge) {
  if (!uim.core.datatypes.json.isObject(valuesToMerge)) {
    return items;
  }

  valuesToMerge.byKeyValue
    .each!(kv => items.merge(kv.key, kv.value));

  return items;
} */

/* Json[string] merge(Json[string] items, string[] keys, Json value) {
  keys.each!(key => items.merge(key, value));
  return items;
}
Json[string] merge(Json[string] items, string key, Json value) {
  if (items.hasKey(key)) {
    items = items.set(key, value);
  }
  return items;
} */ 

V[K] merge(K:string, V:Json)(Json[string] items, string[] keys, Json value) {
  keys.each!(key => items = items.merge(key, value));
  return items;
}

V[K] merge(K:string, V:Json)(Json[string] items, string key, V value) {
  if (key !in items) {
    items[key] = value;
  }
  return items;
}

Json[string] merge(Json[string] items, string[] keys, bool value) {
  return items.merge(keys, Json(value));
}
Json[string] merge(Json[string] items, string key, bool value) {
  return items.merge(key, Json(value));
}
unittest {
  Json[string] testMap;
  assert(testMap.length == 0);
  
  testMap.merge("one", true);
  assert(testMap.length == 1);
  
  testMap.merge("two", false);
  assert(testMap.length == 2);
  
  assert(testMap.getBoolean("one"));
  assert(!testMap.getBoolean("two"));

  testMap.clear;
  assert(testMap.length == 0);
  
  assert(testMap.merge(["a", "b"], true).length == 2);
  assert(testMap.merge(["c", "d"], false).length == 4);
  assert(testMap.merge(["c", "d"], false).length == 4);
  assert(testMap.getBoolean("a"));
  assert(!testMap.getBoolean("c"));
}

Json[string] merge(Json[string] items, string[] keys, string value) {
  return merge(items, keys, Json(value));
}
Json[string] merge(Json[string] items, string key, string value) {
  return merge(items, key, Json(value));
}
unittest {
  Json[string] testMap;
  assert(testMap.length == 0);
  
  assert(testMap.merge("one", "true").length == 1);
  assert(testMap.merge("two", "false").length == 2);
  assert(testMap.getString("one") == "true");
  assert(testMap.getString("two") == "false");

  testMap.clear;
  assert(testMap.length == 0);
  assert(testMap.merge(["a", "b"], "true").length == 2);
  assert(testMap.merge(["c", "d"], "false").length == 4);
  assert(testMap.getString("a") == "true");
  assert(testMap.getString("c") == "false");
}

Json[string] merge(Json[string] items, string[] keys, long value) {
  return merge(items, keys, Json(value));
}
Json[string] merge(Json[string] items, string key, long value) {
  return merge(items, key, Json(value));
}
unittest {
  writeln("merge long");
  Json[string] testMap;
  assert(testMap.length == 0);
  
  assert(testMap.merge("one", 1).length == 1);
  assert(testMap.merge("two", 2).length == 2);
/*   assert(testMap.getLong("one") == 1);
  assert(testMap.getLong("two") == 2); */

  testMap.clear;
  assert(testMap.length == 0);
  assert(testMap.merge(["a", "b"], 1).length == 2);
  assert(testMap.merge(["c", "d"], 2).length == 4);
/*   assert(testMap.getLong("a") == 1);
  assert(testMap.getLong("c") == 2); */

  testMap.clear;
  assert(testMap.length == 0);
  // assert(testMap.merge("a", 1).merge("b", 1).merge(["c", "d"], 2).length == 4);
}

Json[string] merge(Json[string] items, string[] keys, double value) {
  return merge(items, keys, Json(value));
}
Json[string] merge(Json[string] items, string key, double value) {
  return merge(items, key, Json(value));
}
unittest {
  writeln("merge double");
  Json[string] testMap;
  assert(testMap.length == 0);
  assert(testMap.merge("one", 1.1).length == 1);
  assert(testMap.merge("two", 2.2).length == 2);
  assert(testMap.getDouble("one") == 1.1);
  assert(testMap.getDouble("two") == 2.2);

  testMap.clear;
  assert(testMap.length == 0);
  assert(testMap.merge(["a", "b"], 1.1).length == 2);
  assert(testMap.merge(["c", "d"], 2.2).length == 4);
  assert(testMap.getDouble("a") == 1.1);
  assert(testMap.getDouble("c") == 2.2);
}

/* Json[string] merge(Json[string] items, string key, Json value) {
  return key !in items
    ? items.set(key, value)
    : items;
}  */

unittest {
  Json[string] testMap;
  assert(testMap.length == 0);
  assert(testMap.merge("a", "A").length == 1);
  // writeln("testmap: ", testMap.merge("one", 1));
  // writeln("testmap: ", testMap /* .merge("one", 1) */ .merge("double", 2.2));
  /// assert(testMap.merge("one", 1).merge("double", 2.2).length == 3);
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
      return keys.length > 1 && !uim.core.datatypes.json.isNull(json)
        ? uim.core.datatypes.json.getJson(json, keys[1 .. $].join(".")) : json;
    }
  }
  return Json(null);
}

unittest {
  /*   Json[string] Json[string];
  Json[string]["a"] = Json("a");
  Json[string]["b"] = Json("b");
  Json[string]["a.b"] = Json("a.b");
 */
  auto jObj = Json.emptyObject;
  jObj["c"] = "c";
  jObj["d"] = "d";
  jObj["c.d"] = "c.d";
  jObj["x"] = jObj;

  /*   Json[string]["z"] = jObj;

  assert(Json[string].getString("a") == "a");
  assert(Json[string].getString("b") != "a");
  assert(Json[string].getString("a.b") == "a.b");
  assert(Json[string].getString("z.c") == "c");
  assert(Json[string].getString("z.d") != "c");
  assert(Json[string].getString("z.c.d") == "c.d");
  assert(Json[string].getString("z.x.c") == "c");
  assert(Json[string].getString("z.x.d") != "c");
  assert(Json[string].getString("z.x.c.d") == "c.d");
  writeln("z.x.c.d = ", Json[string].getString("z.x.c.d"));
 */
}

bool getBoolean(Json[string] values, string key, bool defaultValue = false) {
  auto json = getJson(values, key);
  return !uim.core.datatypes.json.isNull(json)
    ? json.get!bool : defaultValue;
}
unittest {
  Json[string] values;
  values["a"] = true;
  values["b"] = Json(false);
  assert(values.getBoolean("a"));
  assert(!values.getBoolean("b"));
}

int getInteger(Json[string] values, string key, int defaultValue = 0) {
  auto json = getJson(values, key);
  return !uim.core.datatypes.json.isNull(json)
    ? json.get!int : defaultValue;
}
unittest {
  Json[string] values;
  values["a"] = 0;
  values["b"] = Json(1);
  assert(values.getInteger("a") == 0);
  assert(values.getInteger("b") == 1);
}

long getLong(Json[string] values, string key, long defaultValue = 0) {
  auto json = getJson(values, key);
  return !uim.core.datatypes.json.isNull(json)
    ? json.get!long : defaultValue;
}
unittest {
  Json[string] values;
  values["a"] = 0;
  values["b"] = Json(1);
  assert(values.getLong("a") == 0);
  assert(values.getLong("b") == 1);
}

double getDouble(Json[string] values, string key, double defaultValue = 0.0) {
  auto json = getJson(values, key);
  return !uim.core.datatypes.json.isNull(json)
    ? json.get!double : defaultValue;
}
unittest {
  Json[string] values;
  values["a"] = 1.1;
  values["b"] = Json(2.2);
  assert(values.getDouble("a") == 1.1);
  assert(values.getDouble("b") == 2.2);
}

string getString(Json[string] values, string key, string defaultValue = null) {
  auto json = getJson(values, key);
  return !uim.core.datatypes.json.isNull(json)
    ? json.get!string : defaultValue;
}
unittest {
  Json[string] values;
  values["a"] = Json("A");
  values["b"] = "B";
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

  Json testArray = Json.emptyArray;
  testArray ~= "A";
  testArray ~= "B";

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
  return !uim.core.datatypes.json.isNull(json)
    ? json.get!(Json[]) : defaultValue;
}

Json[string] getMap(Json[string] values, string key, Json[string] defaultValue = null) {
  auto json = getJson(values, key);
  return !uim.core.datatypes.json.isNull(json) && uim.core.datatypes.json.isObject(json)
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

// #region update
// TODO
/*   Json[string] update(Json[string] items, string[] keys, Json defaultValue = Json(null)) {
    keys.each!(key => items.update(key, defaultValue));
    return items;
  } */

Json[string] update(Json[string] items, Json[string] updateItems) {
  updateItems.byKeyValue.each!(item => items.update(item.key, item.value));
  return items;
}

Json[string] update(Json[string] items, string[] keys, Json defaultValue = Json(null)) {
  keys.each!(key => items.update(key, defaultValue));
  return items;
}

Json[string] update(T)(Json[string] items, string key, T value) {
  if (items.hasKey(key)) {
    items = items.set(key, value);
  }
  return items;
}

Json[string] update(Json[string] items, string key, Json value = Json(null)) {
  if (items.hasKey(key)) {
    items = set(items, key, value);
  }
  return items;
}

unittest {
  Json[string] items = [
    "a": Json("A"),
    "one": Json(1),
    "pi": Json(3.14),
    "bool": Json(true)
  ];
  assert(items.length == 4);
  assert(items.getString("a") == "A");
  assert(items.update("a", "B").getString("a") == "B");
}
// #endregion update

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

Json[string] toJsonMap(string[string] items, string[] excludeKeys = null) {
  Json[string] result;
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

// #region is
bool isArray(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isArray(items[key]) : false;
}

bool isBigInteger(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isBigInteger(items[key]) : false;
}

bool isBoolean(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isBoolean(items[key]) : false;
}

bool isDouble(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isDouble(items[key]) : false;
}

bool isEmpty(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isEmpty(items[key]) : false;
}

bool isFloat(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isFloat(items[key]) : false;
}

bool isInteger(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isInteger(items[key]) : false;
}

bool isIntegral(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isIntegral(items[key]) : false;
}

bool isLong(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isLong(items[key]) : false;
}

bool isNull(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isNull(items[key]) : false;
}

bool isObject(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isObject(items[key]) : false;
}

bool isScalar(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isScalar(items[key]) : false;
}

bool isString(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isString(items[key]) : false;
  return false;
}

bool isUndefined(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isUndefined(items[key]) : false;
}

unittest {
  Json[string] items;
  items = items
    .set("a", "A");

  writeln("isString => ", items.value("a"));
  assert(items.isString("a"));
}
// #endregion is

unittest {
  // writeln("--- JMap all");

  /* writeln(Map.create!(string, Json).set("x", "X"));
  writeln(Map.create!(string, Json).set("x", "X").set("x", "X"));
  writeln(Map.create!(string, Json).set("x", "X").set("y", "Y"));
  writeln(Map.create!(string, Json).set("bool", true));
  writeln(Map.create!(string, Json).set("bool", true).set("x", "X"));

  writeln(Map.create!(string, Json).set("x", Json("X")));
  writeln(Map.create!(string, Json).set("x", Json("X")).set("x", Json("X")));
  writeln(Map.create!(string, Json).set("x", Json("X")).set("y", "Y"));
  writeln(Map.create!(string, Json).set("bool", Json(true)));
  writeln(Map.create!(string, Json).set("bool", Json(true)).set("x", Json("X")));

  auto testMap = Map.create!(string, Json).set("x", "X");
  writeln(testMap.set("x", "X"));
  writeln(testMap.set("x", "X").set("x", "X"));
  writeln(testMap.set("x", "X").set("y", "Y"));
  writeln(testMap);
  writeln(testMap.set("bool", true));
  writeln(testMap.set("long", 1).set("x", "X"));
  writeln(testMap.set("double", 1.1).set("y", "Y"));
  writeln(testMap);
  writeln(testMap.update("bool", false).update("long", 2).update("double", 2.1));
  writeln(testMap);
  writeln(testMap.merge("boolx", false).merge("longx", 2).merge("doublex", 2.1));
  writeln(testMap); */
}

/* Json[string] createMap(string, Json)(Json[string] init = null) {
  Json[string] created = init;
  return created;
} */

string toString(Json[string] items, string[] keys = null) {
  return keys is null
    ? "[" ~ items.byKeyValue.map!(item => `"%s":%s`.format(item.key, item.value)).join(
      ",") ~ "]" : "[" ~ items.byKeyValue
    .filter!(item => keys.has(item.key))
    .map!(item => `"%s":%s`.format(item.key, item.value))
    .join(",") ~ "]";
}

unittest {
  Json[string] testItems;
  testItems = testItems
    .set("bool", true)
    .set("long", 1)
    .set("double", 1.1)
    .set("string", "1-1")
    .set("json", Json("abc"));

  writeln("toString -> ", testItems);
  writeln("toString -> ", testItems.toString);
  writeln("toString -> ", testItems.toString(["long", "string"]));
}

STRINGAA toStringMap(Json[string] map) {
  STRINGAA stringMap;
  map.byKeyValue
    .each!(kv => stringMap[kv.key] = kv.value.to!string);
  return stringMap;
}
