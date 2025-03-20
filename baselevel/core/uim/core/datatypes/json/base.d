/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.datatypes.json.base;

import uim.core;

@safe:

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// #region Null
V Null(V : Json)() {
  return Json(null);
}

unittest {
  assert(Null!Json == Json(null));
  assert(Null!Json.isNull);
}
// #endregion Null



// #region is
bool isMap(Json json) {
  return json.type == Json.Type.object;
}

// #region isObject
bool isObject(Json json) {
  return json.type == Json.Type.object;
}

unittest {
  assert(parseJsonString(`{"a": "b"}`).isObject);
  assert(!parseJsonString(`["a", "b", "c"]`).isObject);

  Json json = Json.emptyObject;
  json["a"] = "A";
  json["one"] = 1;
  assert(json.isObject);
}
// #endregion isObject

// #region isArray
bool isArray(Json json) {  
  return json != Json(null)
    ? (json.type == Json.Type.array)
    : false;
}

unittest {
  assert(parseJsonString(`["a", "b", "c"]`).isArray);
  assert(!parseJsonString(`{"a": "b"}`).isArray);

  Json json = Json.emptyArray;
  json ~= Json("A");
  json ~= Json(1);
  assert(json.isArray);
}
// #endregion isArray

// #region isBigInteger
bool isBigInteger(Json json) {
  return (json.type == Json.Type.bigInt);
}

unittest {
  assert(parseJsonString(`1000000000000000000000`).isBigInteger);
  assert(!parseJsonString(`1`).isBigInteger);
}
// #endregion isBigInteger

// #region isBoolean
bool isBooleanLike(Json value) {
  if (value.isString) {
    return uim.core.datatypes.string_.isBoolean(value.getString);
  }
  if (value.isLong || value.isInteger) {
    return true; // 0 - false; >0 - true   
  }
  return value.isBoolean;
}

bool isAllBoolean(Json[] values) {
  return values.all!(value => value.isBoolean);
}

bool isAllBoolean(Json value) {
  return value.isAllBoolean(value.keys);
}

bool isAllBoolean(Json value, string[] keys...) {
  return value.isAllBoolean(keys.dup);
}

bool isAllBoolean(Json value, string[] keys) {
  return keys.all!(key => value.isBoolean(key)); 
}

bool isAnyBoolean(Json[] values) {
  return values.any!(value => value.isBoolean);
}

bool isAnyBoolean(Json value) {
  if (value.isObject)
    return value.isAnyBoolean(value.keys); 

  if (value.isArray)
    return value.get!(Json[]).isAnyBoolean; 

  return bvalue;
}

bool isAnyBoolean(Json value, string[] keys...) {
  return value.isAnyBoolean(keys.dup); 
}

bool isAnyBoolean(Json value, string[] keys) {
  return keys.any!(key => value.isBoolean(key)); 
}

bool isBoolean(Json value, string key) {
  return value.hasKey(key) 
    ? value[key].isBoolean 
    : false;
}

bool isBoolean(Json value) {
  return (value.type == Json.Type.bool_);
}
///
unittest {
  assert(Json(true).isBoolean);
  assert(!Json("text").isBoolean);
  assert(!Json(10).isBoolean);
  assert(!Json(1.1).isBoolean);

  Json map = Json.emptyObject;
  map["one"] = Json(1);  
  map["alfa"] = Json("text");
  map["t"] = Json(true);  
  map["f"] = Json(false);
  assert(!map.isBoolean);  
  assert(!map.isBoolean("one"));  
  assert(!map.isBoolean("alfa"));  
  assert(map.isBoolean("t"));  
  assert(map.isBoolean("f"));  

  assert(map.isAnyBoolean("one", "t"));  
  assert(map.isAnyBoolean("f", "t"));  
  assert(!map.isAnyBoolean("one", "alfa"));  

  assert(map.isAllBoolean("f", "t"));
  assert(!map.isAllBoolean("f", "alfa"));  
  assert(!map.isAllBoolean("one", "alfa"));  

  map = Json.emptyObject;
  map["t"] = Json(true);  
  map["f"] = Json(false);
  assert(map.isAllBoolean);
}
// #endregion isBoolean

// #region isFloat
bool isAllFloat(Json value) {
  return (value.type == Json.Type.float_);
}

bool isFloat(Json value) {
  return (value.type == Json.Type.float_);
}

