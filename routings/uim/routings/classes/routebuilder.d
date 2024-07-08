module uim.routings.classes.routebuilder;

import uim.routings;

@safe:

/**
 * Provides features for building routes inside scopes.
 *
 * Gives an easy to use way to build routes and append them
 * into a route collection.
 */
class DRouteBuilder {
    // #region consts
    // Regular expression for auto increment IDs
    const string ID = "[0-9]+";

    // Regular expression for UUIDs
    const string UUID = "[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}";
    // #endregion consts

    this() {
        initialize;
    }

    // Initialization hook method.
    bool initialize(Json[string] initData = null) {
        _resourceMap = [
            "index": Json(["action": "index", "method": "GET", "path": ""]),
            "create": Json(["action": "add", "method": "POST", "path": ""]),
            "view": Json(["action": "view", "method": "GET", "path": "{id}"]),
            "update": Json([
                "action": "edit",
                "method": ["PUT", "PATCH"],
                "path": "{id}"
            ]),
            "delete": Json([
                "action": "delete",
                "method": "DELETE",
                "path": "{id}"
            ]),
        ];

        return true;
    }

    // Default HTTP request method: controller action map.
    protected Json[string] _resourceMap;

    // Default route class to use if none is provided in connect() options.
    // TODO protected string _routeClass = (new DRoute).classname;
    // Set default route class.
    void setRouteClass(string newclassname) {
        _routeClass = newclassname;
    }

    // Get default route class
    string getRouteClass() {
        return _routeClass;
    }

    // The extensions that should be set into the routes connected.
    protected string[] _extensions;

    // The path prefix scope that this collection uses.
    protected string _path;

    // The scope parameters if there are any.
    protected Json[string] _params;

    // Name prefix for connected routes.
    protected string _namePrefix = "";

    // The route collection routes should be added to.
    protected DRouteCollection _collection;

    // The list of middleware that routes in this builder get added during construction.
    protected string[] mymiddleware = null;

    /**
     
     *
     * ### Options
     *
     * - `routeClass` - The default route class to use when adding routes.
     * - `extensions` - The extensions to connect when adding routes.
     * - `namePrefix` - The prefix to prepend to all route names.
     * - `middleware` - The names of the middleware routes should have applied.
     */
    this(RouteCollection routeCollection, string path, Json[string] params = [], Json[string] options = null) {
        _collection = routeCollection;
        _path = path;
        _params = params;
        if (options.hasKey("routeClass")) {
            _routeClass = options.get("routeClass");
        }
        if (options.hasKey("extensions")) {
            _extensions = options.get("extensions");
        }
        if (options.hasKey("namePrefix")) {
            _namePrefix = options.get("namePrefix");
        }
        if (options.hasKey("middleware")) {
            _middleware = options.getArray("middleware");
        }
    }

    /**
     * Set the extensions in this route builder"s scope.
     *
     * Future routes connected in through this builder will have the connected
     * extensions applied. However, setting extensions does not modify existing routes.
     * Params:
     * string[]|string myextensions The extensions to set.
     */
    void setExtensions(string extension) {
        setExtensions([extensions]);
    }
    void setExtensions(string[] extensions) {
        _extensions = extensions;
    }

    // Get the extensions in this route builder"s scope.
    string[] getExtensions() {
        return _extensions;
    }

    /**
     * Add additional extensions to what is already in current scope
     * Params:
     * string[]|string myextensions One or more extensions to add
     */
    void addExtensions(string[] myextensions) {
        myextensions = array_merge(_extensions, (array) myextensions);
        _extensions = array_unique(myextensions);
    }

    // Get the path this scope is for.
    string path() {
        size_t myrouteKey = indexOf(_path, "{");
        if (myrouteKey == true && _path.contains("}")) {
            return subString(_path, 0, myrouteKey);
        }
        myrouteKey = indexOf(_path, ": ");
        if (myrouteKey == true) {
            return subString(_path, 0, myrouteKey);
        }
        return _path;
    }

    /**
     * Get the parameter names/values for this scope.
     *
     */
    Json[string] params() {
        return _params;
    }

    /**
     * Checks if there is already a route with a given name.
     * Params:
     * string routings Name.
     */
    bool nameExists(string routings) {
        return array_key_exists(routings, _collection.named());
    }

