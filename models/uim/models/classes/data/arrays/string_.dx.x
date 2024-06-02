/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
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
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    isString(true);
      separator(",");

      return true;

  }

  mixin(TProperty!("string", "separator"));
  mixin(TProperty!("bool", "shouldTrim"));

  protected string[] _values;
  void set(string[] newValues) {
    _values = newValues.filter!(v => v.length > 0).array;
  }

  override void set(string newValue) {
    auto myValues = newValue.split(separator);
    if (shouldTrim) {
      myValues = myValues.map!(a => a.strip).array;
    } 
    set(myValues);
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) set(cast(string[])null);
    switch(newValue.type) {
      case Json.Type.string: 
        set(newValue.get!string); 
        break;
      case Json.Type.array: 
        set(newValue.get!(Json[]).map!(a => a.get!string).array);
        break; 
      //case Json.Type.object: 
        /* return this.fromJson(newValue); */
        // break; 
      default: break;
    }
    // return this;
  }

  override IData clone() {
    return StringArrayData; // TODO (attribute, toJson);
  }
alias toJson = DData.toJson;
  override Json toJson() {
    auto result = Json.emptyArray;
    _values.each!(v => result ~= Json(v));
    return result;
  }
  override string toString() {
    return get.join(",");
  }
}
mixin(DataCalls!("StringArrayData", "string[]"));  

version(test_uim_models) { unittest {
    auto attribute = StringArrayData(["a", "b", "c"]);
    assert(attribute.get.length == 3);
    assert(attribute.get[0] == "a");
    assert(attribute.get[1] == "b");
}}