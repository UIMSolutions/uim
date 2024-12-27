module uim.routings.classes.middlewares.middleware;

import uim.routings;

@safe:

class DRoutingMiddleware : UIMObject, IRoutingMiddleware {
    mixin(RoutingMiddlewareThis!());

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}