unittest {
  assert(!Json(true).isFloat);  
  assert(!Json(10).isFloat);  
  assert(Json(1.1).isFloat);  
  assert(!Json("text").isFloat);
}
// #endregion isFloat

// #region isDouble
bool isDouble(Json value, string key) {
  return value.hasKey(key) 
    ? value[key].isDouble 
    : false;
}

bool isDouble(Json value) {
  return (value.type == Json.Type.float_);
}

unittest {
  writeln("bool isDouble(Json value)");
  assert(!Json(true).isDouble);  
  assert(!Json(10).isDouble);  
  assert(Json(1.1).isDouble);  
  assert(!Json("text").isDouble);
}
// #endregion isDouble

// #region isInteger
bool isInteger(Json value, string key) {
  return value.hasKey(key) 
    ? value[key].isInteger 
    : false;
}

bool isInteger(Json value) {
  return (value.type == Json.Type.int_);
}

unittest {
  assert(!Json(true).isInteger);  
  assert(Json(10).isInteger);  
  assert(!Json(1.1).isInteger);  
  assert(!Json("text").isInteger);
}
// #endregion isInteger

// #region isLong
bool isLong(Json value) {
  return (value.type == Json.Type.int_);
}
unittest {
  writeln("bool isLong(Json value)");
  assert(!Json(true).isLong);  
  assert(Json(10).isLong);  
  assert(!Json(1.1).isLong);  
  assert(!Json("text").isLong);
}
// #endregion isLong

// #region isNull
// Check if json value is null
bool isNull(Json value) {
  return (value.type == Json.Type.null_);
}

mixin(CheckJsonIs!("Null"));

bool isNull(Json value, string[] path) {
  if (uim.core.containers.arrays.array_.isEmpty(path)) {
    return true;
  }

  auto firstKey = path[0];
  if (value.isNull(firstKey)) {
    return true;
  }

  return path.length > 1
    ? isNull(value[firstKey], path.removeFirst) : false;
}

bool isNull(Json value, string key) {
  return value.isObject && value.hasKey(key) 
    ? value[key].isNull
    : true;
}

unittest {
  assert(Json(null).isNull);
  assert(!Json.emptyObject.isNull);
  assert(!Json.emptyArray.isNull);

  auto json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": "h"}]}`);
  assert(json.isNull("x"));
  assert(!json.isNull("a"));

  assert(json.isNull(["x"]));
  assert(!json.isNull(["a"]));
  assert(json.isNull(["c", "x"]));
  assert(!json.isNull(["c", "d"]));
  assert(json.isNull(["c", "d", "x"]));

  assert(json.allNull(["x", "y"]));
  assert(!json.allNull(["a", "y"]));
  assert(json.anyNull(["x", "y"]));
  assert(!json.anyNull(["a", "c"]));
}
// #endregion isNull

// #region isString
bool isString(Json value) {
  return (value.type == Json.Type.string);
}

mixin(CheckJsonIs!("String"));

bool isString(Json value, string[] path) {
  if (value.isNull(path)) {
    return false;
  }

  auto firstKey = path[0];
  if (value.isString(firstKey)) {
    return true;
  }

  return path.length > 1
    ? isString(value[firstKey], path.removeFirst) : false;
}

bool isString(Json value, string key) {
  return value.isObject && value.hasKey(key) 
    ? value[key].isString
    : true;
}

unittest {
  assert(parseJsonString(`"a"`).isString);
  assert(!parseJsonString(`1.1`).isString);

  auto json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": 1.1}], "i": {"j": "x"}}`);
  assert(json.isString("a"));
  assert(!json.isString("c"));
  assert(json.isString(["i", "j"]));
  assert(!json.isString(["e", "g"]));
}
// #endregion isString

bool isUndefined(Json value) {
  return (value.type == Json.Type.undefined);
}

unittest {
  // TODO running test assert(parseJsonString(`#12abc`).isUndefined);
  assert(!parseJsonString(`1.1`).isUndefined);
}

// #region isEmpty
bool isEmpty(Json value) {
  if (value.isNull) {
    return true;
  }

  if (value.isString) {
    return value.getString.length == 0;
  }

  return false;
  // TODO add not null, but empty
}
// #endregion isEmpty

// #region isIntegral
bool isIntegral(Json value) {
  return value.isLong;
}
// #endregion isIntegral
// #endregion is

