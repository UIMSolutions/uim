module uim.jsonbases.classes.bases.memory;

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