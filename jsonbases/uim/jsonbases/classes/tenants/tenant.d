module uim.jsonbases.classes.tenants.tenant;

import uim.jsonbases;

unittest { 
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DJsonTenant : IJsonTenant, IJsonCollectionManager {
  this() { initialize; this.classname("JsonTenant"); }
  this(IJsonBase aBase) { this(); this.base(aBase); }
  this(string aName) { this(); this.name(aName); }
  this(IJsonBase aBase, string aName) { this(aBase); this.name(aName); }

    // Hook method
    bool initialize(Json[string] initData = null) {
        //TODO configuration(MemoryConfiguration);
        //TODO configuration.data(initData);

        return true;
    }

  // #region Properties 
    mixin(TProperty!("string", "classname"));
    mixin(TProperty!("string", "name"));
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