/// Check if jsonPath exists
bool hasPath(Json json, string path, string separator = "/") {
  if (!json.isObject) {
    return false;
  }

  auto pathItems = path.split(separator);
  return hasPath(json, pathItems);
}

bool hasPath(Json value, string[] path) {
  if (!value.isObject || path.length == 0) {
    return false;
  }

  auto firstKey = path.shift;
  if (!value.hasKey(firstKey)) {
    return false;
  }

  return path.length > 0
    ? value[firstKey].hasPath(path) : true;
}
///
unittest {
  auto json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": "h"}]}`);
  assert(json.hasPath(["c", "d"]));
}

/* /// Check if jsonPath items exists
bool hasPath(Json json, string[] pathItems) {
  // In Check
  if (!json.isObject) {
    return false;
  }

  // Body
  auto j = json;
  foreach (pathItem; pathItems) {
    if (pathItem in j) {
      if (pathItems.length > 1) {
        return hasPath(j[pathItem], pathItems[1 .. $]);
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
  return true;
} */
///
unittest {
  auto json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": "h"}]}`);
  assert(json.hasPath(["c", "d"]));
}

/// Reduce Json Object to keys (remove others)
Json reduceKeys(Json json, string[] keys) {
  if (json.isObject) {
    Json result = Json.emptyObject;
    keys
      .filter!(key => json.hasKey(key))
      .each!(key => result[key] = json[key]);

    return result;
  }
  return Json(null); // Not object or keys
}

unittest {
  writeln("test uim_core");
  // TODO 
}

/// Remove keys from Json Object
Json remove(Json json, string[] delKeys...) {
  return remove(json, delKeys.dup);
}

Json remove(Json json, string[] delKeys) {
  auto result = json;
  delKeys.each!(k => result.remove(k));
  return result;
}
///
unittest {
  auto json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": "h"}]}`);
  assert(json.hasValue(Json("b")));
  assert(json.hasValue(Json("h"), true));
}

/// Remove key from Json Object
Json remove(Json json, string aKey) {
  if (!json.isObject) {
    return json;
  }

  Json result = Json.emptyObject;
  json
    .byKeyValue
    .filter!(kv => kv.key != aKey)
    .each!(kv => result[kv.key] = kv.value);

  return result;
}

unittest {
  auto json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": "h"}]}`);
  assert(json.hasKey("a"));
  json.remove("a");
  assert(!json.hasKey("a"));

  json = parseJsonString(`{"a": "b", "c": {"d": 1}, "e": ["f", {"g": "h"}]}`);
  assert(!json.hasKey("x"));
  json.remove("x");
  assert(!json.hasKey("x"));
  json.remove("x");
  assert(json.hasKey("a"));
}

Json readJson(Json target, Json source, bool shouldOverwrite = true) {
  if (!target.isObject || !source.isObject) {
    return target;
  }

  auto result = target;
  source.byKeyValue.each!((kv) {
    if (shouldOverwrite) {
      result[kv.key] = kv.value;
    } else {
      if (!result.hasKey(kv.key)) {
        result[kv.key] = kv.value;
      }
    }
  });

  return result;
}

/// Load existing json files in directories
Json[] loadJsonsFromDirectories(string[] dirNames) {
  return dirNames
    .filter!(dir => dir.exists) // string[]
    .map!(dir => loadJsonsFromDirectory(dir)) // Json[][]
    .array // Json[][]
    .join;
}

unittest {
  /// TODO Add Tests
}

/// Load existing json file in directories
Json[] loadJsonsFromDirectory(string dirName) {
  // debug writeln("In loadJsonsFromDirectory("~dirName~")");
  // debug writeln("Found ", fileNames(dirName).length, " files");
  // TODO return loadJsons(fileNames(dirName, true));
  return null;
}

unittest {
  /// TODO Add Tests
}

Json[] loadJsons(string[] fileNames) {
  // debug writeln("Found ", fileNames.length, " names -> ", fileNames);
  return fileNames.map!(a => loadJson(a))
    .filter!(a => a != Json(null))
    .array;
}

unittest {
  /// TODO(John) Add Tests
}

Json loadJson(string name) {
  // debug writeln("In loadJson("~name~")");
  // debug writeln(name, " exists? ", name.exists);
  return name.exists ? parseJsonString(readText(name)) : Json(null);
}

