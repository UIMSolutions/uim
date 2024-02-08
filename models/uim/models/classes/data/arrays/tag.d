/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.arrays.tag;

import uim.models;

@safe:
class DTagArrayValue : DStringArrayValue {
  mixin(DataThis!("TagArrayValue", "string[]"));  

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

    this
      .shouldTrim(true)
      .separator("#");
  }

  size_t length() {
    return _values.length;
  }

  alias opEquals = DData.opEquals;

  override IData copy() {
    return TagArrayValue(attribute, toJson);
  }
  override IData dup() {
    return copy;
  }
  
  override string toString() {
    if (length > 0) return separator~this.value.join(separator);
    return null; 
  }
}
mixin(ValueCalls!("TagArrayValue"));  

version(test_uim_models) { unittest {
    auto attribute = TagArrayValue(["a", "b", "c"]);
    assert(attribute.value.length == 3);
    assert(attribute.value[0] == "a");
    assert(attribute.value[1] == "b");
}}