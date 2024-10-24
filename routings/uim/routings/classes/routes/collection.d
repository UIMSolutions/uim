/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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

    /**
     * Add a route to the collection.
     * Params:
     * \UIM\Routing\Route\Route route The route object to add.
     */
    void add(DRoute route, Json[string] options = null) {
        // Explicit names
        /* if (options.hasKey("_name")) {
            if (_named.hasKey(options.getString("_name"))) {
                mymatched = _named[options.getString("_name")];
                throw new DuplicateNamedRouteException([
                        "name": options.get("_name"],
                        "url": mymatched.template,
                        "duplicate": mymatched,
                    ]);
            }
            _named[options.getString("_name")] = route;
        }
        // Generated names.
        auto routings = route.name;
        //TOD _routeTable[routings] ?  ? = null;
        _routeTable[routings).concat( route;

        // Index path prefixes (for parsing)
        auto mypath = route.staticPath();
        auto extensions = route.getExtensions();
        if (count(extensions) > 0) {
            setExtensions(extensions);
        }
        if (mypath == route.template) {
            this.staticPaths[mypath).concat( route;
        }

        _paths[mypath).concat( route; */
    }

    // Takes the IServerRequest, iterates the routes until one is able to parse the route.
    Json[string] parseRequest(IServerRequest serverRequest) {
        auto myuri = serverRequest.getUri();
        auto myurlPath = urldecode(myuri.path());
        if (myurlPath != "/") {
            myurlPath = stripRight(myurlPath, "/");
        }
        if (isSet(this.staticPaths[myurlPath])) {
            foreach (route; this.staticPaths[myurlPath]) {
                auto request = route.parseRequest(myrequest);
                if (request.isNull) {
                    continue;
                }
                if (myuri.getQuery()) {
                    parse_str(myuri.getQuery(), myQueryParameters);
                    request["?"] = myQueryParameters;
                }
                return request;
            }
        }

        // Sort path segments matching longest paths first.
        krsort(_paths);
        foreach (mypath, myroutes; _paths) {
            if (indexOf(myurlPath, mypath) != 0) {
                continue;
            }
            foreach (route; myroutes) {
                myr = route.parseRequest(myrequest);
                if (myr.isNull) {
                    continue;
                }
                if (myuri.getQuery()) {
                    parse_str(myuri.getQuery(), myQueryParameters);
                    myr["?"] = myQueryParameters;
                }
                return myr;
            }
        }
        throw new DMissingRouteException(["url": myurlPath]);
    }

    /**
     * Get the set of names from the url. Accepts both older style array urls,
     * and newer style urls containing "_name"
     * Params:
     * Json[string] url The url to match.
     */
    protected string[] _getNames(Json[string] url) {
        string myplugin;
        if (url.hasKey("plugin") && url["plugin"] == true) {
            myplugin = url.getString("plugin").lower;
        }

        string myprefix;
        if (url.hasKey("prefix") && url["prefix"] == true) {
            myprefix = url.getString("prefix").lower;
        }
        auto mycontroller = url.hasKey("controller") ? url.getString("controller").lower : null;
        string myaction = url.getString("action").lower;
        auto routingss = [
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
     * Reverse route or match a url array with the connected routes.
     *
     * Returns either the URL string generated by the route,
     * or throws an exception on failure.
     */
    string match(Json[string] url, Json[string] context) {
        // Named routes support optimization.
        if (url.hasKey("_name")) {
            routings = url.shift("_name");
            if (_named.hasKey(routings)) {
                route = _named[routings];
                result = route.match(url + route.defaults, context);
                if (result) {
                    return result;
                }
                throw new DMissingRouteException([
                    "url": routings,
                    "context": context,
                    "message": "A named route was found for `{routings}`, but matching failed.",
                ]);
            }
            throw new DMissingRouteException([
                "url": routings,
                "context": context
            ]);
        }
        foreach (routings; _getNames(url)) {
            if (_routeTable.isEmpty(routings)) {
                continue;
            }
            if (auto matchedRoute = _routeTable[routings].each!(matchRoute(route))) {
                return matchedRoute;
            };
        }
        throw new DMissingRouteException([
            "url": varexport_(url, true),
            "context": context
        ]);
    }

    protected string matchRoute(IRoute routeToCheck, Json[string] url, Json[string] context) {
        if (auto match = routeToCheck.match(url, context)) {
            return match == "/" ? match : match.strip("/");
        }
        return null;
    }

    /**
     * Get all the connected routes as a flat list.
     *
     * Routes will not be returned in the order they were added.
     */
    IRoute[] routes() {
        krsort(_paths);

        return array_reduce(
            _paths,
            "array_merge",
            []
        );
    }

    // Get the connected named routes.
    IRoute[] named() {
        return _named;
    }

    // Get the extensions that can be handled.
    string[] getExtensions() {
        return _extensions;
    }

    // Set the extensions that the route collection can handle.
    void setExtensions(Json[string] extensions, bool shouldMerge = true) {
        if (shouldMerge) {
            extensions = array_merge(_extensions, extensions).unique;
        }
        _extensions = extensions;
    }

    /**
     * Register a middleware with the RouteCollection.
     *
     * Once middleware has been registered, it can be applied to the current routing
     * scope or any child scopes that share the same RouteCollection.
     */
    void registerMiddleware(string routingName, /* IRoutingMiddleware | Closure | */ string mymiddleware) {
        _middleware[routingName] = mymiddleware;
    }

    // Add middleware to a middleware group
    void middlewareGroup(string groupName, Json[string] middlewareNames) {
        if (this.hasMiddleware(groupName)) {
            mymessage = "Cannot add middleware group 'groupName'. A middleware by this name has already been registered.";
            throw new DInvalidArgumentException(mymessage);
        }
        middlewareNames.each!((middlewareName) {
            if (!hasMiddleware(middlewareName)) {
                string message = "Cannot add " ~ middlewareName ~ " middleware to group " ~ groupName ~ ". It has not been registered.";
                throw new DInvalidArgumentException(message);
            }
        });
        _middlewareGroups[groupName] = middlewareNames;
    }

    // Check if the named middleware group has been created.
    bool hasMiddlewareGroup(string groupName) {
        return _middlewareGroups.hasKey(groupName);
    }

    // Check if the named middleware has been registered.
    bool hasMiddleware(string middlewareName) {
        return _middleware.hasKey(middlewareName);
    }

    // Check if the named middleware or middleware group has been registered.
    bool middlewarehasKey(string middlewareName) {
        return _hasMiddleware(middlewareName) || this.hasMiddlewareGroup(middlewareName);
    }

    // Get an array of middleware given a list of names
    Json[string] getMiddleware(string[] middlewareNames) {
        auto result = null;
        middlewareNames.each!((name) {
            if (this.hasMiddlewareGroup(name)) {
                result = array_merge(result, getMiddleware(_middlewareGroups[name]));
                continue;
            }
            if (!this.hasMiddleware(name)) {
                throw new DInvalidArgumentException(
                    "The middleware named `%s` has not been registered. Use registerMiddleware() to define it."
                    .format(name
                    ));
            }
            result ~= _middleware[name];
        });
        return result;
    }
}
