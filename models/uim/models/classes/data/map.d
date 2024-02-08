/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.map;

import uim.models;
@safe:

/* class DMapValue {
  this() { initialize; }

  void initialize(Json configSettings = Json(null)) {}

  mixin(OProperty!("DValue[string]", "items"));

  string[] names() { return items.keys; }

  bool hasValue(string key) { return key in _items ? true : false; }
  string[] keys() { return _items.keys; }
  DValue[] values() { return _items.values; }

  DValue opIndex(string name) { return _items.get(name, NullValue); }

  // Set value, if key exists
  void opIndexAssign(bool newValue, string key) {
    _items[key] = BooleanValue(newValue);
  }

/*   void opIndexAssign(Json newValue, string key) {
    _items[key] = JsonValue(newValue);
  } * /

  void opIndexAssign(DValue newValue, string key) {
    _items[key] = newValue;
  }

  void opIndexAssign(long newValue, string key) {
    _items[key] = LongValue(newValue);
  }

  void opIndexAssign(string newValue, string key) {
    _items[key] = StringValue(newValue);
  }

  void opIndexAssign(UUID newValue, string key) {
    _items[key] = UUIDValue(newValue);
  }

  O addValues(this O)(DValue[string] newValues) {
    newValues.byKey.each!(key => addValue(key, newValues[key]));
    return cast(O)this;
  }

  O addValues(this O)(DAttribute[string] attributes) {
    attributes.byKey.each!(key => addValue(key, attributes[key].createValue));
    return cast(O)this;
  }

  O addValue(this O)(string fieldName, DValue newValue) {
    _items[fieldName] = newValue;
    return cast(O)this;
  }

  Json toJson() {
    return toJson(Json.emptyObject);
  }

  Json toJson(Json obj) {
    keys.each!(key => obj[key] = _items[key].toJson);
    return obj;
  }
  
  DMapValue copy() {
    DMapValue MapValue = MapValue;

    foreach(key, value; _items) {
      MapValue[key] = value.copy;
    }

    return MapValue;
  }
}
auto MapValue() { return new DMapValue; }

version(test_uim_models) { unittest {
  auto map = MapValue;
  map["key1"] = "value1";
  map["key2"] = true;
  map["key3"] = 100;
  debug writeln(map.keys);
  assert("key1" in map);
  assert(map["key1"].toString == "value1");
  assert(map["key1"].value == "value1");
  assert(map["key2"].toString == "true");
  assert(map["key2"].value);
  assert(map["key3"].toString == "100");
  assert(map["key3"].value == 100);
}}

unittest {
  auto map = MapValue;
  map["key1"] = "value1";
  map["key2"] = true;
  map["key3"] = 100;
  debug writeln(map.keys);
  debug writeln(map.values.map!(v => v.toString).array);
} */