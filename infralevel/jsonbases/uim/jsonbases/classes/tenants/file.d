/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.classes.tenants.file;

mixin(Version!"test_uim_jsonbases");

import uim.jsonbases;
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