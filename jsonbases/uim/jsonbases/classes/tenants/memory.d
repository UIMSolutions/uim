/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.classes.tenants.memory;

import uim.jsonbases;

version(test_uim_jsonbase) { 
  unittest {
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
/// MemoryTenant manages MemoryCollections
class DMemoryJsonTenant : DJsonTenant {
  mixin(JsonTenantThis!("Memory"));
}
mixin(JsonTenantCalls!("Memory"));

unittest {
  testJsonTenant(MemoryJsonTenant);
}