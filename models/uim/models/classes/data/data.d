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

  // Hook
  bool initialize(Json[string] initData = null) {
    _value = Json.emptyObject;

    return true;
  }

  // #region properties
  // mixin(TProperty!("DAttribute", "attribute"));

  // #region typeName
    string typeName() {
      return _value.hasKey("typeName")
        ? _value["typeName"].get!string : null;
    }

    void typeName(string name) {
      _value["typeName"] = name;
    }
  // #endregion typeName

  // #region name
    string name() {
      return _value.hasKey("name")
        ? _value["name"].get!string : null;
    }

    void name(string name) {
      _value["name"] = name;
    }
  // #endregion name

  bool isBoolean() {
    return _value.hasKey("isBoolean")
      ? _value["isBoolean"].get!bool : false;
  }

  void isBoolean(bool mode) {
    _value["isBoolean"] = mode;
  }

  bool isInteger() {
    return _value.hasKey("isInteger")
      ? _value["isInteger"].get!bool : false;
  }

  void isInteger(bool mode) {
    _value["isInteger"] = mode;
  }

  bool isNumber() {
    return _value.hasKey("isNumber")
      ? _value["isNumber"].get!bool : false;
  }

  void isNumber(bool mode) {
    _value["isNumber"] = mode;
  }

  bool isTime() {
    return _value.hasKey("isTime")
      ? _value["isTime"].get!bool : false;
  }

  void isTime(bool mode) {
    _value["isTime"] = mode;
  }

  bool isDate() {
    return _value.hasKey("isDate")
      ? _value["isDate"].get!bool : false;
  }

  void isDate(bool mode) {
    _value["isDate"] = mode;
  }

  bool isDatetime() {
    return _value.hasKey("isDatetime")
      ? _value["isDatetime"].get!bool : false;
  }

  void isDatetime(bool mode) {
    _value["isDatetime"] = mode;
  }

  bool isTimestamp() {
    return _value.hasKey("isTimestamp")
      ? _value["isTimestamp"].get!bool : false;
  }

  void isTimestamp(bool mode) {
    _value["isTimestamp"] = mode;
  }

  bool isString() {
    return _value.hasKey("isString")
      ? _value["isString"].get!bool : false;
  }

  void isString(bool mode) {
    _value["isString"] = mode;
  }

  bool isNumeric() {
    return _value.hasKey("isNumeric")
      ? _value["isNumeric"].get!bool : false;
  }

  void isNumeric(bool mode) {
    _value["isNumeric"] = mode;
  }

  bool isScalar() {
    return _value.hasKey("isScalar")
      ? _value["isScalar"].get!bool : false;
  }

  void isScalar(bool mode) {
    _value["isScalar"] = mode;
  }

  bool isArray() {
    return _value.hasKey("isArray")
      ? _value["isArray"].get!bool : false;
  }

  void isArray(bool mode) {
    _value["isArray"] = mode;
  }

  bool isObject() {
    return _value.hasKey("isObject")
      ? _value["isObject"].get!bool : false;
  }

  void isObject(bool mode) {
    _value["isObject"] = mode;
  }

  bool isEntity() {
    return _value.hasKey("isEntity")
      ? _value["isEntity"].get!bool : false;
  }

  void isEntity(bool mode) {
    _value["isEntity"] = mode;
  }

  bool isUUID() {
    return _value.hasKey("isUUID")
      ? _value["isUUID"].get!bool : false;
  }

  void isUUID(bool mode) {
    _value["isUUID"] = mode;
  }

  // #region isReadOnly
    bool isReadOnly() {
      return _value.hasKey("isReadOnly")
        ? _value["isReadOnly"].get!bool : false;
    }

    void isReadOnly(bool mode) {
      _value["isReadOnly"] = mode;
    }
  // #endregion isReadOnly

  // #region isNullable
    bool isNullable() {
      return _value.hasKey("isNullable")
        ? _value["isNullable"].get!bool : false;
    }

    void isNullable(bool mode) {
      _value["isNullable"] = mode;
    }
  // #region isNullable

  // #region get
    bool getBool() {
      return isBoolean && _value.hasKey("value")
        ? _value["value"].get!bool : false;
    }

    int getInt() {
      return isInt && _value.hasKey("value")
        ? _value["value"].get!int : 0;
    }

    long getLong() {
      return isLong && _value.hasKey("value")
        ? _value["value"].get!long : 0;
    }

    float getFloat() {
      return isFloat && _value.hasKey("value")
        ? _value["value"].get!float : 0.0;
    }

    double getDouble() {
      return isDouble && _value.hasKey("value")
        ? _value["value"].get!double : 0.0;
    }

    string getString() {
      return isString && _value.hasKey("value")
        ? _value["value"].get!string : null;
    }

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
        ? _value["value"].isNull : true;
    }

    void isNull(bool status) {
      if (isNullable) {
        _value["value"] = Json(null);
      }
    }
  // #endregion isNull
  // #endregion properties 

  // #region set
    void set(bool newValue) {
      if (!isReadOnly) {
        _value["value"] = newValue;
      }
    }

    void set(int newValue) {
      if (!isReadOnly) {
        _value["value"] = newValue;
      }
    }

    void set(long newValue) {
      if (!isReadOnly) {
        _value["value"] = newValue;
      }
    }

    void set(float newValue) {
      if (!isReadOnly) {
        _value["value"] = newValue;
      }
    }

    void set(double newValue) {
      if (!isReadOnly) {
        _value["value"] = newValue;
      }
    }

    void set(string newValue) {
      if (!isReadOnly) {
        _value["value"] = newValue;
      }
    }

    void set(UUID newValue) {
      if (!isReadOnly) {
        _value["value"] = newValue.toString;
      }
    }

    void set(Json newValue) {
      if (!isReadOnly) {
        _value["value"] = newValue;
      }
    }
  // #endregion set

  // #region opCall - Example: x("value")
      void opCall(bool newValue) {
        set(newValue);
      }

      void opCall(int newValue) {
        set(newValue);
      }

      void opCall(long newValue) {
        set(newValue);
      }

      void opCall(float newValue) {
        set(newValue);
      }

      void opCall(double newValue) {
        set(newValue);
      }

      void opCall(string newValue) {
        set(newValue);
      }

      void opCall(Json newValue) {
        set(newValue);
      }
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
        return !isNull
          ? getBool == checkValue
          : false;
      }

      bool isEqual(int checkValue) {
        return !isNull
          ? getInt == checkValue
          : false;
      }

      bool isEqual(long checkValue) {
        return !isNull
          ? getLong == checkValue
          : false;
      }

      bool isEqual(float checkValue) {
        return !isNull
          ? getFloat == checkValue
          : false;
      }

      bool isEqual(double checkValue) {
        return !isNull
          ? getDouble == checkValue
          : false;
      }

      bool isEqual(string checkValue) {
        return !isNull
          ? getString == checkValue
          : false;
      }

      bool isEqual(UUID checkValue) {
        return !isNull
          ? getUUID == checkValue
          : false;
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

  IData create() {
    return new DData;
  }

  IData clone() {
    auto result = create();
    result.fromJson();
    return result;
  }

  // #region export
    Json toJson() {
      return _value.clone;
    }

    override string toString() {
      STRINGAA results;
      _value.byKeyValue.each!(kv => results[kv.key] = kv.value.get!string);
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
      if (shouldOverwrite) {
        _value = _value.update(newValue);
      } else {
        _value = _value.merge(newValue);
      } 
    }
  // #endregion import
}

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
