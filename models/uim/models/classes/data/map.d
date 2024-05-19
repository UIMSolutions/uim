/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.map;

import uim.models;
@safe:

class DMapData {
  this() { initialize; }

  bool initialize(Json[string] initData = null) {}

  mixin(TProperty!("Json[string]", "items"));

  string[] names() { return items.keys; }

  bool hasValue(string key) { return key in _items ? true : false; }
  string[] keys() { return _items.keys; }
  Json[] values() { return _items.values; }

  Json opIndex(string name) { return _items.get(name, NullData); }

  // Set value, if key exists
  void opIndexAssign(bool newValue, string key) {
    _items[key] = BooleanData(newValue);
  }

/*  void opIndexAssign(Json newValue, string key) {
    _items[key] = JsonValue(newValue);
  } */

  void opIndexAssign(DData newValue, string key) {
    _items[key] = newValue;
  }

  void opIndexAssign(long newValue, string key) {
    _items[key] = IntegerData(newValue);
  }

  void opIndexAssign(string newValue, string key) {
    _items[key] = StringData(newValue);
  }

  void opIndexAssign(UUID newValue, string key) {
    _items[key] = UUIDData(newValue);
  }

  void addValues(Json[string] newValues) {
    newValues.byKey.each!(key => addData(key, newValues[key]));
    
  }

  void addValues(DAttribute[string] attributes) {
    attributes.byKey.each!(key => addData(key, attributes[key].createValue));
    
  }

  void addData(string fieldName, Json newValue) {
    _items[fieldName] = newValue;
    
  }

  Json toJson() {
    return toJson(Json.emptyObject);
  }

  Json toJson(Json obj) {
    keys.each!(key => obj[key] = _items[key].toJson);
    return obj;
  }
  
  DMapData copy() {
    DMapData MapValue = MapValue;

    foreach(key, value; _items) {
      MapValue[key] = value.clone;
    }

    return MapValue;
  }
}
auto MapValue() { return new DMapData; }

version(test_uim_models) { unittest {
  auto map = MapValue;
  map["key1"] = "value1";
  map["key2"] = true;
  map["key3"] = 100;
  debug writeln(map.keys);
  assert("key1" in map);
  assert(map["key1"].toString == "value1");
  assert(map["key1"].get == "value1");
  assert(map["key2"].toString == "true");
  assert(map["key2"].get());
  assert(map["key3"].toString == "100");
  assert(map["key3"].get == 100);
}}

unittest {
  auto map = MapValue;
  map["key1"] = "value1";
  map["key2"] = true;
  map["key3"] = 100;
  debug writeln(map.keys);
  debug writeln(map.values.map!(v => v.toString).array);
} 