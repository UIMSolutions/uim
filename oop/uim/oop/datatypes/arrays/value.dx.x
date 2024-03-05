/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.datatypes.arrays.value;

import uim.oop;

@safe:
class DArrayDataData : DArrayData {
  mixin(DataThis!("ArrayDataData", "IData[]"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isString(true);

    return true;
  }

/*
  // #region Getter & Setter
    protected IData[] _value;
    IData[] get() {
      return _value;
    }
    void set(IData[] newValue) {
      _value = newValue;
    }
    mixin(DataGetSetTemplate!("null", "IData[]"));
  // #endregion Getter & Setter 

  mixin DataConvertTemplate;
*/
  alias opEquals = Object.opEquals;
  alias opEquals = DData.opEquals;

  override IData clone() {
    return ArrayData; // TODO (attribute, toJson);
  }
}

mixin(DataCalls!("ArrayDataData", "IData[]"));
