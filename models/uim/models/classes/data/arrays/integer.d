/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.arrays.integer;

import uim.models;

@safe:
class DIntegerArrayData : DArrayData {
  mixin(DataThis!("IntegerArrayData", "int[]"));  

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    nameisInteger(true);
  }

  protected int[] _value;
  alias value = DData.value;
  void set(int[] newValue) {
    _value = newValue;
  }
  void value(int[] newValue) {
    this.set(newValue);
     
  }
  int[] value() {
    return _value; 
  }

  alias opEquals = DData.opEquals;
  
  override IData clone() {
    return IntegerArrayData(attribute, toJson);
  }
}
mixin(ValueCalls!("IntegerArrayData"));  
