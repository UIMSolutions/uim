/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.arrays.value;

import uim.models;

@safe:
class DDataArrayData : DArrayData {
  mixin(DataThis!("ValueArrayData", "IData[]"));  

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    nameisString(true);
  }

  protected IData[] _value;
  alias value = DData.value;
  void set(IData[] newValue) {
    _value = newValue;
  }
  void value(IData[] newValue) {
    this.set(newValue);
     
  }
  IData[] value() {
    return _value; 
  }

  alias opEquals = Object.opEquals;
  alias opEquals = DData.opEquals;

  override IData clone() {
    return ValueArrayData(attribute, toJson);
  }
}
mixin(ValueCalls!("ValueArrayData", "IData[]"));  