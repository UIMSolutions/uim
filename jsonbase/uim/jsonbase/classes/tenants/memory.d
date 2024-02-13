module uim.jsonbase.classes.tenants.memory;

import uim.jsonbase;

version(testUimJsonbase) { 
  unittest {
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}

@safe:
/// MemoryTenant manages MemoryCollections
class DMemoryJsonTenant : DJsonTenant {
  mixin(JsonTenantThis!("MemoryJsonTenant"));
}
mixin(JsonTenantCalls!("MemoryJsonTenant"));
