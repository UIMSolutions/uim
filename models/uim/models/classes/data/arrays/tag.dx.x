/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.arrays.tag;

import uim.models;

@safe:
class DTagArrayData : DStringArrayData {
  mixin(DataThis!("TagArray"));  

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    shouldTrim(true);
    separator("#");

    return true;
  }

  /* size_t length() {
    return _values.length;
  } */

  alias opEquals = DData.opEquals;

  override IData clone() {
    return TagArrayData; // TODO (attribute, toJson);
  }
  
  override string toString() {
    if (length == 0) return null; 
    
    return separator~
      get.map!(d => d.toString).join(separator);
  }
}
mixin(DataCalls!("TagArray"));  

version(test_uim_models) { unittest {
    auto attribute = TagArrayData(["a", "b", "c"]);
  // TODO assert(attribute.get.length == 3);
  // TODO assert(attribute.get[0] == "a");
  // TODO assert(attribute.get[1] == "b");
}}