/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.object_;

import uim.models;

@safe:
class DJsonObjectValue : DValue {
  mixin(ValueThis!("JsonObjectValue"));  

  mixin(OProperty!("Json", "value"));

  O value(this O)(string newValue) {
    this.value(parseJsonString(newValue));
    return cast(O)this;
  }

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    _value = Json.emptyObject;
    this
      .isObject(true);
  }

  override DValue copy() {
    return JsonObjectValue(attribute, toJson);
  }
  override DValue dup() {
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
