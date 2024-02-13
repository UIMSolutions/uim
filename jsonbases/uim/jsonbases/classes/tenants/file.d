module uim.jsonbases.classes.tenants.file;

import uim.jsonbases;

version(testUimJsonbase) { 
  unittest {
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}

@safe:
/// FileJsonTenant manages FileCollections
class DFileJsonTenant : DJsonTenant {
  mixin(JsonTenantThis!("FileJsonTenant"));

  // #region hasCollection() 
  override bool hasCollection(string aName) {
    version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

    return (aName in _collections ? true : false);
  }
  // #endregion hasCollection() 
}
mixin(JsonTenantCalls!("FileJsonTenant"));

unittest {
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}