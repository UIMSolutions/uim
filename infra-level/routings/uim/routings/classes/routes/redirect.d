module uim.routings.classes.routes.redirect;

import uim.routings;

@safe:
/**
 * Redirect route will perform an immediate redirect. Redirect routes
 * are useful when you want to have Routing layer redirects occur in your
 * application, for when URLs move.
 *
 * Redirection is signalled by an exception that halts route matching and
 * defines the redirect URL and status code.
 */
class DRedirectRoute : DRoute {
    mixin(RouteThis!("Redirect"));

    // The location to redirect to.
    Json[string] _redirect;
}

mixin(RouteCalls!("Redirect"));

unittest {
    assert(testRoute(new DRedirectRoute));
}
