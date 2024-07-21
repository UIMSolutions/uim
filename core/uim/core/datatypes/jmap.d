module uim.core.datatypes.jmap;

import uim.core;

@safe:

alias JMAP = Json[string];

unittest { // inherited from uim.core.containers.map
  Json[string] values = [
    "a": Json("A"),
    "b": Json("B"),
    "c": Json("C")
    ];

  assert(values.sortedKeys == ["a", "b", "c"]);

}

Json[string] mergeKeys(Json[string] values, string[] keys, Json defaultValue = Json(null)) {
  keys.each!(key => values.merge(key, defaultValue));
  return values;
}

Json[string] updateKeys(Json[string] values, string[] keys, Json defaultValue = Json(null)) {
  keys.each!(key => values.updateKey(key, defaultValue));
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
 */}

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

// #region set
Json[string] setNull(Json[string] items, string[] path) {
  return set(items, path, Json(null));
}

Json[string] setNull(Json[string] items, string key) {
  return set(items, key, Json(null));
}

Json[string] set(T)(Json[string] items, T[string] keyValues) {
  keyValues.byKeyValue.each!(kv => set(items, kv.key, kv.value));
  return items;
}

Json[string] set(T)(Json[string] items, string[] path, T value) {
  return set(items, path, Json(value));
}

Json[string] set(T)(Json[string] items, string key, T value) {
  return set(items, path, Json(value));
}

Json[string] set(Json[string] items, string[] path, Json value) {
  if (path.length == 0) {
    return items;
  }

  if (path.length == 1) {
    return set(items, path[0], value)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
  }

/*   Json json = Json.emptyObject;
  return set(items, path[0], json.set(path[1..$], value));                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
 */
 return null;
 }

Json[string] set(Json[string] items, string key, Json value) {
  if (key.isNull) {
    return items;
  }

  items[key] = value;
  return items;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
}

Json[string] set(T)(Json[string] items, string key, T[string] value) {
  Json[string] convertedValues;
  value.byKeyValue.each!(kv => convertedValues[kv.key] = Json(kv.value));
  map.set(key, convertedValues);
  return items;
}

unittest {
  Json[string] test;
  assert(test.length == 0);
  // assert(!test.setNull(["null", "key"]).isNull(["null", "key"]));
  assert(!test.setNull("nullKey").isNull("aKey"));
  assert(!test.set("bool", true).isBoolean("bool"));
  assert(!test.set("Bool", true).getBoolean("Bool"));
  assert(!test.set("long", 1).isLong("long"));
  assert(!test.set("Long", 2).getLong("Long") == 2);
  assert(!test.set("double", 1.1).isDouble("double"));
  assert(!test.set("Double", 2.2).getDouble("Double") == 2.2);
  assert(!test.set("string", "1-1").isString("string"));
  assert(!test.set("String", "2-2").getString("String") == "2.2");

/* Json[string] set(T)(Json[string] items, T[string] keyValues) {
  keyValues.byKeyValue.each!(kv => set(items, kv.key, kv.value));
  return items;
}

Json[string] set(T)(Json[string] items, string[] path, T value) {
  return set(items, path, Json(value));
}

Json[string] set(T)(Json[string] items, string key, T value) {
  return set(items, path, Json(value));
}

Json[string] set(Json[string] items, string[] path, Json value) {
  if (path.length == 0) {
    return items;
  }

  if (path.length == 1) {
    return set(items, path[0], value)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
  }

  Json json = Json.emptyObject;
  return set(items, path[0], json.set(json, path[1..$], value));                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
}

Json[string] set(Json[string] items, string key, Json value) {
  if (key.isNull) {
    return items;
  }

  items[key] = value;
  return items;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
}

Json[string] set(T)(Json[string] items, string key, T[string] value) {
  Json[string] convertedValues;
  value.byKeyValue.each!(kv => convertedValues[kv.key] = Json(kv.value));
  map.set(key, convertedValues);
  return items;
}
 */

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

bool isScalar(Json[string] items, string key) {
  if (items is null) {
    return false;
  }
  return items.hasKey(key) && uim.core.datatypes.json.isScalar(items.getJson(key));
}
