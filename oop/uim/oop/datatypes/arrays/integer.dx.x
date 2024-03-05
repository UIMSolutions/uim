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
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    isInteger(true);

    return true;
  }

  protected int[] _value;
  int[] get() {
    return _value;
  }
  void set(int[] newValue) {
    _value = newValue;
  }

  alias opEquals = DData.opEquals;
  
  override IData clone() {
    return IntegerArrayData; // TODO (attribute, toJson);
  }
}
mixin(DataCalls!("IntegerArrayData"));  
