/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.value;

import uim.models;

@safe:
class DData : IData {
  this() { initialize; }
  this(DAttribute theAttribute) { this().attribute(theAttribute); }

  // Hook
  bool initialize(IData[string] configData = null) {
    return true;
  }

  // #region properties
    mixin(TProperty!("DAttribute", "attribute"));

    mixin(TProperty!("bool", "isBoolean"));
    mixin(TProperty!("bool", "isInteger"));
    mixin(TProperty!("bool", "isDouble"));
    mixin(TProperty!("bool", "isLong"));
    mixin(TProperty!("bool", "isTime"));
    mixin(TProperty!("bool", "isDate"));
    mixin(TProperty!("bool", "isDatetime"));
    mixin(TProperty!("bool", "isTimestamp"));
    mixin(TProperty!("bool", "isString"));

    mixin(TProperty!("bool", "isScalar"));
    mixin(TProperty!("bool", "isArray"));
    mixin(TProperty!("bool", "isObject"));
    mixin(TProperty!("bool", "isEntity"));
    mixin(TProperty!("bool", "isUUID"));
    
    mixin(TProperty!("bool", "isReadOnly"));
    mixin(TProperty!("bool", "isNullable"));
    // #region isNull
      private bool _isNull;
      bool isNull() {
        if (isNullable) return isNull; 
        return false; }
      O isNull(this O)(bool newNull) {
        if (isNullable) _isNull = newNull; 
        return cast(O)this; }
    // #endregion isNull
  // #endregion properties 

  protected void set(Json newValue) {
    // TODO
  }

  void set(string newValue) {
    // TODO
  }


  void value(this O)(string newValue) {
    this.set(newValue);
    return cast(O)this;
  }

  void value(this O)(Json newValue) {
    this.set(newValue);
    return cast(O)this;
  }

  alias opEquals = Object.opEquals;
  bool opEquals(string equalValue) {
    return (toString == equalValue);
  }
  bool opEquals(DData equalValue) {
    return (toString == equalValue.toString);
  }
  bool opEquals(UUID equalValue) {
    return false;
  }
  
  O opCall(this O)(DAttribute newAttribute) {
    this.attribute(newAttribute);
    return cast(O)this;
  }
  O opCall(this O)(Json newData) {
    this.fromJson(newData);
    return cast(O)this;
  }
  O opCall(this O)(DAttribute newAttribute, Json newData) {
    this.attribute(newAttribute).fromJson(newData);
    return cast(O)this;
  }

  abstract DData copy(); 
  abstract DData dup(); 

  Json toJson() {
    return Json(null); }

  override string toString() { 
    return null; 
  }
  
  void fromString(string newValue) { }
}

version(test_uim_models) { unittest {   
    autvoid value = new DData;
    assert(!value.isNull);
    assert(!value.isString);
    assert(!value.isInteger);
    assert(!value.isBoolean);
    assert(!value.isDouble);
    assert(!value.isNullable);
    assert(!value.isObject);
    assert(!value.isArray);
}}
