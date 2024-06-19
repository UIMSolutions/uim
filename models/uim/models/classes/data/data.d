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

  // #region Getter
  bool getBoolean() {
    return false;
  }

  long getLong() {
    return 0;
  }

  double getDouble() {
    return 0.0;
  }

  string getString() {
    return null;
  }

  Json[] getArray() {
    return null;
  }

  Json[string] getMap() {
    return null;
  }
  // #endregion Getter

  UUID getUUID() {
    return isUUID && _value.hasKey("value")
      ? UUID(_value.getString("value")) : UUID();
  }

  Json getJson() {
    return _value.hasKey("value")
      ? _value["value"] : Json(null);
  }
  Json getJson(string key) {
    return _value.hasKey("value")
      ? uim.core.datatypes.json.getJson(_value["value"], key) : Json(null);
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

  // #region opAssign
  void opAssign(bool newValue) {
    set(newValue);
  }

  void opAssign(long newValue) {
    set(newValue);
  }

  void opAssign(double newValue) {
    set(newValue);
  }

  void opAssign(string newValue) {
    set(newValue);
  }

  void opAssign(Json newValue) {
    set(newValue);
  }

  void opAssign(Json[] newValue) {
    set(newValue);
  }

  void opAssign(Json[string] newValue) {
    set(newValue);
  }
  // #endregion opAssign

  // #region setter  
    void set(bool value) {    
    }

    void set(long value) {    
    }

    void set(double value) {    
    }

    void set(string value) {    
    }

    void set(Json value) {    
    }

    void set(Json[] value) {    
    }

    void set(Json[string] value) {    
    }

    void set(UUID newValue) {
      set(newValue.toString);
    }
  // #endregion setter

  // #region equal
  //#region opEquals
    bool opEquals(bool checkValue) {
      return isEqual(checkValue);
    }

    bool opEquals(long checkValue) {
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

    bool opEquals(Json[] checkValue) {
      return isEqual(checkValue);
    }

    bool opEquals(Json[string] checkValue) {
      return isEqual(checkValue);
    }
  //#endregion opEquals

  // #region isEqual
// #region isEqual
    bool isEqual(bool value) {
      return false;
    }

    bool isEqual(long value) {
      return false;
    }

    bool isEqual(double value) {
      return false;
    }

    bool isEqual(string value) {
      return false;
    }    

    bool isEqual(UUID checkValue) {
      return false; 
    }

    bool isEqual(Json checkValue) {
      return false;
    }

    bool isEqual(Json[] value) {
      return false;
    }
    
    bool isEqual(Json[string] value) {
      return false;
    }
  // #endregion isEqual

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

  /* IData value(string key, IData defaultData) {
    return null;
  } */

/*   IData opIndex(string key) {
    return null;
  }

  void opAssignIndex(IData data, string key) {
  } */

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
    return null; // TODO new DData;
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
