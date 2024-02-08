/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.arrays.string_;

import uim.models;

@safe:
class DStringArrayData : DArrayData {
  mixin(DataThis!("StringArrayData", "string[]"));  
  this(DStringArrayData ArrayData) {
    this().add(ArrayData.values);
  }

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    isString(true);
      separator(",");

      return true;

  }

  mixin(TProperty!("string", "separator"));
  mixin(TProperty!("bool", "shouldTrim"));

  protected string[] _values;
  alias value = DData.value;
  void set(string[] newValues) {
    _values = newValues.filter!(v => v.length > 0).array;
  }
  void value(string[] newValue) {
    this.set(newValue);
     
  }
  string[] value() {
    return _values; 
  }

  override void set(string newValue) {
    auto myValues = newValue.split(separator);
    if (shouldTrim) {
      myValues = myValues.map!(a => a.strip).array;
    } 
    this.value(myValues);
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) this.value(cast(string[])null);
    switch(newValue.type) {
      case Json.Type.string: 
        /* return  */this.value(newValue.get!string); 
        break;
      case Json.Type.array: 
        /* return  */this.value(newValue.get!(Json[]).map!(a => a.get!string).array);
        break; 
      //case Json.Type.object: 
        /* return  this.fromJson(newValue); */
        // break; 
      default: break;
    }
    // return this;
  }

  override IData clone() {
    return StringArrayData(attribute, toJson);
  }

  override Json toJson() {
    auto result = Json.emptyArray;
    _values.each!(v => result ~= Json(v));
    return result;
  }
  override string toString() {
    return this.value.join(",");
  }
}
mixin(ValueCalls!("StringArrayData", "string[]"));  

version(test_uim_models) { unittest {
    auto attribute = StringArrayData(["a", "b", "c"]);
    assert(attribute.value.length == 3);
    assert(attribute.value[0] == "a");
    assert(attribute.value[1] == "b");
}}