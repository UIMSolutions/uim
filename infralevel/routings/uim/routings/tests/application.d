module uim.routings.tests.application;

import uim.routings;
@safe:

unittest { 
  version(test_uim_routings) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

bool testRoutingApplication(IRoutingApplication app) {
    assert(app !is null);
    
    return true;
}