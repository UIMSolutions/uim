/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.classes.tenants.tenant;

import uim.jsonbases;

unittest { 
  version(test_uim_jsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DJsonTenant : UIMObject, IJsonTenant, IJsonCollectionManager {
  mixin(JsonTenantThis!());
  this(IJsonBase aBase, Json[string] initData = null) { this(initData); this.base(aBase); }
  this(IJsonBase aBase, string aName, Json[string] initData = null) { this(aBase); this.name(aName); }

  // #region Properties 
    mixin(TProperty!("string", "classname"));
    mixin(TProperty!("IJsonBase", "base"));
  // #endregion Properties

  mixin TJsonCollectionManager!();
}

unittest {
  version(test_uim_jsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}