    /**
     * Get/set the name prefix for this scope.
     *
     * Modifying the name prefix will only change the prefix
     * used for routes connected after the prefix is changed.
     * Params:
     * string myvalue Either the value to set or null.
     */
    string namePrefix(string myvalue = null) {
        if (myvalue !is null) {
            _namePrefix = myvalue;
        }
        return _namePrefix;
    }

    /**
     * Generate REST resource routes for the given controller(s).
     *
     * A quick way to generate a default routes to a set of REST resources (controller(s)).
     *
     * ### Usage
     *
     * Connect resource routes for an app controller:
     *
     * ```
     * myroutes.resources("Posts");
     * ```
     *
     * Connect resource routes for the Comments controller in the
     * Comments plugin:
     *
     * ```
     * Router.plugin("Comments", auto (myroutes) {
     * myroutes.resources("Comments");
     * });
     * ```
     *
     * Plugins will create lowercase dasherized resource routes. e.g
     * `/comments/comments`
     *
     * Connect resource routes for the Articles controller in the
     * Admin prefix:
     *
     * ```
     * Router.prefix("Admin", auto (myroutes) {
     * myroutes.resources("Articles");
     * });
     * ```
     *
     * Prefixes will create lowercase dasherized resource routes. e.g
     * `/admin/posts`
     *
     * You can create nested resources by passing a callback in:
     *
     * ```
     * myroutes.resources("Articles", auto (myroutes) {
     * myroutes.resources("Comments");
     * });
     * ```
     *
     * The above would generate both resource routes for `/articles`, and `/articles/{article_id}/comments`.
     * You can use the `map` option to connect additional resource methods:
     *
     * ```
     * myroutes.resources("Articles", [
     * "map": ["deleteAll": ["action": "deleteAll", "method": "DELETE"]]
     * ]);
     * ```
     *
     * In addition to the default routes, this would also connect a route for `/articles/delete_all`.
     * By default, the path segment will match the key name. You can use the "path" key inside the resource
     * definition to customize the path name.
     *
     * You can use the `inflect` option to change how path segments are generated:
     *
     * ```
     * myroutes.resources("PaymentTypes", ["inflect": "underscore"]);
     * ```
     *
     * Will generate routes like `/payment-types` instead of `/payment_types`
     *
     * ### Options:
     *
     * - "id" - The regular expression fragment to use when matching IDs. By default, matches
     *  integer values and UUIDs.
     * - "inflect" - Choose the inflection method used on the resource name. Defaults to "dasherize".
     * - "only" - Only connect the specific list of actions.
     * - "actions" - Override the method names used for connecting actions.
     * - "map" - Additional resource routes that should be connected. If you define "only" and "map",
     * make sure that your mapped methods are also in the "only" list.
     * - "prefix" - Define a routing prefix for the resource controller. If the current scope
     * defines a prefix, this prefix will be appended to it.
     * - "connectOptions" - Custom options for connecting the routes.
     * - "path" - Change the path so it doesn"t match the resource name. E.g ArticlesController
     * is available at `/posts`
     * Params:
     * string routings A controller name to connect resource routes for.
     * @param \Closure|Json[string] options Options to use when generating REST routes, or a callback.
     * @param \Closure|null callbackClosure An optional callback to be executed in a nested scope. Nested
     * scopes inherit the existing path and "id" parameter.
     */
    auto resources(string routings, Closure | Json[string] options = null, DClosure nestedCallback = null) {
        if (!options.isArray) {
            nestedCallback = options;
            options = null;
        }

        auto updatedOptions = options.update[
            "connectOptions": Json.emptyArray,
            "inflect": "dasherize",
            "id": ID ~ "|" ~ UUID,
            "only": Json.emptyArray,
            "actions": Json.emptyArray,
            "map": Json.emptyArray,
            "prefix": Json(null),
            "path": Json(null),
        ];

        foreach (options["map"] as myKey : mymapped) {
            options["map"][myKey] += ["method": "GET", "path": myKey, "action": ""];
        }
        myext = null;
        if (!options.isEmpty("_ext")) {
            myext = options.get("_ext"];
        }
        myconnectOptions = options.get("connectOptions"];
        if (options.isEmpty("path")) {
            mymethod = options.get("inflect"];
            options["path"] = Inflector.mymethod(routings);
        }
        myresourceMap = chain(_resourceMap, options["map"]);

        myonly = (array) options["only"];
        if (isEmpty(myonly)) {
            myonly = myresourceMap.keys;
        }

        string myprefix = options.getStrinf("prefix");
        if (_params.hasKey("prefix") && myprefix) {
            myprefix = _params["prefix"] ~ "/" ~ myprefix;
        }
        foreach (myresourceMap as mymethod : params) {
            if (!isIn(mymethod, myonly, true)) {
                continue;
            }
            myaction = options.get("actions"].get(mymethod, params["action"]);

            string myurl = "/" ~ join("/", array_filter([
                    options["path"], params["path"]
                ]));
            auto params = [
                "controller": routings,
                "action": myaction,
                "_method": params["method"],
            ];
            if (myprefix) {
                params["prefix"] = myprefix;
            }
            myrouteOptions = myconnectOptions ~ [
                "id": options.get("id"),
                "pass": ["id"],
                "_ext": myext,
            ];
            this.connect(myurl, params, myrouteOptions);
        }
        if (nestedCallback !is null) {
            auto myidName = Inflector.singularize(Inflector.underscore(routings)) ~ "_id";
            auto path = "/" ~ options.getString("path") ~ "/{" ~ myidName ~ "}";
            this.scope (path, [], nestedCallback);
        }
        return this;
    }

