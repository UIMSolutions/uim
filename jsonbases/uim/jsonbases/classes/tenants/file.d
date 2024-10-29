/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.classes.tenants.file;

import uim.jsonbases;

version(test_uim_jsonbase) { 
  unittest {
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
/// FileJsonTenant manages FileCollections
class DFileJsonTenant : DJsonTenant {
  mixin(JsonTenantThis!("File"));

  // #region hasCollection() 
  override bool hasCollection(string aName) {
    version(test_uim_jsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

    return (aName in _collections ? true : false);
  }
  // #endregion hasCollection() 
}
mixin(JsonTenantCalls!("File"));

unittest {
  version(test_uim_jsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}