unittest {
  /// TODO Add Tests
}

T minValue(T)(Json[] jsons, string key) {
  T result;
  foreach (j; jsons) { // find first value
    if (key !in j)
      continue;

    T value = j[key].get!T;
    result = value;
    break;
  } // found value

  jsons
    .filter!(json => key in json)
    .each!((json) {
      T value = json[key].get!T;
      if (value < result)
        result = value;
    });
  return result;
}

unittest {
  /*   assert(minValue!string(
      [
      ["a": "5"],
      ["a": "2"],
      ["a": "1"],
      ["a": "4"]
    ], "a") == "1"); */
}

T maxValue(T)(Json[] jsons, string key) {
  T result;
  foreach (json; jsons) { // find first value
    if (!json.hasKey(key)) {
      continue;
    }

    result = json[key].get!T;
    break;
  } // found value

  foreach (json; jsons) { // compare values
    if (!json.hasKey(key)) {
      continue;
    }

    T value = json[key].get!T;
    if (value > result)
      result = value;
  }
  return result;
}

unittest {
  /*     assert(maxValue!string(
        [
        ["a": "5"],
        ["a": "2"],
        ["a": "1"],
        ["a": "4"]
      ], "a") == "5");
 */
}

Json firstWithKey(Json[] jsons, string key) {
  Json[] results = jsons.filter!(json => json.hasKey(key)).array;
  return results.length > 0
    ? results[0] : Json(null);
}

unittest {
/*   Json[] jsons;
  auto json = Json.emptyObject;
  jsons ~= json
    .set("a", 1)
    .set("b", 1);
  json = Json.emptyObject;
  jsons ~= json
    .set("a", 2)
    .set("b", 2);
  json = Json.emptyObject;
  jsons ~= json
    .set("a", 3)
    .set("b", 4);
  assert(jsons.firstWithKey("a").getLong("a") == 1);
  assert(jsons.firstWithKey("x") == Json(null)); */
}

Json mergeJsonObject(Json baseJson, Json mergeJson) {
  Json result;

  if (mergeJson.isEmpty || mergeJson.type != Json.Type.object) {
    return baseJson;
  }

  // TODO not finished
  return result;
}

// #region merge
/// Merge jsons objects to one
Json mergeJsons(Json[] jsons...) {
  return mergeJsons(jsons.dup, true);
}
/// Merge jsons objects in array to one
Json mergeJsons(Json[] jsons, bool shouldOverwrite = true) {
  Json result = Json.emptyObject;

  jsons
    .filter!(json => json.isObject)
    .each!(json => result = result.mergeJsonObjects(json, shouldOverwrite));

  return result;
}
///
/* unittest {
  auto json0 = parseJsonString(`{"a": "b", "c": {"d": 1}}`);
  auto json1 = parseJsonString(`{"e": ["f", {"g": "h"}]}`);
  auto mergeJson = mergeJsons(json0, json1);
  assert(mergeJson.hasKey("a") && mergeJson.hasKey("e"), mergeJson.toString);
} */

Json mergeJsonObjects(Json baseJson, Json mergeJson, bool shouldOverwrite = true) {
  Json result = Json.emptyObject;
  if (baseJson.isNull && !baseJson.isObject) {
    return result;
  }
  result = result.readJson(baseJson, shouldOverwrite);

  if (mergeJson.isNull && !mergeJson.isObject) {
    return result;
  }
  result = result.readJson(mergeJson, shouldOverwrite);

  // Out
  return result;
}

///
unittest {
  auto json0 = parseJsonString(`{"a": "b", "c": {"d": 1}}`);
  auto json1 = parseJsonString(`{"e": ["f", {"g": "h"}]}`);
  auto mergeJson = mergeJsonObjects(json0, json1);
  assert(mergeJson.hasKey("a") && mergeJson.hasKey("e"), mergeJson.toString);
}
// #endregion merge

Json jsonWithMinVersion(Json[] jsons...) {
  return jsonWithMinVersion(jsons.dup);
}