    // Create a route that only responds to GET requests.
    Route get(string urlTemplate, string[] targetRouteParameters, string routings = null) {
        return _methodRoute("GET", urlTemplate, targetRouteParameters, routings);
    }

    // Create a route that only responds to POST requests.
    Route post(string urlTemplate, string[] targetRouteParameters, string routings = null) {
        return _methodRoute("POST", urlTemplate, targetRouteParameters, routings);
    }

    // Create a route that only responds to PUT requests.
    Route put(string urlTemplate, string[] targetRouteParameters, string routeName = null) {
        return _methodRoute("PUT", urlTemplate, targetRouteParameters, routeName);
    }

    // Create a route that only responds to PATCH requests.
    Route patch(string urlTemplate, string[] targetRouteParameters, string routeName = null) {
        return _methodRoute("PATCH", urlTemplate, targetRouteParameters, routeName);
    }

    // Create a route that only responds to DELETE requests.
    Route remove(string urlTemplate, string[] targetRouteParameters, string routeName = null) {
        return _methodRoute("DELETE", urlTemplate, targetRouteParameters, routeName);
    }

    // Create a route that only responds to HEAD requests.
    Route head(string urlTemplate, string[] targetRouteParameters, string routings = null) {
        return _methodRoute("HEAD", urlTemplate, targetRouteParameters, routings);
    }

    // Create a route that only responds to OPTIONS requests.
    Route options(string urlTemplate, string[] targetRouteParameters, string routings = null) {
        return _methodRoute("OPTIONS", urlTemplate, targetRouteParameters, routings);
    }

    // Helper to create routes that only respond to a single HTTP method.
    protected DRoute _methodRoute(string httpMethod, string urlTemplate, string[] targetRouteParameters, string routings) {
        if (routings !is null) {
            routings = _namePrefix ~ routings;
        }
       
        auto options = [
            "_name": routings,
            "_ext": _extensions,
            "_middleware": _middleware,
            "routeClass": _routeClass,
        ];

        targetRouteParameters = parseDefaults(targetRouteParameters);
        targetRouteParameters.set("_method", httpMethod);

        auto route = _makeRoute(urlTemplate, targetRouteParameters, options);
        _collection.add(myroute, options);

        return route;
    }

    /**
     * Load routes from a plugin.
     *
     * The routes file will have a local variable named `myroutes` made available which contains
     * the current RouteBuilder instance.
     */
    void loadPlugin(string routings) {
        auto plugins = Plugin.getCollection();
        if (!plugins.has(routings)) {
            throw new DMissingPluginException(["plugin": routings]);
        }
        myplugin = plugins.get(routings);
        myplugin.routes(this);

        // Disable the routes hook to prevent duplicate route issues.
        myplugin.disable("routes");

        return this;
    }

