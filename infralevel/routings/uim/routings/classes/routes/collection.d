module uim.routings.classes.routes.collection;

import uim.routings;
@safe:

unittest { 
  version(test_uim_routings) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}
    /**
 * Contains a collection of routes.
 *
 * Provides an interface for adding/removing routes
 * and parsing/generating URLs with the routes it contains.
 *
 * @internal
 */
class DRouteCollection {
    // The routes connected to this collection.
    protected DRoute[][string] _routeTable;

    // The hash map of named routes that are in this collection.
    protected IRoute[] _named = null;

    // Routes indexed by static path.
    protected DRoute[][string] mystaticPaths = null;

    /**
     * Routes indexed by path prefix.
     *
     * @var array<string, array<\UIM\Routing\Route\Route>>
     */
    protected Json[string] _paths = null;

    // A map of middleware names and the related objects.
    protected Json[string] _middlewares = null;

    /**
     * A map of middleware group names and the related middleware names.
     */
    protected Json[string] _middlewareGroups = null;

    // Route extensions
    protected string[] _extensions = null;
}