Json jsonWithMinVersion(Json[] jsons) {
  if (jsons.length == 0) {
    return Json(null);
  }

  Json minJson = jsons[0];

  if (jsons.length > 1) {
    jsons[1 .. $]
      .filter!(json => json.isObject && "versionNumber" in json) // Object with versionNumber
      .each!(json => minJson = json["versionNumber"].get!size_t < minJson["versionNumber"].get!size_t
          ? json : minJson);
  }

  return minJson;
}
///
unittest {
  auto json1 = parseJsonString(`{"versionNumber": 1}`);
  auto json2 = parseJsonString(`{"versionNumber": 2}`);

  auto json3 = parseJsonString(`{"versionNumber": 3}`);

  assert(jsonWithMinVersion(json1, json2)["versionNumber"].get!size_t == 1);
  assert(jsonWithMinVersion([json1, json2])["versionNumber"].get!size_t == 1);

  assert(jsonWithMinVersion(json1, json3, json2)["versionNumber"].get!size_t == 1);
  assert(jsonWithMinVersion([json1, json3, json2])["versionNumber"].get!size_t == 1);

  assert(jsonWithMinVersion(json3, json3, json2)["versionNumber"].get!size_t == 2);
  assert(jsonWithMinVersion([json3, json3, json2])["versionNumber"].get!size_t == 2);
}

Json jsonWithMaxVersion(Json[] jsons...) {
  return jsonWithMaxVersion(jsons.dup);
}

Json jsonWithMaxVersion(Json[] jsons) {
  if (jsons.length == 0) {
    return Json(null);
  }

  auto result = jsons[0];

  if (jsons.length > 1) {
    jsons[1 .. $]
      .filter!(json => json.isObject && "versionNumber" in json)
      .each!(json => result = json["versionNumber"].get!size_t > result["versionNumber"].get!size_t ? json
          : result);
  }

  return result;
}
///
unittest {
  auto json1 = parseJsonString(`{"versionNumber": 1}`);
  auto json2 = parseJsonString(`{"versionNumber": 2}`);

  auto json3 = parseJsonString(`{"versionNumber": 3}`);

  assert(jsonWithMaxVersion(json1, json2)["versionNumber"].get!size_t == 2);
  assert(jsonWithMaxVersion([json1, json2])["versionNumber"].get!size_t == 2);

  assert(jsonWithMaxVersion(json1, json3, json2)["versionNumber"].get!size_t == 3);
  assert(jsonWithMaxVersion([json1, json3, json2])["versionNumber"].get!size_t == 3);

  assert(jsonWithMaxVersion(json3, json3, json2)["versionNumber"].get!size_t == 3);
  assert(jsonWithMaxVersion([json3, json3, json2])["versionNumber"].get!size_t == 3);
}

size_t maxVersionNumber(Json[] jsons...) {
  return maxVersionNumber(jsons.dup);
}

size_t maxVersionNumber(Json[] jsons) {
  if (jsons.length == 0) {
    return 0;
  }

  size_t result = 0;

  jsons
    .filter!(json => json.isObject && "versionNumber" in json)
    .each!(json => result = json["versionNumber"].get!size_t > result ? json["versionNumber"].get!size_t
        : result);

  return result;
}
///
unittest {
  auto json1 = parseJsonString(`{"versionNumber": 1}`);
  auto json2 = parseJsonString(`{"versionNumber": 2}`);
  auto json3 = parseJsonString(`{"versionNumber": 3}`);

  assert(maxVersionNumber(json1, json2) == 2);
  assert(maxVersionNumber([json1, json2]) == 2);

  assert(maxVersionNumber(json1, json3, json2) == 3);
  assert(maxVersionNumber([json1, json3, json2]) == 3);

  assert(maxVersionNumber(json3, json3, json2) == 3);
  assert(maxVersionNumber([json3, json3, json2]) == 3);
}

string[] toStringArray(Json value) {
  if (value.isNull) {
    return null;
  }

  return value.toArray.map!(json => json.to!string).array;
}

Json[] toArray(Json value) {
  if (value.isNull) {
    return null;
  }

  if (value.isArray) {
    return value.getArray;
  }

  writeln("return [value]");
  return [value];
}

unittest {
  auto json1 = parseJsonString(`{"versionNumber": 1}`);
  // TODO create test
}

Json updateKey(Json origin, Json additional) {
  if (origin.type != additional.type) {
    return origin;
  } // no update

  if (!origin.isObject) {
    return additional;
  }

  Json updated = origin;
  additional.byKeyValue
    .each!(kv => updated[kv.key] = kv.value);

  return updated;
}