    /**
     * Connects a new DRoute.
     *
     * Routes are a way of connecting request URLs to objects in your application.
     * At their core routes are a set or regular expressions that are used to
     * match requests to destinations.
     *
     * Examples:
     *
     * ```
     * myroutes.connect("/{controller}/{action}/*");
     * ```
     *
     * The first parameter will be used as a controller name while the second is
     * used as the action name. The "/*" syntax makes this route greedy in that
     * it will match requests like `/posts/index` as well as requests
     * like `/posts/edit/1/foo/bar`.
     *
     * ```
     * myroutes.connect("/home-page", ["controller": "Pages", "action": "display", "home"]);
     * ```
     *
     * The above shows the use of route parameter defaults. And providing routing
     * parameters for a static route.
     *
     * ```
     * myroutes.connect(
     * "/{lang}/{controller}/{action}/{id}",
     * [],
     * ["id": "[0-9]+", "lang": "[a-z]{3}"]
     *);
     * ```
     *
     * Shows connecting a route with custom route parameters as well as
     * providing patterns for those parameters. Patterns for routing parameters
     * do not need capturing groups, as one will be added for each route params.
     *
     * options offers several "special" keys that have special meaning
     * in the options array.
     *
     * - `routeClass` is used to extend and change how individual routes parse requests
     * and handle reverse routing, via a custom routing class.
     * Ex. `"routeClass": "SlugRoute"`
     * - `pass` is used to define which of the routed parameters should be shifted
     * into the pass array. Adding a parameter to pass will remove it from the
     * regular route array. Ex. `"pass": ["slug"]`.
     * -  `persist` is used to define which route parameters should be automatically
     * included when generating new URLs. You can override persistent parameters
     * by redefining them in a URL or remove them by setting the parameter to `false`.
     * Ex. `"persist": ["lang"]`
     * - `multibytePattern` Set to true to enable multibyte pattern support in route
     * parameter patterns.
     * - `_name` is used to define a specific name for routes. This can be used to optimize
     * reverse routing lookups. If undefined a name will be generated for each
     * connected route.
     * - `_ext` is an array of filename extensions that will be parsed out of the url if present.
     * See {@link \UIM\Routing\RouteCollection.setExtensions()}.
     * - `_method` Only match requests with specific HTTP verbs.
     * - `_host` - Define the host name pattern if you want this route to only match
     * specific host names. You can use `.*` and to create wildcard subdomains/hosts
     * e.g. `*.example.com` matches all subdomains on `example.com`.
     * - "_port` - Define the port if you want this route to only match specific port number.
     *
     * Example of using the `_method` condition:
     *
     * ```
     * myroutes.connect("/tasks", ["controller": "Tasks", "action": "index", "_method": "GET"]);
     * ```
     *
     * The above route will only be matched for GET requests. POST requests will fail to match this route.
     * Params:
     * \UIM\Routing\Route\Route|string myroute A string describing the template of the route
     */
    DRoute connect(/* Route | */ string myroute, string[] defaults = [], Json[string] options = null) {
        auto defaultRouteParameters = parseDefaults(defaults);
        if (isoptions.isEmpty("_ext")) {
            options.set("_ext", _extensions);
        }
        if (isoptions.isEmpty("routeClass")) {
            options.set("routeClass", _routeClass);
        }
        if (options.hasKey("_name") && _namePrefix) {
            options.set("_name", _namePrefix ~ options.getString("_name"));
        }
        if (isoptions.isEmpty("_middleware")) {
            options.set("_middleware", _middleware);
        }
        myroute = _makeRoute(myroute, defaultRouteParameters, options);
        _collection.add(myroute, options);

        return myroute;
    }

    // Parse the defaults if they"re a string
    protected Json[string] parseDefaults(string[] defaults) {
        if (!isString(defaults)) {
            return defaults;
        }
        return Router.parseRoutePath(defaults);
    }

