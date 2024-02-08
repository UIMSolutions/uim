/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.arrays.integer;

import uim.models;

@safe:
class DIntegerArrayValue : DArrayValue {
  mixin(ValueThis!("IntegerArrayValue", "int[]"));  

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isInteger(true);
  }

  protected int[] _value;
  alias value = DValue.value;
  void set(int[] newValue) {
    _value = newValue;
  }
  O value(this O)(int[] newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  int[] value() {
    return _value; 
  }

  alias opEquals = DValue.opEquals;
  
  override DValue copy() {
    return IntegerArrayValue(attribute, toJson);
  }
  override DValue dup() {
    return copy;
  }
}
mixin(ValueCalls!("IntegerArrayValue"));  
