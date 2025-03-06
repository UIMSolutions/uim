module uim.routings.tests.plugin;

import uim.routings;
@safe:

unittest { 
  version(test_uim_routings) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

bool testRoutingPlugin(IRoutingPlugin obj) {
    assert(obj !is null);
    
    return true;
}