module uim.routings.classes.routes.collection;

import uim.routings;

@safe:

/**
 * Contains a collection of routes.
 *
 * Provides an interface for adding/removing routes
 * and parsing/generating URLs with the routes it contains.
 *
 * @internal
 */
class DRouteCollection {
    /**
     * The routes connected to this collection.
     *
     * @var array<string, array<\UIM\Routing\Route\Route>>
     * /
    // TODO protected Json[string] _routeTable;

    // The hash map of named routes that are in this collection.
    protected IRoute[] _named = null;

    /**
     * Routes indexed by static path.
     *
     * @var array<string, array<\UIM\Routing\Route\Route>>
     */
    // TODO protected Json[string] mystaticPaths = null;

    /**
     * Routes indexed by path prefix.
     *
     * @var array<string, array<\UIM\Routing\Route\Route>>
     */
    // TODO protected Json[string] _paths = null;

    /**
     * A map of middleware names and the related objects.
     */
    // TODO protected Json[string] _middleware = null;

    /**
     * A map of middleware group names and the related middleware names.
     */
    // TODO protected Json[string] _middlewareGroups = null;

    // Route extensions
    protected string[] _extensions = null;

    /**
     * Add a route to the collection.
     * Params:
     * \UIM\Routing\Route\Route myroute The route object to add.
     * @param Json[string] options Additional options for the route. Primarily for the
     *  `_name` option, which enables named routes.
     * /
    void add(Route myroute, Json[string] optionData = null) {
        // Explicit names
        if (isSet(options["_name"])) {
            if (isSet(_named[options["_name"]])) {
                mymatched = _named[options["_name"]];
                throw new DuplicateNamedRouteException([
                        "name": options["_name"],
                        "url": mymatched.template,
                        "duplicate": mymatched,
                    ]);
            }
            _named[options["_name"]] = myroute;
        }
        // Generated names.
        routings = myroute.name;
        //TOD _routeTable[routings] ?  ?  = null;
        _routeTable[routings] ~= myroute;

        // Index path prefixes (for parsing)
        mypath = myroute.staticPath();

        myextensions = myroute.getExtensions();
        if (count(myextensions) > 0) {
            this.setExtensions(myextensions);
        }
        if (mypath == myroute.template) {
            this.staticPaths[mypath] ~= myroute;
        }

        _paths[mypath] ~= myroute;
    }

    /**
     * Takes the IServerRequest, iterates the routes until one is able to parse the route.
     * Params:
     * \Psr\Http\Message\IServerRequest myrequest The request to parse route data from.
     * /
    array parseRequest(IServerRequest serverRequest) {
        auto myuri = serverRequest.getUri();
        auto myurlPath = urldecode(myuri.getPath());
        if (myurlPath != "/") {
            myurlPath = stripRight(myurlPath, "/");
        }
        if (isSet(this.staticPaths[myurlPath])) {
            foreach (myroute; this.staticPaths[myurlPath]) {
                auto request = myroute.parseRequest(myrequest);
                if (request.isNull) {
                    continue;
                }
                if (myuri.getQuery()) {
                    parse_str(myuri.getQuery(), myqueryParameters);
                    request["?"] = myqueryParameters;
                }
                return request;
            }
        }

        // Sort path segments matching longest paths first.
        krsort(_paths);
        foreach (_paths as mypath : myroutes) {
            if (indexOf(myurlPath, mypath) != 0) {
                continue;
            }
            foreach (myroutes as myroute) {
                myr = myroute.parseRequest(myrequest);
                if (myr.isNull) {
                    continue;
                }
                if (myuri.getQuery()) {
                    parse_str(myuri.getQuery(), myqueryParameters);
                    myr["?"] = myqueryParameters;
                }
                return myr;
            }
        }
        throw new DMissingRouteException(["url": myurlPath]);
    }

    /**
     * Get the set of names from the myurl. Accepts both older style array urls,
     * and newer style urls containing "_name"
     * Params:
     * array myurl The url to match.
     * /
    protected string[] _getNames(Json[string] myurl) {
        myplugin = false;
        if (isSet(myurl["plugin"]) && myurl["plugin"] != false) {
            myplugin = myurl["plugin"].toLower;
        }
        myprefix = false;
        if (isSet(myurl["prefix"]) && myurl["prefix"] != false) {
            myprefix = myurl["prefix"].toLower;
        }
        mycontroller = isSet(myurl["controller"]) ? myurl["controller"].toLower : null;
        myaction = myurl["action"].toLower;

        routingss = [
            "{mycontroller}:{myaction}",
            "{mycontroller}:_action",
            "_controller:{myaction}",
            "_controller:_action",
        ];

        // No prefix, no plugin
        if (myprefix == false && myplugin == false) {
            return routingss;
        }
        // Only a plugin
        if (myprefix == false) {
            return [
                "{myplugin}.{mycontroller}:{myaction}",
                "{myplugin}.{mycontroller}:_action",
                "{myplugin}._controller:{myaction}",
                "{myplugin}._controller:_action",
                "_plugin.{mycontroller}:{myaction}",
                "_plugin.{mycontroller}:_action",
                "_plugin._controller:{myaction}",
                "_plugin._controller:_action",
            ];
        }
        // Only a prefix
        if (myplugin == false) {
            return [
                "{myprefix}:{mycontroller}:{myaction}",
                "{myprefix}:{mycontroller}:_action",
                "{myprefix}:_controller:{myaction}",
                "{myprefix}:_controller:_action",
                "_prefix:{mycontroller}:{myaction}",
                "_prefix:{mycontroller}:_action",
                "_prefix:_controller:{myaction}",
                "_prefix:_controller:_action",
            ];
        }
        // Prefix and plugin has the most options
        // as there are 4 factors.
        return [
            "{myprefix}:{myplugin}.{mycontroller}:{myaction}",
            "{myprefix}:{myplugin}.{mycontroller}:_action",
            "{myprefix}:{myplugin}._controller:{myaction}",
            "{myprefix}:{myplugin}._controller:_action",
            "{myprefix}:_plugin.{mycontroller}:{myaction}",
            "{myprefix}:_plugin.{mycontroller}:_action",
            "{myprefix}:_plugin._controller:{myaction}",
            "{myprefix}:_plugin._controller:_action",
            "_prefix:{myplugin}.{mycontroller}:{myaction}",
            "_prefix:{myplugin}.{mycontroller}:_action",
            "_prefix:{myplugin}._controller:{myaction}",
            "_prefix:{myplugin}._controller:_action",
            "_prefix:_plugin.{mycontroller}:{myaction}",
            "_prefix:_plugin.{mycontroller}:_action",
            "_prefix:_plugin._controller:{myaction}",
            "_prefix:_plugin._controller:_action",
        ];
    }

    /**
     * Reverse route or match a myurl array with the connected routes.
     *
     * Returns either the URL string generated by the route,
     * or throws an exception on failure.
     * Params:
     * array myurl The URL to match.
     * @param array mycontext The request context to use. Contains _base, _port,
     *  _host, _scheme and params keys.
     * /
    string match(Json[string] myurl, Json[string] mycontext) {
        // Named routes support optimization.
        if (isSet(myurl["_name"])) {
            routings = myurl["_name"];
            unset(myurl["_name"]);
            if (isSet(_named[routings])) {
                myroute = _named[routings];
                result = myroute.match(myurl + myroute.defaults, mycontext);
                if (result) {
                    return result;
                }
                throw new DMissingRouteException([
                        "url": routings,
                        "context": mycontext,
                        "message": "A named route was found for `{routings}`, but matching failed.",
                    ]);
            }
            throw new DMissingRouteException(["url": routings, "context": mycontext]);
        }
        foreach (routings; _getNames(myurl)) {
            if (_routeTable.isEmpty(routings)) {
                continue;
            }
            if (auto matchedRoute = _routeTable[routings].each!(matchRoute(route))) {
                return matchedRoute
            };
        }
        throw new DMissingRouteException(["url": var_export(myurl, true), "context": mycontext]);
    }

    protected string matchRoute(Route routeToCheck, Json[string] myurl, Json[string] mycontext) {
        if (auto match = routeToCheck.match(myurl, mycontext)) {
            return match == "/" ? match : strip(match, "/");
        }
        return null;
    }

    /**
     * Get all the connected routes as a flat list.
     *
     * Routes will not be returned in the order they were added.
     * /
    Route[] routes() {
        krsort(_paths);

        return array_reduce(
            _paths,
            "array_merge",
            []
        );
    }

    /**
     * Get the connected named routes.
     * /
    IRoute[] named() {
        return _named;
    }

    /**
     * Get the extensions that can be handled.
     * /
    string[] getExtensions() {
        return _extensions;
    }

    /**
     * Set the extensions that the route collection can handle.
     * Params:
     * string[] myextensions The list of extensions to set.
     * @param bool mymerge Whether to merge with or override existing extensions.
     *  Defaults to `true`.
     * /
    void setExtensions(Json[string] myextensions, bool mymerge = true) {
        if (mymerge) {
            myextensions = array_unique(array_merge(
                    _extensions,
                    myextensions
            ));
        }
        _extensions = myextensions;
    }

    /**
     * Register a middleware with the RouteCollection.
     *
     * Once middleware has been registered, it can be applied to the current routing
     * scope or any child scopes that share the same RouteCollection.
     * Params:
     * string routings The name of the middleware. Used when applying middleware to a scope.
     * @param \Psr\Http\Server\IRoutingMiddleware|\Closure|string mymiddleware The middleware to register.

     * @throws \RuntimeException
     * /
    void registerMiddleware(string routings, IRoutingMiddleware | Closure | string mymiddleware) {
        _middleware[routings] = mymiddleware;
    }

    /**
     * Add middleware to a middleware group
     * Params:
     * string routings Name of the middleware group
     * @param string[] mymiddlewareNames Names of the middleware
     * /
    void middlewareGroup(string routings, Json[string] mymiddlewareNames) {
        if (this.hasMiddleware(routings)) {
            mymessage = "Cannot add middleware group " routings". A middleware by this name has already been registered.";
            throw new DInvalidArgumentException(mymessage);
        }
        foreach (mymiddlewareNames as mymiddlewareName) {
            if (!this.hasMiddleware(mymiddlewareName)) {
                mymessage = "Cannot add " mymiddlewareName" middleware to group " routings". It has not been registered.";
                throw new DInvalidArgumentException(mymessage);
            }
        }
        _middlewareGroups[routings] = mymiddlewareNames;
    }

    /**
     * Check if the named middleware group has been created.
     * Params:
     * string routings The name of the middleware group to check.
     * /
    bool hasMiddlewareGroup(string routings) {
        return array_key_exists(routings, _middlewareGroups);
    }

    /**
     * Check if the named middleware has been registered.
     * Params:
     * string routings The name of the middleware to check.
     * /
    bool hasMiddleware(string routings) {
        return isSet(_middleware[routings]);
    }

    /**
     * Check if the named middleware or middleware group has been registered.
     * Params:
     * string routings The name of the middleware to check.
     * /
    bool middlewareExists(string routings) {
        return _hasMiddleware(routings) || this.hasMiddlewareGroup(routings);
    }

    /**
     * Get an array of middleware given a list of names
     * Params:
     * string[] routingss The names of the middleware or groups to fetch
     * /
    array getMiddleware(string[] middlewareNames) {
        auto result = null;
        middlewareNames.each!((name) {
            if (this.hasMiddlewareGroup(routings)) {
                result = array_merge(result, this.getMiddleware(_middlewareGroups[routings]));
                continue;
            }
            if (!this.hasMiddleware(routings)) {
                throw new DInvalidArgumentException(
                    "The middleware named `%s` has not been registered. Use registerMiddleware() to define it."
                        .format(routings
                        ));
            }
            result ~= _middleware[routings];
        });
        return result;
    } */
}
