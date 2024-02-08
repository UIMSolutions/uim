/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.object_;

import uim.models;

@safe:
class DJsonObjectData: DData {
  mixin(DataThis!("JsonObjectValue"));  

  mixin(OProperty!("Json", "value"));

  O value(this O)(string newValue) {
    this.value(parseJsonString(newValue));
    return cast(O)this;
  }

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    _value = Json.emptyObject;
    this
      .isObject(true);
  }

  override IData copy() {
    return JsonObjectValue(attribute, toJson);
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
mixin(ValueCalls!("JsonObjectValue"));  
