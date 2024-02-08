/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.integers.integer;

import uim.models;

@safe:
class DIntegerIntegerAttribute : DLookupAttribute {
  mixin(AttributeThis!("IntegerIntegerAttribute"));

  mixin(OProperty!("int[int]", "lookups"));  
  O addLookup(this O)(int key, string value) {
    _lookups[key] = value;
    return cast(O)this;
  }

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);
    // means.measurement.lookup

    this
      .name("lookup")
      .dataFormats(["lookup", "integer", "string"])
      .registerPath("lookup");
  }

  bool hasLookupKey(int key) {
    return (key in _lookups ? true : false); 
  }
  bool hasLookupValue(int lookupValue) {
    foreach(k, v; _lookups) { if (v == lookupValue) { return true; } }
    return false; 
  }  

  override DData createValue() {
    return LookupValue!(int, int)(this).isNullable(isNullable); }  
}
mixin(AttributeCalls!("IntegerIntegerAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}