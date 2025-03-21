/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.datatypes.boolean;

@safe:
import uim.core;

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

V Null(V : bool)() {
  return false;
}

unittest {
  assert(Null!bool == false);
  assert(Null!bool != true);
}

// char[] BOOL(bool toogleValue) { return cast(char[])((toogleValue) ? `true`:`false`); }

// #region toogle
/// Toggle boolean value (from true to false, false to true) -> in this function it's !value
bool toggle(bool value) {
  return !value;
}

unittest {
  assert(toggle(true) == false, "Error in toggle(bool)");
  assert(toggle(toggle(true)) == true, "Error in toggle(bool)");

  bool value = true;
  assert(value.toggle == false);
  /* assert(value == false);

  value = true;
  assert(value.toggle.toggle == true); */
}
// #endregion toogle

// #region isBoolean
// #region Json
bool isBooleanLike(Json value) {
  if (value.isString) {
    return uim.core.datatypes.string_.isBoolean(value.getString);
  }
  if (value.isLong || value.isInteger) {
    return true; // 0 - false; >0 - true   
  }
  return value.isBoolean;
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

bool isAnyBoolean(Json value) {
  if (value.isObject)
    return value.isAnyBoolean(value.keys); 

  if (value.isArray)
    return value.get!(Json[]).isAnyBoolean; 

  return value.isBoolean;
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
// #endregion json

// #region json[]
bool isAnyBoolean(Json[] values...) {
  return isAnyBoolean(values.dup);
}

bool isAnyBoolean(Json[] values) {
  return values.any!(value => value.isBoolean);
}

bool isAllBoolean(Json[] values...) {
  return isAllBoolean(values.dup);
}

bool isAllBoolean(Json[] values) {
  return values.all!(value => value.isBoolean);
}

unittest {
  auto values = [Json(true), Json(false)];
  assert(values.isAllBoolean);

  values = [Json(true), Json(1)];
  assert(!values.isAllBoolean);

  values = [Json(true), Json(false)];
  assert(values.isAnyBoolean);

  values = [Json(true), Json(1)];
  assert(values.isAnyBoolean);

  values = [Json("X"), Json(1)];
  assert(!values.isAnyBoolean);
}
// #endregion json[]

// #region Json[string]
bool isBoolean(Json[string] items, string key) {
  return items.hasKey(key)
    ? items[key].isBoolean : false;
}
// #endregion Json[string]

// #endregion isBoolean

// #region translate
/// Translates boolean to defined values
pure T translateTo(T)(bool value, T trueValue, T falseValue) {
  return (value) ? trueValue : falseValue;
}

unittest {
  assert(translateTo(true, false, true) == false, "Error in translate(bool, T, T)");
  assert(translateTo(false, false, true) == true, "Error in translate(bool, T, T)");

  assert(translateTo(true, "YES", "NO") == "YES", "Error in translate(bool, T, T)");
  assert(translateTo(false, "YES", "NO") == "NO", "Error in translate(bool, T, T)");

  assert(translateTo(true, 1, 2) == 1, "Error in translate(bool, T, T)");
  assert(translateTo(false, 1, 2) == 2, "Error in translate(bool, T, T)");

  assert(translateTo(true, 1, 2) == 1, "Error in translate(bool, T, T)");
  assert(translateTo(false, 1, 2) == 2, "Error in translate(bool, T, T)");
}
// #endregion translateTo

// #region ifBoolean
Json ifBoolean(Json value, Json booleanValue) {
  return value.isBoolean ? booleanValue : value;
}

Json ifBoolean(Json obj, string key, Json booleanValue) {
  return obj.hasKey(key) && obj[key].isBoolean ? booleanValue : obj[key];
}

Json ifBoolean(Json[string] map, string key, Json booleanValue) {
  return map.hasKey(key) && map[key].isBoolean ? booleanValue : map[key];
}

unittest {
  auto value = Json(true);
  assert(value.ifBoolean(Json(1)) == Json(1));

  value = Json("abc");
  assert(value.ifBoolean(Json(1)) == Json("abc"));

  value = Json.emptyObject;
  value["a"] = Json(true);
  value["b"] = Json(100);
  assert(value.ifBoolean("a", Json(1)) == Json(1));
  assert(value.ifBoolean("b", Json(50)) == Json(100));

  Json[string] map;
  map["a"] = Json(true);
  map["b"] = Json(100);
  assert(map.ifBoolean("a", Json(1)) == Json(1));
  assert(map.ifBoolean("b", Json(50)) == Json(100));
}
// #endregion ifBoolean

// #region ifNotBoolean
Json ifNotBoolean(Json value, Json notBooleanValue) {
  return value.isBoolean ? value : notBooleanValue;
}

Json ifNotBoolean(Json obj, string key, Json notBooleanValue) {
  return obj.hasKey(key) && obj[key].isBoolean ? obj[key] : notBooleanValue;
}

Json ifNotBoolean(Json[string] map, string key, Json notBooleanValue) {
  return map.hasKey(key) && map[key].isBoolean ? map[key] : notBooleanValue;
}

unittest {
  auto value = Json(true);
  assert(value.ifNotBoolean(Json(1)) == Json(true));

  value = Json("abc");
  assert(value.ifNotBoolean(Json(1)) != Json(true));
  assert(value.ifNotBoolean(Json(1)) == Json(1));

  value = Json.emptyObject;
  value["a"] = Json(true);
  value["b"] = Json(100);
  assert(value.ifNotBoolean("a", Json(1)) == Json(true));
  assert(value.ifNotBoolean("b", Json(50)) == Json(50));

  Json[string] map;
  map["a"] = Json(true);
  map["b"] = Json(100);
  assert(map.ifNotBoolean("a", Json(1)) == Json(true));
  assert(map.ifNotBoolean("b", Json(100)) == Json(100));
}
// #endregion ifNotBoolean
