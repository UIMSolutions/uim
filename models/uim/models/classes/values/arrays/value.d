/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.arrays.value;

import uim.models;

@safe:
class DValueArrayValue : DArrayValue {
  mixin(ValueThis!("ValueArrayValue", "DValue[]"));  

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isString(true);
  }

  protected DValue[] _value;
  alias value = DValue.value;
  void set(DValue[] newValue) {
    _value = newValue;
  }
  O value(this O)(DValue[] newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  DValue[] value() {
    return _value; 
  }

  alias opEquals = Object.opEquals;
  alias opEquals = DValue.opEquals;

  override DValue copy() {
    return ValueArrayValue(attribute, toJson);
  }
  override DValue dup() {
    return copy;
  }
}
mixin(ValueCalls!("ValueArrayValue", "DValue[]"));  