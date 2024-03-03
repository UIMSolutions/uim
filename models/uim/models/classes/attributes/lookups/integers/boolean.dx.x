/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.integers.boolean;

import uim.models;

@safe:
class DIntegerBooleanAttribute : DLookupAttribute {
  mixin(AttributeThis!("IntegerBooleanAttribute"));

  mixin(TProperty!("bool[int]", "lookups"));
  void addLookup(int key, string newValue) {
    _lookups[key] = to!bool(newValue);

  }

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
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

  bool hasLookupData(bool LookupData) {
    foreach (k, v; _lookups) {
      if (v == LookupData) {
        return true;
      }
    }
    return false;
  }

  /* override IData createData() {
    return LookupData!(int, bool)(this).isNullable(isNullable); }  */
}

mixin(AttributeCalls!("IntegerBooleanAttribute"));

version (test_uim_models) {
  unittest {
    // TODO tests
  }
}
