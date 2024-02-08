/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.integers.string_;

import uim.models;

@safe:
class DIntegerStringAttribute : DLookupAttribute {
  mixin(AttributeThis!("IntegerStringAttribute"));

  mixin(TProperty!("string[int]", "lookups"));
  void addLookup(int key, string value) {
    _lookups[key] = value;

  }

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }
    // means.measurement.lookup

    name("lookup");
    dataFormats(["lookup", "integer", "string"]);
    registerPath("lookup");

    return true;
  }

  bool hasLookupKey(int key) {
    return (key in _lookups ? true : false);
  }

  bool hasLookupValue(string lookupValue) {
    foreach (k, v; _lookups) {
      if (v == lookupValue) {
        return true;
      }
    }
    return false;
  }

  /* override IData createData() {
    return LookupValue!(int, string)(this).isNullable(isNullable); }  */
}

mixin(AttributeCalls!("IntegerStringAttribute"));

version (test_uim_models) {
  unittest {
    // TODO tests
  }
}
