/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.classes.bases.memory;test_uim_jsonbasetest_uim_jsonbase

import uim.jsonbases;

unittest { 
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DMemoryJsonBase : DJsonBase {
  mixin(JsonBaseThis!("Memory"));

  // Create
  override IJsonTenant createTenant(string aName) {
    addTenant(aName, MemoryJsonTenant(aName));
    return tenant(aName);
  }
}
mixin(JsonBaseCalls!("Memory"));

unittest {
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}