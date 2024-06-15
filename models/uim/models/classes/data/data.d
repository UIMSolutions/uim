/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.data;

import uim.models;

@safe:
class DData : IData {
  this() {
    this.initialize;
  }

  this(Json[string] initData) {
    this.initialize(initData);
  }

  // Hook
  bool initialize(Json[string] initData = null) {
    _value = Json.emptyObject;
    // TODO _value.update(initData);

    return true;
  }

  mixin(TProperty!("Json", "_value"));

  // #region properties
  // mixin(TProperty!("DAttribute", "attribute"));

  // #region typeName
    string typeName() {
      return _value.getString("typeName");
    }

    void typeName(string name) {
      _value.set("typeName", name);
    }
  // #endregion typeName

  // #region name
  string name() {
    return _value.getString("name");
  }

  void name(string name) {
    _value.set("name", name);
  }
  // #endregion name

  // #region is-check
  // #region is-BasicTypes
  mixin(DataIsCheck!"isBigInt");
  mixin(DataIsCheck!"isBoolean");
  mixin(DataIsCheck!"isDouble");
  mixin(DataIsCheck!"isLong");
  mixin(DataIsCheck!"isString");
  // #endregion is-check Basic Types

  // #region is-AdditionalTypes
  mixin(DataIsCheck!"isUUID");
  mixin(DataIsCheck!"isNumber");
  mixin(DataIsCheck!"isNumeric");
  mixin(DataIsCheck!"isTime");
  mixin(DataIsCheck!"isDate");
  mixin(DataIsCheck!"isDatetime");
  mixin(DataIsCheck!"isTimestamp");
  // #endregion is-AdditionalTypes

  // #region is-AdditionalTypes
  mixin(DataIsCheck!"isScalar");
  mixin(DataIsCheck!"isArray");
  mixin(DataIsCheck!"isObject");
  mixin(DataIsCheck!"isEntity");
  mixin(DataIsCheck!"isNullable");
  mixin(DataIsCheck!"isReadOnly");

  bool isEmpty() {
    return _value.isNull
      ? true : false;
  }
  // #endregion is-AdditionalTypes
  // #endregion is-check

  // #region get
  mixin(DataGet!("Boolean", "bool", "false"));
  mixin(DataGet!("Long", "long", "0"));
  mixin(DataGet!("Double", "double", "0.0"));
  mixin(DataGet!("String", "string", "null"));
  mixin(DataGet!("Array", "Json[]", "null"));
  mixin(DataGet!("Object", "Json[string]", "null"));

  UUID getUUID() {
    return isUUID && _value.hasKey("value")
      ? UUID(_value["value"].get!string) : UUID();
  }

  Json getJson() {
    return _value.hasKey("value")
      ? _value["value"].clone : Json(null);
  }
  // #endregion get

  // #region isNull
  bool isNull() {
    return _value.hasKey("value")
      ? _value["value"].isNull : false;
  }

  void isNull(bool status) {
    if (isNullable) {
      _value["value"] = Json(null);
    }
  }
  // #endregion isNull
  // #endregion properties 

  // #region set

  ref Json opAssign(
    Json v
  ) nothrow return @trusted;

  void opAssign(
    typeof(null) __param_0
  ) nothrow @trusted;

  mixin(DataSet!("bool"));
  mixin(DataSet!("int"));
  mixin(DataSet!("long"));
  mixin(DataSet!("std.bigint.BigInt"));
  mixin(DataSet!("float"));
  mixin(DataSet!("double"));
  mixin(DataSet!("string"));
  mixin(DataSet!("Json"));
  mixin(DataSet!("Json[]"));
  mixin(DataSet!("Json[string]"));

  void set(UUID newValue) {
    set(newValue.toString);
  }
  // #endregion set

  // #region opCall - Example: x("value")
  mixin(DataOpCall!("bool"));
  mixin(DataOpCall!("int"));
  mixin(DataOpCall!("long"));
  mixin(DataOpCall!("std.bigint.BigInt"));
  mixin(DataOpCall!("double"));
  mixin(DataOpCall!("string"));
  mixin(DataOpCall!("Json"));
  mixin(DataOpCall!("Json[]"));
  mixin(DataOpCall!("Json[string]"));
  // #endregion opCall

  // #region equal
  //#region opEquals
  bool opEquals(bool checkValue) {
    return isEqual(checkValue);
  }

  bool opEquals(int checkValue) {
    return isEqual(checkValue);
  }

  bool opEquals(long checkValue) {
    return isEqual(checkValue);
  }

  bool opEquals(float checkValue) {
    return isEqual(checkValue);
  }

  bool opEquals(double checkValue) {
    return isEqual(checkValue);
  }

  bool opEquals(string checkValue) {
    return isEqual(checkValue);
  }

  bool opEquals(UUID checkValue) {
    return isEqual(checkValue);
  }

  bool opEquals(Json checkValue) {
    return isEqual(checkValue);
  }
  //#endregion opEquals

  // #region isEqual
  bool isEqual(bool checkValue) {
    return isBoolean && !isNull
      ? getBoolean == checkValue : false;
  }

  bool isEqual(long checkValue) {
    return !isNull
      ? getLong == checkValue : false;
  }

  bool isEqual(double checkValue) {
    return isDouble && !isNull
      ? getDouble == checkValue : false;
  }

  bool isEqual(string checkValue) {
    return isString && !isNull
      ? getString == checkValue : false;
  }

  bool isEqual(UUID checkValue) {
    return !isNull
      ? getUUID == checkValue : false;
  }

  bool isEqual(Json checkValue) {
    return false;
  }
  // #endregion isEqual
  // #endregion equal

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

  bool has(string key, bool deepSearch = false) { // Short version
    return hasKey(key, deepSearch);
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
  /*   void data(string key, IData data) {
  } */

  /*   // Return data of keys
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
  // #endregion data() */

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

  IData create() {
    return new DData;
  }

  IData clone() {
    auto result = create();
    /* result.fromJson(toJson); */
    return result;
  }

  // #region export
  Json toJson() {
    return _value.clone;
  }

  override string toString() {
    string results;
    // _value.byKeyValue.each!(kv => results[kv.key] = kv.value.get!string);
    return results;
  }
  // #endregion export

  // #region import
  void fromString(STRINGAA newValue, bool shouldOverwrite = true) {
    // TODO 
    /* 
      if (shouldOverwrite) {
        _value = _value.update(newValue);
      } else {
        _value = _value.merge(newValue);
      } 
      */
  }

  void fromJson(Json newValue, bool shouldOverwrite = true) {
    /*       if (shouldOverwrite) {
        _value = _value.update(newValue);
      } else {
        _value = _value.merge(newValue);
      }  */
  }
  // #endregion import
}

unittest {
  auto value = new DData;
  // TODO assert(!value.isNull);
  // TODO assert(!value.isString);
  // TODO assert(!value.isInteger);
  // TODO assert(!value.isBoolean);
  // TODO assert(!value.isNumber);
  // TODO assert(!value.isNullable);
  // TODO assert(!value.isObject);
  // TODO assert(!value.isArray);
}
