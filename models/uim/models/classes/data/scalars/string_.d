/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.string_;

import uim.models;

@safe:
class DStringData : DData {
  mixin(DataThis!("StringData"));  
    // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .isString(true);
  }

  mixin(OProperty!("size_t", "maxLength"));

  protected string _value;
  @property string value(){
    if (maxLength > 0 && _value.length > maxLength) {
      return _value[0..maxLength]; }
    else {
      return _value;
    }
  }
  /// Set with string value
  void value(this O)(string newValue) {
    set(newValue);
    return cast(O)this;
  }
  ///
  unittest {    
    assert(StringData.value("test").value == "test");
    assert(StringData.value("test").value("test2").value == "test2");
  } 

  // Set with Json value
  void value(this O)(Json newValue) {
    set(newValue);
    return cast(O)this;
  }

  // Hooks for setting 
  override protected void set(string newValue) {
    if (newValue is null) { 
      this.isNull(isNullable ? true : false); }
    else {
      this.isNull(false);
    }
    _value = newValue;
  } 

  override protected void set(Json newValue) {
    if (newValue.isEmpty) { 
      _value = null; 
      this.isNull(isNullable ? true : false); }
    else {
      _value = newValue.get!string;
      this.isNull(false);
    }
  }

  void value(this O)(DStringData newValue) {
    if (newValue) {
      this
        .isNullable(newValue.isNullable)
        .isNull(newValue.isNull)
        .value(newValue.value);
    }
    return cast(O)this;
  }

  override IData copy() {
    return StringData(attribute, toJson);
  }
  override IData dup() {
    return copy;
  }

  version(test_uim_models) { unittest {    
    assert(StringData("test").value == "test");

    assert(StringData.value("test") == "test");
    assert(StringData.value("test") < "xxxx");
    assert(StringData.value("test") <= "xxxx");
    assert(StringData.value("test") <= "test");
    assert(StringData.value("test") > "aaaa");
    assert(StringData.value("test") >= "aaaa");
    assert(StringData.value("test") >= "test");    
  }}

  string opCall() { return _value; } 
  O opCall(this O)(string newValue) { 
    _value = newValue;
    return cast(O)this; }
  O opCall(this O)(Json newValue) { 
    if (newValue.type = Json.Type.string) _value = newValue.get!string;
    return cast(O)this; }
  O opCall(this O)(DStringData newValue) {
    this.value(newValue);
    return cast(O)this; }

  ///
  unittest { 
    auto a = StringData("aValue");
    auto b = StringData("bValue");
    assert(a(b) == "bValue");
  }

  alias opEquals = DData.opEquals;
  override bool opEquals(string otherValue) {
    return (_value == otherValue);
  }

  int opCmp(string otherValue) {
    if (_value < otherValue) return -1;
    if (_value == otherValue) return 0;
    return 1;
  }
  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(_value); }
  
  override string toString() { 
    if (isNull) return null; 
    return _value; }

  override void fromString(string newValue) { 
    this.value(newValue);
  }  
}
mixin(ValueCalls!("StringData"));  

version(test_uim_models) { unittest {    
  assert(StringData("test") == "test");
  assert(StringData("test") < "xxxx");
  assert(StringData("test") <= "xxxx");
  assert(StringData("test") <= "test");
  assert(StringData("test") > "aaaa");
  assert(StringData("test") >= "aaaa");
  assert(StringData("test") >= "test");

  assert(StringData()("test") == "test");
  assert(StringData()("test") < "xxxx");
  assert(StringData()("test") <= "xxxx");
  assert(StringData()("test") <= "test");
  assert(StringData()("test") > "aaaa");
  assert(StringData()("test") >= "aaaa");
  assert(StringData()("test") >= "test");   

  assert(StringData("test").value == "test");
  assert(StringData("test2").value != "test");

  assert(StringData(Json("test")).value == "test");
  assert(StringData(Json("test2")).value != "test");

  assert(StringData.value("test").value == "test");
  assert(StringData.value("test2").value != "test");

  assert(StringData.value(Json("test")).value == "test");
  assert(StringData.value(Json("test2")).value != "test");

  assert(StringData("test").toString == "test");
  assert(StringData("test2").toString != "test");

  assert(StringData(Json("test")).toString == "test");
  assert(StringData(Json("test2")).toString != "test");

  assert(StringData.value("test").toString == "test");
  assert(StringData.value("test2").toString != "test");

  assert(StringData.value(Json("test")).toString == "test");
  assert(StringData.value(Json("test2")).toString != "test");

  assert(StringData("test").toJson == Json("test"));
  assert(StringData("test2").toJson != Json("test"));

  assert(StringData(Json("test")).toJson == Json("test"));
  assert(StringData(Json("test2")).toJson != Json("test"));

  assert(StringData.value("test").toJson == Json("test"));
  assert(StringData.value("test2").toJson != Json("test"));

  assert(StringData.value(Json("test")).toJson == Json("test"));
  assert(StringData.value(Json("test2")).toJson != Json("test"));
}} 