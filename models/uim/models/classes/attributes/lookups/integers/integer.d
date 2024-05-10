/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.integers.integer;

import uim.models;

@safe:
class DIntegerIntegerAttribute : DLookupAttribute {
  mixin(AttributeThis!("IntegerInteger"));

  mixin(TProperty!("int[int]", "lookups"));  
  void addLookup(int key, string newValue) {
    _lookups[key] = to!int(newValue);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }
    // means.measurement.lookup

    name("lookup");
    dataFormats(["lookup", "integer", "string"]);
    registerPath("lookup");

    return true;
  }

  bool hasLookupKey(int key) {
    return (key in _lookups ? true : false); 
  }
  bool hasLookupData(int LookupData) {
    foreach(k, v; _lookups) { if (v == LookupData) { return true; } }
    return false; 
  }  

  /* override Json createData() {
    return LookupData!(int, int)(this).isNullable(isNullable); }  */
}
mixin(AttributeCalls!("IntegerInteger"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}