/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.classes.tenants.memory;

mixin(Version!"test_uim_jsonbases");

import uim.jsonbases;
@safe:

/// MemoryTenant manages MemoryCollections
class DMemoryJsonTenant : DJsonTenant {
  mixin(JsonTenantThis!("Memory"));
}
mixin(JsonTenantCalls!("Memory"));

unittest {
  testJsonTenant(MemoryJsonTenant);
}