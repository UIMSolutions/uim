/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.maps.string;

import uim.models;

@safe:
class DStringDataMap : DData, IMap {
  mixin(DataThis!("StringDataMap"));

  protected IData[string] _items;

  // Todo
  /*
  void opIndexAssign(DData value, string key) {
    if (hasKey(key)) {
      _items[key] = value; 
    } else {
      _items[key] = value; }

    return this;
  }

  void opIndexAssign(bool value, string key) {
    if (hasKey(key)) {
      _items[key].set(value ? "true" : "false"); 
    } else {
    _items[key] = new DBooleanData(value); }

  }

  void opIndexAssign(int value, string key) {
    if (hasKey(key)) {
      _items[key].set(to!string(value)); 
    } else {
    _items[key] = new DIntegerData(value); }

  }

  void opIndexAssign(double value, string key) {
    if (hasKey(key)) {
      _items.set(key, to!string(value)); 
    } else {
    _items.set(key, new DDoubleData(value)); }
    
  }

  void opIndexAssign(string value, string key) {    
     if (hasKey(key)) {
      _items[key].set(value); 
    } else {
     _items.set(key, new DStringData(value)); }
    
  }

  void opIndexAssign(UUID value, string key) {
    if (hasKey(key)) {
      _items[key].set(value.toString); 
    } else {
      _items.set(key, new DUUIDData(value)); }

  }

  void opIndexAssign(IData[] values, string key) {
    _items.set(key, hasKey(key)
      ? new DArrayData(values)
      : new DArrayData(values));

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

// TODO assert(stringMap["key1"].toString == "value1");
// TODO assert(cast(DStringData) stringMap["key1"]);
// TODO assert(!cast(DBooleanData) stringMap["key1"]);

  stringMap.set("key2", "value2");
// TODO assert(stringMap["key2"].toString == "value2");

  stringMap.set("key3", true);
// TODO assert(stringMap["key3"].toString == "true");

  stringMap.set("key4", 100);
// TODO assert(stringMap["key4"].toString == "100");

  stringMap.set("key5", 100.1);
// TODO assert(stringMap["key5"].toString == "100.1");

  stringMap.set("key6", [Json("v1"), Json("v2")]);

// TODO assert(stringMap.toJson.toString == `{"key1":"value1","key6":null,"key2":"value2","key3":true,"key5":100.1,"key4":100}`); */
}
