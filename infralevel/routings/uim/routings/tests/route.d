module uim.routings.tests.route;

import uim.routings;
@safe:

unittest { 
  version(test_uim_routings) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

bool testRoute(IRoute obj) {
    assert(obj !is null);
    
    return true;
}