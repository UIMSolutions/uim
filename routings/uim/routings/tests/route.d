module uim.routings.tests.route;

import uim.routings;

@safe:

bool testRoute(IRoute routeToTest) {
    assert(routeToTest !is null, "In testRoute: routeToTest is null");
    
    return true;
}