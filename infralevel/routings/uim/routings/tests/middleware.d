module uim.routings.tests.middleware;

import uim.routings;
@safe:

unittest { 
  version(test_uim_routings) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

bool testRoutingMiddleware(IRoutingMiddleware obj) {
    assert(obj !is null);
    
    return true;
}