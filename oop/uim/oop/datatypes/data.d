/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.datatypes.data;

import uim.oop;

@safe:
class DData : IData {
  this() {
    initialize;
  }

  this(string newValue) {
    this();
    set(newValue);
  }

  this(Json newValue) {
    this();
    set(newValue);
  }

  /* this(DAttribute theAttribute) {
    this().attribute(theAttribute);
  }*/

  // Hook
  bool initialize(IData[string] initData = null) {
    // configuration(MemoryConfiguration);
    // configurationData(initData);
    return true;
  }

  mixin TConfigurable!();

  // #region properties
  // mixin(TProperty!("DAttribute", "attribute"));

  mixin(TProperty!("bool", "isBoolean"));
  bool toBoolean() {
    return false;
  }

  mixin(TProperty!("bool", "isInteger"));
  int toInteger() { return 0; }
  long toLong() { return 0; }

  mixin(TProperty!("bool", "isNumber"));
    float toFloat()  { return 0.0; }
    double toDouble() { return 0.0; }

  mixin(TProperty!("bool", "isTime"));
  mixin(TProperty!("bool", "isDate"));
  mixin(TProperty!("bool", "isDatetime"));
  mixin(TProperty!("bool", "isTimestamp"));
  mixin(TProperty!("bool", "isString"));
  mixin(TProperty!("bool", "isNumeric"));

  mixin(TProperty!("bool", "isScalar"));
  mixin(TProperty!("bool", "isArray"));
  mixin(TProperty!("bool", "isObject"));
  mixin(TProperty!("bool", "isEntity"));
  mixin(TProperty!("bool", "isUUID"));

  mixin(TProperty!("bool", "isReadOnly"));
  mixin(TProperty!("bool", "isNullable"));

  mixin(TProperty!("string", "typeName"));
  mixin(TProperty!("string", "name"));

  // #region isNull
  private bool _isNull;
  bool isNull() {
    if (isNullable)
      return isNull;
    return false;
  }

  void isNull(bool newNull) {
    if (isNullable)
      _isNull = newNull;
  }
  // #endregion isNull
  // #endregion properties 

  // #region set
  void set(IData newValue) {
    if (isReadOnly) {
      return;
    }
    // TODO
  }
    void set(Json newValue) {
    if (isReadOnly) {
      return;
    }
    // TODO
  }

  void set(string newValue) {
    if (isReadOnly) {
      return;
    }
    // TODO
  }

  void opCall(IData newValue) {
    set(newValue);
  }

  void opCall(Json newValue) {
    set(newValue);
  }

  void opCall(string newValue) {
    set(newValue);
  }
  // #endregion set

  // #region equals
  bool opEquals(IData[string] checkData) {
    return isEqual(checkData);
  }

  bool opEquals(string checkValue) {
    return isEqual(checkValue);
  }

  bool opEquals(IData checkValue) {
    return isEqual(checkValue);
  }

  bool opEquals(Json checkValue) {
    return isEqual(checkValue);
  }

  bool isEqual(IData[string] checkData) {
    return false;
  }

  bool isEqual(IData checkValue) {
    return false;
  }

  bool isEqual(Json checkValue) {
    return false;
  }

  bool isEqual(string checkValue) {
    return false;
  }
  // #endregion equals

  IData[] values() {
    return null;
  }

  // #region key/keys
  mixin(TProperty!("string", "key"));

  bool hasKey() {
    return !key.isEmpty;
  }

  bool hasAllKeys() {
    return !keys.isEmpty;
  }

  bool hasAllKeys(string[] keys, bool deepSearch = false) {
    return false;
  }

  bool hasKey(string key, bool deepSearch = false) {
    return false;
  }

  bool hasAllKeys(string[] keys) {
    return false;
  }

  string[] keys() {
    return null;
  }
  // #endregion key/keys

  ulong length() {
    return 0;
  }

  bool hasPaths(string[] paths, string separator = "/") {
    return false;
  }

  bool hasPath(string path, string separator = "/") {
    return false;
  }

  // #region data
  // #region data()
  void data(string key, IData data) {
  }

  // Return data of keys
  override IData[string] data(string[] keys) {
    IData[string] result;
    keys
      .filter!(key => hasKey(key))
      .each!(key => result[key] = data(key));
    return result;
  }

  IData data(string key) {
    return null;
  }
  // #endregion data()

  // #region hasData()
  bool hasData(IData[string] checkData, bool deepSearch = false) {
    return false;
  }

  bool hasData(IData[] data, bool deepSearch = false) {
    return false;
  }

  bool hasData(IData data, bool deepSearch = false) {
    return false;
  }
  // #endregion hasData()
  // #endregion data

  IData value(string key, IData defaultData) {
    return null;
  }

  IData opIndex(string key) {
    return null;
  }

  void opAssignIndex(IData data, string key) {
  }

  Json toJson(string[] selectedKeys = null) {
    return Json(null);
  }

  /* void opCall(DAttribute newAttribute, Json newData) {
    attribute(newAttribute);
    fromJson(newData);
  } */

  IData at(size_t pos) {
    return null;
  }

  IData clone() {
    return null;
  }

  Json toJson() {
    return Json(null);
  }

  override string toString() {
    return null;
  }

  void fromJson(Json newValue) {
  }

  void fromString(string newValue) {
  }
}

version (test_uim_models) {
  unittest {
    void value = new DData;
    assert(!value.isNull);
    assert(!value.isString);
    assert(!value.isInteger);
    assert(!value.isBoolean);
    assert(!value.isNumber);
    assert(!value.isNullable);
    assert(!value.isObject);
    assert(!value.isArray);
  }
}
