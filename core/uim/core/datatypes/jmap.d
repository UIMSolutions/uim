module uim.core.datatypes.jmap;

import uim.core;
import uim.core.datatypes.json;
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
  if (!uim.core.datatypes.json.isObject(valuesToMerge)) {
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
 */}

bool getBoolean(Json[string] values, string key, bool defaultValue = false) {
  auto json = getJson(values, key);
  return !uim.core.datatypes.json.isNull(json)
    ? json.get!bool : defaultValue;
}

int getInteger(Json[string] values, string key, int defaultValue = 0) {
  auto json = getJson(values, key);
  return !uim.core.datatypes.json.isNull(json)
    ? json.get!int : defaultValue;
}

long getLong(Json[string] values, string key, long defaultValue = 0) {
  auto json = getJson(values, key);
  return !uim.core.datatypes.json.isNull(json)
    ? json.get!long : defaultValue;
}

double getDouble(Json[string] values, string key, double defaultValue = 0.0) {
  auto json = getJson(values, key);
  return !uim.core.datatypes.json.isNull(json)
    ? json.get!double : defaultValue;
}

string getString(Json[string] values, string key, string defaultValue = null) {
  auto json = getJson(values, key);
  return !uim.core.datatypes.json.isNull(json)
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

// #region set
Json[string] setNull(Json[string] items, string[] path) {
  return set(items, path, Json(null));
}

Json[string] setNull(Json[string] items, string key) {
  return set(items, key, Json(null));
}

Json[string] setPath(T)(Json[string] items, string[] path, T value) {
  set(items, path, Json(value));
  return items;
}

Json[string] setPath(Json[string] items, string[] path, Json value) {
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

Json[string] set(T)(Json[string] items, T[string] keyValues) {
  keyValues.byKeyValue.each!(kv => set(items, kv.key, kv.value));
  return items;
}

Json[string] set(T)(Json[string] items, string[] keys, T value) {
  keys.each!(key => set(items, key, value));
  return items;
}

Json[string] set(T)(Json[string] items, string key, T value) {
  set(items, key, Json(value));
  return items;
}

Json[string] set(Json[string] items, string key, Json value) {
  writeln("Json[string] set(Json[string] items, string key, Json value)");
  if (key.length == 0) {
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
  Json[string] testItems;
  assert(testItems.length == 0);
  // assert(!testItems.setNull(["null", "key"]).isNull(["null", "key"]));
  // TODO assert(!testItems.setNull("nullKey").isNull("nullKey"));
  assert(!testItems.set("bool", true).isBoolean("bool"));
  assert(!testItems.set("Bool", true).getBoolean("Bool"));
  assert(!testItems.set("long", 1).isLong("long"));
  // TODO assert(testItems.set("Long", 2).getLong("Long") == 2);
  writeln("XX", testItems);
  writeln("XX", testItems.set("Long", 2));
  writeln("XX", testItems.getLong("Long"));
  assert(!testItems.set("double", 1.1).isDouble("double"));
  assert(testItems.set("Double", 2.2).getDouble("Double") == 2.2);
  assert(!testItems.set("string", "1-1").isString("string"));
  assert(testItems.set("String", "2-2").getString("String") != "2.2");

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

  assert(testItems.set("bool", true).getBoolean("bool"));
  assert(testItems.set("bool", true).getBoolean("bool"));
  assert(testItems.set("long", 1).getLong("long") == 1);
  assert(testItems.set("double", 0.1).getDouble("double") == 0.1);
  assert(testItems.set("string", "A").getString("string") == "A");
  assert(testItems.set("a", "A").set("b", "B").hasAllKeys("a", "b"));
  assert(testItems.set("a", "A").set("b", "B").getString("b") == "B");
  assert(testItems.set("a", "A").set("b", "B").getString("b") != "C");
  // TODO assert(testItems.set("strings", ["x": "X", "y": "Y", "z": "Z"]) != Json(null));
}
// #endregion setter

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
      items.set(key, value);
    }
    return items;
  }

  Json[string] update(Json[string] items, string key, Json value = Json(null)) {
    if (items.hasKey(key)) {
      items.set(key, value);
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
    ? uim.core.datatypes.json.isArray(items[key])
    : false;
}

bool isBigInteger(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isBigInteger(items[key])
    : false;
}

bool isBoolean(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isBoolean(items[key])
    : false;
}

bool isDouble(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isDouble(items[key])
    : false;
}

bool isEmpty(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isEmpty(items[key])
    : false;
}

bool isFloat(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isFloat(items[key])
    : false;
}

bool isInteger(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isInteger(items[key])
    : false;
}

bool isIntegral(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isIntegral(items[key])
    : false;
}

bool isLong(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isLong(items[key])
    : false;
}

bool isNull(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isNull(items[key])
    : false;
}

bool isObject(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isObject(items[key])
    : false;
}

bool isScalar(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isScalar(items[key])
    : false;
}

bool isString(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isString(items[key])
    : false;
}

bool isUndefined(Json[string] items, string key) {
  return items.hasKey(key)
    ? uim.core.datatypes.json.isUndefined(items[key])
    : false;
}

unittest {
  Json[string] items;
  items
    .set("a", "A");

  assert(items.isString("a"));
}
// #endregion is