Json updateKey(Json origin, string[string] additional) {
  if (!origin.isObject) { // Overwrite if not object
    Json result = Json.emptyObject;
    additional.byKeyValue
      .each!(kv => result[kv.key] = Json(kv.value));

    return result;
  }

  // origin is Object
  Json updated = origin;
  additional.byKeyValue
    .each!(kv => updated[kv.key] = kv.value);

  return updated;
}

unittest {
  Json json = Json.emptyObject;
  json["a"] = "hallo";
  assert(json["a"].get!string == "hallo");
  json = json.set(["a": "world"]);
  assert(json["a"].get!string == "world");
}

Json toJsonObject(Json[string] items, string[] excludeKeys = null) {
  auto json = Json.emptyObject;
  items.byKeyValue
    .filter!(item => !excludeKeys.any!(key => key == item.key))
    .each!(item => json[item.key] = item.value);
  return json;
}

Json toJsonObject(string[string] map, string[] excludeKeys = null) {
  auto json = Json.emptyObject;
  map.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => key == kv.key))
    .each!(kv => json[kv.key] = Json(kv.value));
  return json;
}

// #region getter
Json getJson(Json value, string key) {
  if (value.isNull || !value.isObject) {
    return Json(null);
  }
  if (value.hasKey(key)) {
    return value[key];
  }
  if (key.contains(".")) {
    auto keys = std.string.split(key, ".");
    auto json = getJson(value, keys[0]);
    return keys.length > 1 && !json.isNull
      ? getJson(json, keys[1 .. $].join(".")) : json;
  }
  return value;
}

// #region getBoolean 
bool getBoolean(Json value, size_t index) {
  return !value.isNull && value.isArray && value.length > index
    ? value[index].getBoolean : false;
}

bool getBoolean(Json value, string key) {
  return !value.isNull && value.isObject && value.hasKey(key)
    ? value[key].getBoolean : false;
}

bool getBoolean(Json value) {
  return !value.isNull && value.isBoolean
    ? value.get!bool : false;
}

unittest {
  Json jValue = Json(true);

  Json jArray = Json.emptyArray;
  jArray ~= true;
  jArray ~= false;

  Json jObject = Json.emptyObject;
  jObject["true"] = true;
  jObject["false"] = false;

  assert(jValue.getBoolean); // == true
  assert(jArray.getBoolean(0)); // == true
  assert(jObject.getBoolean("true")); // == true
}
// #endregion getBoolean

// #region getInteger 
int getInteger(Json value, size_t index) {
  return !value.isNull && value.isArray && value.length > index
    ? value[index].getInteger : 0;
}

int getInteger(Json value, string key) {
  return !value.isNull && value.isObject && value.hasKey(key)
    ? value[key].getInteger : 0;
}

int getInteger(Json value) {
  return !value.isNull && value.isInteger
    ? value.get!int : 0;
}

unittest {
  Json jValue = Json(1);

  Json jArray = Json.emptyArray;
  jArray ~= 1;
  jArray ~= 2;

  Json jObject = Json.emptyObject;
  jObject["one"] = 1;
  jObject["two"] = 2;

  assert(jValue.getInteger == 1); // == true
  assert(jArray.getInteger(0) == 1); // == true
  assert(jObject.getInteger("one") == 1); // == true
}
// #endregion getInteger

// #region getLong
long getLong(Json value, size_t index) {
  return !value.isNull && value.isArray && value.length > index
    ? value[index].getLong : 0;
}

long getLong(Json value, string key) {
  return !value.isNull && value.isObject && value.hasKey(key)
    ? value[key].getLong : 0;
}

long getLong(Json value) {
  return !value.isNull && (value.isInteger || value.isLong)
    ? value.get!long : 0;
}

unittest {
  Json jValue = Json(1);

  Json jArray = Json.emptyArray;
  jArray ~= 1;
  jArray ~= 2;

  Json jObject = Json.emptyObject;
  jObject["one"] = 1;
  jObject["two"] = 2;

  assert(jValue.getLong == 1); // == true
  assert(jArray.getLong(0) == 1); // == true
  assert(jObject.getLong("one") == 1); // == true
}
// #endregion getLong

// #region getFloat
float getFloat(Json value, size_t index) {
  return !value.isNull && value.isArray && value.length > index
    ? value[index].getFloat : 0.0;
}

