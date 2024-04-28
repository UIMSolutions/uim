/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.datatypes.maps.string;

import uim.oop;

@safe:
class DStringDataMap : DData, IMap {
  mixin(DataThis!("StringDataMap"));

  protected IData[string] _items;

  // Todo
  /*
  void opIndexAssign(DData value, string key) {
    if (containsKey(key)) {
      _items[key] = value; 
    } else {
      _items[key] = value; }

    return this;
  }

  void opIndexAssign(bool value, string key) {
    if (containsKey(key)) {
      _items[key].set(value ? "true" : "false"); 
    } else {
    _items[key] = new DBoolData(value); }

  }

  void opIndexAssign(int value, string key) {
    if (containsKey(key)) {
      _items[key].set(to!string(value)); 
    } else {
    _items[key] = new DIntegerData(value); }

  }

  void opIndexAssign(double value, string key) {
    if (containsKey(key)) {
      _items[key].set(to!string(value)); 
    } else {
    _items[key] = new DDoubleData(value); }
    
  }

  void opIndexAssign(string value, string key) {    
     if (containsKey(key)) {
      _items[key].set(value); 
    } else {
     _items[key] = new DStringData(value); }
    
  }

  void opIndexAssign(UUID value, string key) {
    if (containsKey(key)) {
      _items[key].set(value.toString); 
    } else {
      _items[key] = new DUUIDData(value); }

  }

  void opIndexAssign(IData[] values, string key) {
    _items[key] = containsKey(key)
      ? new DArrayData(values)
      : new DArrayData(values);

  } */

  override IData opIndex(string key) {
    return _items.value(key, null);
  }

  bool isEmpty() {
    return (_items.length == 0);
  }

  override size_t length() {
    return _items.length;
  }

  override string[] keys() {
    return _items.keys;
  }

  // containsKey - Returns true if this map contains a mapping for the specified key.
  bool containsKey(string keyToCheck) {
    return keys.each!(key => key == keyToCheck);
  }

  override IData[] values() {
    return _items.values;
  }

  /// containsValue - Returns true if this map maps one or more keys to the specified value.
  bool containsValue(IData value) {
    // todo
    /* foreach(v; values) {
      if (v == value) { return true; }
    } */
    return false;
  }

  override IData clone() {
    return NullData; // StringDataMap(attribute, toJson);
  }

  alias toJson = DData.toJson;
  override Json toJson() {
    Json results = Json.emptyObject;

    foreach (key, value; _items) {
      results[key] = value.toJson;
    }

    return results;
  }

  override string toString() {
    string[] results;

    foreach (key, value; _items) {
      results ~= "%s:%s".format(key, value);
    }

    return "[" ~ results.join(",") ~ "]";
  }
}

auto StringDataMap()() {
  return new DStringDataMap;
}

///
unittest {
  /* auto stringMap = StringDataMap();
  stringMap["key1"] = Json("value1");

  assert(stringMap["key1"].toString == "value1");
  assert(cast(DStringData) stringMap["key1"]);
  assert(!cast(DBoolData) stringMap["key1"]);

  stringMap["key2"] = "value2";
  assert(stringMap["key2"].toString == "value2");

  stringMap["key3"] = true;
  assert(stringMap["key3"].toString == "true");

  stringMap["key4"] = 100;
  assert(stringMap["key4"].toString == "100");

  stringMap["key5"] = 100.1;
  assert(stringMap["key5"].toString == "100.1");

  stringMap["key6"] = [Json("v1"), Json("v2")];

  assert(stringMap.toJson.toString == `{"key1":"value1","key6":null,"key2":"value2","key3":true,"key5":100.1,"key4":100}`); */
}