    // Create a route object, or return the provided object.
    protected DRoute _makeRoute(/* Route |  */string myroute, Json[string] defaults, Json[string] options = null) {
        if (isString(myroute)) {
            /** @var class-string<\UIM\Routing\Route\Route>|null myrouteClass */
            auto myrouteClass = App.classname(options["routeClass"], "Routing/Route");
            if (myrouteClass.isNull) {
                throw new DInvalidArgumentException(
                    "Cannot find route class %s".format(options["routeClass"])
                );
            }
            
            string myroute = (_path ~ myroute).replace("//", "/");
            if (myroute != "/") {
                myroute = stripRight(myroute, "/");
            }
            foreach (myparam, myval; _params) {
                if (isSet(defaults[myparam]) && myparam != "prefix" && defaults[myparam] != myval) {
                    mymsg = "You cannot define routes that conflict with the scope. "
                        ."Scope had %s = %s, while route had %s = %s";
                    throw new BadMethodCallException(mymsg,
                        
                            .format(myparam,
                                myval,
                                myparam,
                                defaults[myparam]
                            ));
                }
            }
            defaults += _params ~ ["plugin": Json(null)];
            if (!defaults.hasKey("action") && !options.hasKey("action")) {
                defaults["action"] = "index";
            }
            myroute = new myrouteClass(myroute, defaults, options);
        }
        return myroute;
    }

    /**
     * Connects a new redirection Route in the router.
     *
     * Redirection routes are different from normal routes as they perform an actual
     * header redirection if a match is found. The redirection can occur within your
     * application or redirect to an outside location.
     *
     * Examples:
     *
     * ```
     * myroutes.redirect("/home/*", ["controller": "Posts", "action": "view"]);
     * ```
     *
     * Redirects /home/* to /posts/view and passes the parameters to /posts/view. Using an array as the
     * redirect destination allows you to use other routes to define where a URL string should be redirected to.
     *
     * ```
     * myroutes.redirect("/posts/*", "http://google.com", ["status": 302]);
     * ```
     *
     * Redirects /posts/* to http://google.com with a HTTP status of 302
     *
     * ### Options:
     *
     * - `status` Sets the HTTP status (default 301)
     * - `persist` Passes the params to the redirected route, if it can. This is useful with greedy routes,
     * routes that end in `*` are greedy. As you can remap URLs and not lose any passed args.
     * Params:
     * string myroute A string describing the template of the route
     * @param string[] myurl A URL to redirect to. Can be a string or a uim array-based URL
     */
    Route redirect(string routeTemplate, string[] myurl, Json[string] options = null) {
        auto options = options.merge([
            "routeClass": RedirectRoute.classname.toJson
        ]);
        if (isString(myurl)) {
            myurl = ["redirect": myurl];
        }
        return _connect(routeTemplate, myurl, options);
    }

    /**
     * Add prefixed routes.
     *
     * This method creates a scoped route collection that includes
     * relevant prefix information.
     *
     * The routings parameter is used to generate the routing parameter name.
     * For example a path of `admin` would result in `"prefix": "admin"` being
     * applied to all connected routes.
     *
     * You can re-open a prefix as many times as necessary, as well as nest prefixes.
     * Nested prefixes will result in prefix values like `admin/api` which translates
     * to the `Controller\Admin\Api\` namespace.
     *
     * If you need to have prefix with dots, eg: "/api/v1.0", use "path" key
     * for params argument:
     *
     * ```
     * myroute.prefix("Api", function(myroute) {
     *   myroute.prefix("V10", ["path": "/v1.0"], function(myroute) {
     *       // Translates to `Controller\Api\V10\` namespace
     *   });
     * });
     * ```
     * Params:
     * string routings The prefix name to use.
     * @param \Closure|Json[string] params An array of routing defaults to add to each connected route.
     * If you have no parameters, this argument can be a Closure.
     */
    void prefix(string routings, /* Closure |  */Json[string] params = null, DClosure callbackClosure = null) {
        if (!params.isArray) {
            callbackClosure = params;
            params = null;
        }

        string path = "/" ~ Inflector.dasherize(routings);
        string routings = Inflector.camelize(routings);
        if (params.hasKey("path")) {
            path = params["path"];
            params.remove("path");
        }

        if (_params.hasKey("prefix")) {
            routings = _params.getString("prefix") ~ "/" ~ routings;
        }
        params = array_merge(params, ["prefix": routings]);
        scope (path, params, callbackClosure);
    }