float getFloat(Json value, string key) {
  return !value.isNull && value.isObject && value.hasKey(key)
    ? value[key].getFloat : 0.0;
}

float getFloat(Json value) {
  return !value.isNull && value.isFloat
    ? value.get!float : 0.0;
}

unittest {
  Json jValue = Json(1.0);

  Json jArray = Json.emptyArray;
  jArray ~= 1.0;
  jArray ~= 2.0;

  Json jObject = Json.emptyObject;
  jObject["one"] = 1.0;
  jObject["two"] = 2.0;

  assert(jValue.getFloat == 1.0); // == true
  assert(jArray.getFloat(0) == 1.0); // == true
  assert(jObject.getFloat("one") == 1.0); // == true
}
// #endregion getFloat

double getDouble(Json value, string key) {
  return !value.isNull && value.isObject && value.hasKey(key)
    ? value[key].getDouble : 0.0;
}

double getDouble(Json value) {
  return !value.isNull && (value.isFloat || value.isDouble)
    ? value.get!double : 0.0;
}

string getString(Json value, string key) {
  return value.isObject && value.hasKey(key)
    ? value[key].getString : null;
}

string getString(Json value) {
  return value.isString
    ? value.get!string : null;
}

// #region getArray
Json[] getArray(Json value, string key) {
  return value.isObject && value.hasKey(key)
    ? value[key].getArray : null;
}

Json[] getArray(Json json) {
  return json.isArray 
    ? json.get!(Json[])
    : null;
} 

unittest {
  Json json = Json.emptyArray;
  json ~= Json(2);
  json ~= Json("3");
  assert(json.getArray.length == 2);
}
// #endregion getArray

Json[string] getMap(Json value, string key) {
  return value.isObject && value.hasKey(key)
    ? value[key].getMap : null;
}

Json[string] getMap(Json value) {
  if (value.isNull) { // TODO required?
    return null;
  }

  return value.isObject
    ? value.get!(Json[string]) : null;
}
// #endregion getter

// #region setter
Json set(T)(Json json, T[string] newValues) {
  if (!json.isObject) {
    return Json(null);
  }

  auto result = json;
  newValues.byKeyValue.each!(kv => result[kv.key] = kv.value);

  return result;
}
///
unittest {
  auto json = parseJsonString(`{"a": "b", "x": "y"}`);
  assert(json.set(["a": "c"])["a"].get!string == "c");

  json = parseJsonString(`{"a": "b", "x": "y"}`);
  assert(json.set(["a": "c", "x": "z"])["x"].get!string == "z");
  assert(json.set(["a": "c", "x": "z"])["x"].get!string != "c");
}
// #endregion

// #endregion setter


Json match(K)(Json[K] matchValues, K key, Json defaultValue = Json(null)) {
  return key in matchValues
    ? matchValues[key] : defaultValue;
}

bool isScalar(Json value) {
  return !value.isArray && !value.isObject;
}

// #region isSet
bool isSet(Json json, string key) {
  return json.isObject
    ? json.byKeyValue.any!(kv => kv.key == key) : false;
}
// #endregion isSet

// #region count
size_t count(Json value) {
  if (value.isNull) {
    return 0;
  }

  if (value.isObject) {
    return value.byKeyValue.array.length;
  }

  if (value.isArray) {
    return value.toArray.length;
  }

  return 1;
}

unittest {
  Json json = Json(null);
  assert(json.count == 0);

  json = Json("one");
  assert(json.count == 1);

  json = Json([Json("one"), Json("two")]);
  assert(json.count == 2);

  json = Json.emptyObject;
  json["one"] = 1;
  json["two"] = 2;
  json["three"] = 3;
  assert(json.count == 3);
}
// #endregion count

// #region remove
Json removeKeys(Json json, string[] keys...) {
  return removeKeys(json, keys.dup);
}

Json removeKeys(Json json, string[] keys) {
  keys.each!(key => json = json.removeKey(key));
  return json;
}

Json removeKey(Json json, string key) {
  json.remove(key);
  return json;
}
// #endregion remove

// #region filter
Json filterKeys(Json json, string[] keys...) {
  return filterKeys(json, keys.dup);
}

Json filterKeys(Json json, string[] keys) {
  return json.removeKeys(json.byKeyValue
      .map!(kv => kv.key)
      .filter!(key => !keys.has(key)).array);

  return json;
}
// #endregion filter
