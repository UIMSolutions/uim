module uim.routings.tests.middleware;

import uim.routings;
@safe: 

bool testRoutingMiddleware(IRoutingMiddleware obj) {
    assert(obj !is null);
    
    return true;
}