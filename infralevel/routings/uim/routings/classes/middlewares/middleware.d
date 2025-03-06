module uim.routings.classes.middlewares.middleware;

import uim.routings;
@safe:

unittest { 
  version(test_uim_routings) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

class DRoutingMiddleware : UIMObject, IRoutingMiddleware {
    mixin(RoutingMiddlewareThis!());

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}