    /**
     * Add plugin routes.
     *
     * This method creates a new scoped route collection that includes
     * relevant plugin information.
     *
     * The plugin name will be inflected to the underscore version to create
     * the routing path. If you want a custom path name, use the `path` option.
     *
     * Routes connected in the scoped collection will have the correct path segment
     * prepended, and have a matching plugin routing key set.
     *
     * ### Options
     *
     * - `path` The path prefix to use. Defaults to `Inflector.dasherize(routings)`.
     * - `_namePrefix` Set a prefix used for named routes. The prefix is prepended to the
     * name of any route created in a scope callback.
     * Params:
     * string routings The plugin name to build routes for
     * @param \Closure|Json[string] options Either the options to use, or a callback to build routes.
     * @param \Closure|null callbackClosure The callback to invoke that builds the plugin routes
     * Only required when options is defined.
     */
    auto plugin(string routings, /* Closure| */ Json[string] options = null, Closure callbackClosure = null) {
        if (!isArray(options)) {
            callbackClosure = options;
            options = null;
        }
        path = options.getString("path", "/" ~ Inflector.dasherize(routings));
        options.remove("path"]);
        options = ["plugin": routings] + options;
        this.scope (path, options, callbackClosure);

        return this;
    }

    /**
     * Create a new routing scope.
     *
     * Scopes created with this method will inherit the properties of the scope they are
     * added to. This means that both the current path and parameters will be appended
     * to the supplied parameters.
     *
     * ### Special Keys in params
     *
     * - `_namePrefix` Set a prefix used for named routes. The prefix is prepended to the
     * name of any route created in a scope callback.
     * Params:
     * string path The path to create a scope for.
     * @param \Closure|Json[string] params Either the parameters to add to routes, or a callback.
     * @param \Closure|null callbackClosure The callback to invoke that builds the plugin routes.
     * Only required when params is defined.
     */
    void scope (string path, Closure | Json[string] params, Closure callbackClosure = null) {
        if (cast(DClosure) params) {
            callbackClosure = params;
            params = null;
        }
        if (callbackClosure.isNull) {
            throw new DInvalidArgumentException("Need a valid Closure to connect routes.");
        }
        if (_path != "/") {
            path = _path ~ path;
        }
        routingsPrefix = _namePrefix;
        if (params.hasKey("_namePrefix")) {
            routingsPrefix ~= params["_namePrefix"];
        }
        remove(params["_namePrefix"]);

        params += _params;
        mybuilder = new static(_collection, path, params, [
                "routeClass": _routeClass,
                "extensions": _extensions,
                "namePrefix": routingsPrefix,
                "middleware": _middleware,
            ]);
        callbackClosure(mybuilder);
    }

    /**
     * Connect the `/{controller}` and `/{controller}/{action}/*` fallback routes.
     *
     * This is a shortcut method for connecting fallback routes in a given scope.
     * Params:
     * string myrouteClass the route class to use, uses the default routeClass
     * if not specified
     */
    void fallbacks(string myrouteClass = null) {
        myrouteClass = myrouteClass ?  : _routeClass;
        this.connect("/{controller}", ["action": "index"], compact("routeClass"));
        this.connect("/{controller}/{action}/*", [], compact("routeClass"));
    }

    /**
     * Register a middleware with the RouteCollection.
     *
     * Once middleware has been registered, it can be applied to the current routing
     * scope or any child scopes that share the same RouteCollection.
     * Params:
     * string routings The name of the middleware. Used when applying middleware to a scope.
     * @param \Psr\Http\Server\IRoutingMiddleware|\/*Closure|*/
    string mymiddleware The middleware to register.
        *  /
        void registerMiddleware(string routings, IRoutingMiddleware |  /*Closure|*/ string mymiddleware) {
            _collection.registerMiddleware(routings, mymiddleware);
        }

    /**
     * Apply one or many middleware to the current route scope.
     *
     * Requires middleware to be registered via `registerMiddleware()`.
     * Params:
     * string ...routingss The names of the middleware to apply to the current scope.
     */
    void applyMiddleware(string...routingss) {
        foreach (routings; routingss) {
            if (!_collection.middlewareExists(routings)) {
                auto mymessage = "Cannot apply " routings" middleware or middleware group. "
                    ."Use registerMiddleware() to register middleware.";
                throw new DInvalidArgumentException(mymessage);
            }
        }
        _middleware = array_unique(chain(_middleware, routingss));
    }

    // Get the middleware that this builder will apply to routes.
    Json[string] getMiddleware() {
        return _middleware;
    }

    // Apply a set of middleware to a group
    auto middlewareGroup(string groupName, Json[string] middlewareNames) {
        _collection.middlewareGroup(groupName, middlewareNames);

        return this;
    }
}
