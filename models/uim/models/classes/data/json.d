/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.json;

import uim.models;

@safe:
class DJsonData : DData {
  mixin(DataThis!("JsonData"));  

  mixin(OProperty!("Json", "value"));

  void value(this O)(string newValue) {
    this.value(parseJsonString(newValue));
    return cast(O)this;
  }

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

    _value = Json.emptyObject;
    this
      .isObject(true);
  }

  override IData copy() {
    return JsonData(attribute, toJson);
  }
  override IData dup() {
    return copy;
  }
  
  override Json toJson() {
    if (isNull) return Json(null);
    return _value; }

  override string toString() { 
    if (isNull) return null; 
    return _value.toString;
  }

  override void fromString(string newValue) { 
    this.value(newValue);
  }
}
mixin(ValueCalls!("JsonData"));  
