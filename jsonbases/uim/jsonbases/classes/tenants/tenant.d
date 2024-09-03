module uim.jsonbases.classes.tenants.tenant;

import uim.jsonbases;

unittest { 
  version(testUimJsonbase) { 
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
mixin(JsonTenantCalls!("JsonTenant"));

unittest {
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}