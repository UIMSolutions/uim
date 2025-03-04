module uim.routings.classes.routes.entity;

import uim.routings;

@safe:
/**
 * Matches entities to routes
 *
 * This route will match by entity and map its fields to the URL pattern by
 * comparing the field names with the template vars. This makes it easy and
 * convenient to change routes globally.
 */

class DEntityRoute : DRoute {
    mixin(RouteThis!("Entity"));
}
mixin(RouteCalls!("Entity"));

unittest {
    assert(testRoute(new DEntityRoute));
}