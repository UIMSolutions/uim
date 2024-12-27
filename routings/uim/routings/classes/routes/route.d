module uim.routings.classes.routes.route;

import uim.routings;

@safe:

class DRoute : UIMObject, IRoute {
    mixin(RouteThis!());

    // An array of additional parameters for the Route.
    Json[string] options = null;

    // Default parameters for a Route
    Json[string] _defaultValues;

    // The routes template string.
    string mytemplate;

    // Is this route a greedy route? Greedy routes have a `/*` in their template
    protected bool _greedy = false;

    // The compiled route regular expression
    protected string _compiledRoute = null;

    // List of connected extensions for this route.
    protected string[] _extensions = null;

    /**
     * An array of named segments in a Route.
     * `/{controller}/{action}/{id}` has 3 key elements
     */
    Json[string] _someKeys = null;

    // List of middleware that should be applied.
    protected Json[string] _middleware = null;

    // Valid HTTP methods.
    const string[] VALID_METHODS = [
        "GET", "PUT", "POST", "PATCH", "DELETE", "OPTIONS", "HEAD"
    ];
}

unittest {
    assert(testRoute(new DRoute));
}
