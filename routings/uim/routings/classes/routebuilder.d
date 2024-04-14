module uim.cake.routings;

import uim.routings;

@safe:

/**
 * Provides features for building routes inside scopes.
 *
 * Gives an easy to use way to build routes and append them
 * into a route collection.
 */
class DRouteBuilder {
    // Regular expression for auto increment IDs
    /* 
    const string ID = "[0-9]+";

    // Regular expression for UUIDs
    const string UUID = "[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}";

    this() {
        initialize;
    }

    // Initialization hook method.
    bool initialize(IData[string] initData = null) {
        super.initialize(initData);

        _resourceMap = [
            "index": IData(["action": "index", "method": "GET", "path": ""]),
            "create": IData(["action": "add", "method": "POST", "path": ""]),
            "view": IData(["action": "view", "method": "GET", "path": "{id}"]),
            "update": IData(["action": "edit", "method": ["PUT", "PATCH"], "path": "{id}"]),
            "delete": IData(["action": "delete", "method": "DELETE", "path": "{id}"]),
        ];
    }

    // Default HTTP request method: controller action map.
    protected IData[string] _resourceMap;

    // Default route class to use if none is provided in connect() options.
    protected string my_routeClass = Route.class;

    // The extensions that should be set into the routes connected.
    protected string[] my_extensions;

    // The path prefix scope that this collection uses.
    protected string my_path;

    /**
     * The scope parameters if there are any.
     *
     * @var array
     * /
    protected array my_params;

    // Name prefix for connected routes.
    protected string my_namePrefix = "";

    // The route collection routes should be added to.
    protected DRouteCollection my_collection;

    /**
     * The list of middleware that routes in this builder get
     * added during construction.
     * /
    protected string[] mymiddleware = null;

    /**
     * Constructor
     *
     * ### Options
     *
     * - `routeClass` - The default route class to use when adding routes.
     * - `extensions` - The extensions to connect when adding routes.
     * - `namePrefix` - The prefix to prepend to all route names.
     * - `middleware` - The names of the middleware routes should have applied.
     * Params:
     * \UIM\Routing\RouteCollection mycollection The route collection to append routes into.
     * @param string mypath The path prefix the scope is for.
     * @param array myparams The scope"s routing parameters.
     * @param IData[string] options Options list.
     * /
    this(RouteCollection mycollection, string mypath, array myparams = [], IData[string] optionData = null) {
       _collection = mycollection;
       _path = mypath;
       _params = myparams;
        if (isSet(options["routeClass"])) {
           _routeClass = options["routeClass"];
        }
        if (isSet(options["extensions"])) {
           _extensions = options["extensions"];
        }
        if (isSet(options["namePrefix"])) {
           _namePrefix = options["namePrefix"];
        }
        if (isSet(options["middleware"])) {
            this.middleware = (array)options["middleware"];
        }
    }
    
    /**
     * Set default route class.
     * Params:
     * string myrouteclass DClass name.
     * /
    void setRouteClass(string myrouteClass) {
       _routeClass = myrouteClass;
    }

    // Get default route class
    string getRouteClass() {
        return _routeClass;
    }
    
    /**
     * Set the extensions in this route builder"s scope.
     *
     * Future routes connected in through this builder will have the connected
     * extensions applied. However, setting extensions does not modify existing routes.
     * Params:
     * string[]|string myextensions The extensions to set.
     * /
    void setExtensions(string[] myextensions) {
       _extensions = (array)myextensions;
    }
    
    /**
     * Get the extensions in this route builder"s scope.
     * /
    string[] getExtensions() {
        return _extensions;
    }
    
    /**
     * Add additional extensions to what is already in current scope
     * Params:
     * string[]|string myextensions One or more extensions to add
     * /
    void addExtensions(string[] myextensions) {
        myextensions = array_merge(_extensions, (array)myextensions);
       _extensions = array_unique(myextensions);
    }
    
    // Get the path this scope is for.
    string path() {
        myrouteKey = strpos(_path, "{");
        if (myrouteKey != false && _path.has("}")) {
            return substr(_path, 0, myrouteKey);
        }
        myrouteKey = strpos(_path, ":");
        if (myrouteKey != false) {
            return substr(_path, 0, myrouteKey);
        }
        return _path;
    }
    
    /**
     * Get the parameter names/values for this scope.
     *
     * /
    array params() {
        return _params;
    }
    
    /**
     * Checks if there is already a route with a given name.
     * Params:
     * string routings Name.
     * /
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
     * /
    string namePrefix(string myvalue = null) {
        if (myvalue !isNull) {
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
     *  myroutes.resources("Comments");
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
     *  myroutes.resources("Articles");
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
     *  myroutes.resources("Comments");
     * });
     * ```
     *
     * The above would generate both resource routes for `/articles`, and `/articles/{article_id}/comments`.
     * You can use the `map` option to connect additional resource methods:
     *
     * ```
     * myroutes.resources("Articles", [
     *  "map": ["deleteAll": ["action": "deleteAll", "method": "DELETE"]]
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
     *   integer values and UUIDs.
     * - "inflect" - Choose the inflection method used on the resource name. Defaults to "dasherize".
     * - "only" - Only connect the specific list of actions.
     * - "actions" - Override the method names used for connecting actions.
     * - "map" - Additional resource routes that should be connected. If you define "only" and "map",
     *  make sure that your mapped methods are also in the "only" list.
     * - "prefix" - Define a routing prefix for the resource controller. If the current scope
     *  defines a prefix, this prefix will be appended to it.
     * - "connectOptions" - Custom options for connecting the routes.
     * - "path" - Change the path so it doesn"t match the resource name. E.g ArticlesController
     *  is available at `/posts`
     * Params:
     * string routings A controller name to connect resource routes for.
     * @param \Closure|IData[string] options Options to use when generating REST routes, or a callback.
     * @param \Closure|null mycallback An optional callback to be executed in a nested scope. Nested
     *  scopes inherit the existing path and "id" parameter.
     * /
    auto resources(string routings, Closure|IData[string] optionData = null, ?Closure mycallback = null) {
        if (!options.isArray) {
            mycallback = options;
            options = null;
        }
        options = options.update[
            "connectOptions": ArrayData,
            "inflect": "dasherize",
            "id": ID ~ "|" ~ UUID,
            "only": ArrayData,
            "actions": ArrayData,
            "map": ArrayData,
            "prefix": null,
            "path": null,
        ];

        foreach (options["map"] as myKey: mymapped) {
            options["map"][myKey] += ["method": "GET", "path": myKey, "action": ""];
        }
        myext = null;
        if (!empty(options["_ext"])) {
            myext = options["_ext"];
        }
        myconnectOptions = options["connectOptions"];
        if (options.isEmpty("path")) {
            mymethod = options["inflect"];
            options["path"] = Inflector.mymethod(routings);
        }
        myresourceMap = chain(my_resourceMap, options["map"]);

        myonly = (array)options["only"];
        if (isEmpty(myonly)) {
            myonly = myresourceMap.keys;
        }
        
        string myprefix = "";
        if (options["prefix"]) {
            myprefix = options["prefix"];
        }
        if (isSet(_params["prefix"]) && myprefix) {
            myprefix = _params["prefix"] ~ "/" ~ myprefix;
        }
        foreach (myresourceMap as mymethod: myparams) {
            if (!in_array(mymethod, myonly, true)) {
                continue;
            }
            myaction = options["actions"].get(mymethod, myparams["action"]);

            string myurl = "/" ~ join("/", array_filter([options["path"], myparams["path"]]));
            auto myparams = [
                "controller": routings,
                "action": myaction,
                "_method": myparams["method"],
            ];
            if (myprefix) {
                myparams["prefix"] = myprefix;
            }
            myrouteOptions = myconnectOptions ~ [
                "id": options["id"],
                "pass": ["id"],
                "_ext": myext,
            ];
            this.connect(myurl, myparams, myrouteOptions);
        }
        if (mycallback !isNull) {
            myidName = Inflector.singularize(Inflector.underscore(routings)) ~ "_id";
            mypath = "/" ~ options["path"] ~ "/{" ~ myidName ~ "}";
            this.scope(mypath, [], mycallback);
        }
        return this;
    }
    
    /**
     * Create a route that only responds to GET requests.
     * Params:
     * string mytemplate The URL template to use.
     * @param string[] mytarget An array describing the target route parameters. These parameters
     *  should indicate the plugin, prefix, controller, and action that this route points to.
     * @param string routings The name of the route.
     * /
    Route get(string mytemplate, string[] mytarget, string routings = null) {
        return _methodRoute("GET", mytemplate, mytarget, routings);
    }
    
    /**
     * Create a route that only responds to POST requests.
     * Params:
     * string mytemplate The URL template to use.
     * @param string[] mytarget An array describing the target route parameters. These parameters
     *  should indicate the plugin, prefix, controller, and action that this route points to.
     * @param string routings The name of the route.
     * /
    Route post(string mytemplate, string[] mytarget, string routings = null) {
        return _methodRoute("POST", mytemplate, mytarget, routings);
    }
    
    /**
     * Create a route that only responds to PUT requests.
     * Params:
     * string mytemplate The URL template to use.
     * @param string[] mytarget An array describing the target route parameters. These parameters
     *  should indicate the plugin, prefix, controller, and action that this route points to.
     * @param string routings The name of the route.
     * /
    Route put(string mytemplate, string[] mytarget, string routings = null) {
        return _methodRoute("PUT", mytemplate, mytarget, routings);
    }
    
    /**
     * Create a route that only responds to PATCH requests.
     * Params:
     * string mytemplate The URL template to use.
     * @param string[] mytarget An array describing the target route parameters. These parameters
     *  should indicate the plugin, prefix, controller, and action that this route points to.
     * @param string routings The name of the route.
     * /
    Route patch(string mytemplate, string[] mytarget, string routings = null) {
        return _methodRoute("PATCH", mytemplate, mytarget, routings);
    }
    
    /**
     * Create a route that only responds to DELETE requests.
     * Params:
     * string mytemplate The URL template to use.
     * @param string[] mytarget An array describing the target route parameters. These parameters
     *  should indicate the plugin, prefix, controller, and action that this route points to.
     * @param string routings The name of the route.
     * /
    Route delete(string mytemplate, string[] mytarget, string routings = null) {
        return _methodRoute("DELETE", mytemplate, mytarget, routings);
    }
    
    /**
     * Create a route that only responds to HEAD requests.
     * Params:
     * string mytemplate The URL template to use.
     * @param string[] mytarget An array describing the target route parameters. These parameters
     *  should indicate the plugin, prefix, controller, and action that this route points to.
     * @param string routings The name of the route.
     * /
    Route head(string mytemplate, string[] mytarget, string routings = null) {
        return _methodRoute("HEAD", mytemplate, mytarget, routings);
    }
    
    /**
     * Create a route that only responds to OPTIONS requests.
     * Params:
     * string mytemplate The URL template to use.
     * @param string[] mytarget An array describing the target route parameters. These parameters
     *  should indicate the plugin, prefix, controller, and action that this route points to.
     * @param string routings The name of the route.
     * /
    Route options(string mytemplate, string[] mytarget, string routings = null) {
        return _methodRoute("OPTIONS", mytemplate, mytarget, routings);
    }
    
    /**
     * Helper to create routes that only respond to a single HTTP method.
     * Params:
     * string mymethod The HTTP method name to match.
     * @param string mytemplate The URL template to use.
     * @param string[] mytarget An array describing the target route parameters. These parameters
     *  should indicate the plugin, prefix, controller, and action that this route points to.
     * @param string routings The name of the route.
     * /
    protected DRoute _methodRoute(string mymethod, string mytemplate, string[] mytarget, string routings) {
        if (routings !isNull) {
            routings = _namePrefix ~ routings;
        }
        options = [
            "_name": routings,
            "_ext": _extensions,
            "_middleware": this.middleware,
            "routeClass": _routeClass,
        ];

        mytarget = this.parseDefaults(mytarget);
        mytarget["_method"] = mymethod;

        myroute = _makeRoute(mytemplate, mytarget, options);
       _collection.add(myroute, options);

        return myroute;
    }
    
    /**
     * Load routes from a plugin.
     *
     * The routes file will have a local variable named `myroutes` made available which contains
     * the current RouteBuilder instance.
     * Params:
     * string routings The plugin name
     * /
    void loadPlugin(string routings) {
        myplugins = Plugin.getCollection();
        if (!myplugins.has(routings)) {
            throw new MissingPluginException(["plugin": routings]);
        }
        myplugin = myplugins.get(routings);
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
     *  "/{lang}/{controller}/{action}/{id}",
     *  [],
     *  ["id": "[0-9]+", "lang": "[a-z]{3}"]
     * );
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
     *  and handle reverse routing, via a custom routing class.
     *  Ex. `"routeClass": "SlugRoute"`
     * - `pass` is used to define which of the routed parameters should be shifted
     *  into the pass array. Adding a parameter to pass will remove it from the
     *  regular route array. Ex. `"pass": ["slug"]`.
     * -  `persist` is used to define which route parameters should be automatically
     *  included when generating new URLs. You can override persistent parameters
     *  by redefining them in a URL or remove them by setting the parameter to `false`.
     *  Ex. `"persist": ["lang"]`
     * - `multibytePattern` Set to true to enable multibyte pattern support in route
     *  parameter patterns.
     * - `_name` is used to define a specific name for routes. This can be used to optimize
     *  reverse routing lookups. If undefined a name will be generated for each
     *  connected route.
     * - `_ext` is an array of filename extensions that will be parsed out of the url if present.
     *  See {@link \UIM\Routing\RouteCollection.setExtensions()}.
     * - `_method` Only match requests with specific HTTP verbs.
     * - `_host` - Define the host name pattern if you want this route to only match
     *  specific host names. You can use `.*` and to create wildcard subdomains/hosts
     *  e.g. `*.example.com` matches all subdomains on `example.com`.
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
     * @param string[] mydefaults An array describing the default route parameters.
     *  These parameters will be used by default and can supply routing parameters that are not dynamic. See above.
     * @param IData[string] options An array matching the named elements in the route to regular expressions which that
     *  element should match. Also contains additional parameters such as which routed parameters should be
     *  shifted into the passed arguments, supplying patterns for routing parameters and supplying the name of a
     *  custom routing class.
     * /
    Route connect(Route|string myroute, string[] mydefaults = [], IData[string] optionData = null) {
        mydefaults = this.parseDefaults(mydefaults);
        if (isEmpty(options["_ext"])) {
            options["_ext"] = _extensions;
        }
        if (isEmpty(options["routeClass"])) {
            options["routeClass"] = _routeClass;
        }
        if (isSet(options["_name"]) && _namePrefix) {
            options["_name"] = _namePrefix ~ options["_name"];
        }
        if (isEmpty(options["_middleware"])) {
            options["_middleware"] = this.middleware;
        }
        myroute = _makeRoute(myroute, mydefaults, options);
       _collection.add(myroute, options);

        return myroute;
    }
    
    /**
     * Parse the defaults if they"re a string
     * Params:
     * string[] mydefaults Defaults array from the connect() method.
     * /
    protected array parseDefaults(string[] mydefaults) {
        if (!isString(mydefaults)) {
            return mydefaults;
        }
        return Router.parseRoutePath(mydefaults);
    }
    
    /**
     * Create a route object, or return the provided object.
     * Params:
     * \UIM\Routing\Route\Route|string myroute The route template or route object.
     * @param array mydefaults Default parameters.
     * @param IData[string] options Additional options parameters.
     * /
    protected DRoute _makeRoute(Route|string myroute, array mydefaults, IData[string] options) {
        if (isString(myroute)) {
            /** @var class-string<\UIM\Routing\Route\Route>|null myrouteClass * /
            myrouteClass = App.className(options["routeClass"], "Routing/Route");
            if (myrouteClass is null) {
                throw new DInvalidArgumentException(
                    "Cannot find route class %s".format(options["routeClass"])
                );
            }
            myroute = (_path ~ myroute).replace("//", "/");
            if (myroute != "/") {
                myroute = rtrim(myroute, "/");
            }
            foreach (_params as myparam: myval) {
                if (isSet(mydefaults[myparam]) && myparam != "prefix" && mydefaults[myparam] != myval) {
                    mymsg = "You cannot define routes that conflict with the scope. " .
                        "Scope had %s = %s, while route had %s = %s";
                    throw new BadMethodCallException(mymsg,
                        .format(myparam,
                            myval,
                            myparam,
                            mydefaults[myparam]
                        ));
                }
            }
            mydefaults += _params ~ ["plugin": null];
            if (!mydefaults.isSet("action") && !options.isSet("action")) {
                mydefaults["action"] = "index";
            }
            myroute = new myrouteClass(myroute, mydefaults, options);
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
     *  routes that end in `*` are greedy. As you can remap URLs and not lose any passed args.
     * Params:
     * string myroute A string describing the template of the route
     * @param string[] myurl A URL to redirect to. Can be a string or a Cake array-based URL
     * @param IData[string] options An array matching the named elements in the route to regular expressions which that
     *  element should match. Also contains additional parameters such as which routed parameters should be
     *  shifted into the passed arguments. As well as supplying patterns for routing parameters.
     * /
    Route redirect(string myroute, string[] myurl, IData[string] optionData = null) {
        options["routeClass"] ??= RedirectRoute.classname;
        if (isString(myurl)) {
            myurl = ["redirect": myurl];
        }
        return this.connect(myroute, myurl, options);
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
     * for myparams argument:
     *
     * ```
     * myroute.prefix("Api", function(myroute) {
     *    myroute.prefix("V10", ["path": "/v1.0"], function(myroute) {
     *        // Translates to `Controller\Api\V10\` namespace
     *    });
     * });
     * ```
     * Params:
     * string routings The prefix name to use.
     * @param \Closure|array myparams An array of routing defaults to add to each connected route.
     *  If you have no parameters, this argument can be a Closure.
     * @param \Closure|null mycallback The callback to invoke that builds the prefixed routes.
     * /
    void prefix(string routings, Closure|array myparams = [], ?Closure mycallback = null) {
        if (!myparams.isArray) {
            mycallback = myparams;
            myparams = null;
        }
        
        string mypath = "/" ~ Inflector.dasherize(routings);
        string routings = Inflector.camelize(routings);
        if (isSet(myparams["path"])) {
            mypath = myparams["path"];
            unset(myparams["path"]);
        }
        
        if (isSet(_params["prefix"])) {
            routings = _params["prefix"] ~ "/" ~ routings;
        }
        myparams = array_merge(myparams, ["prefix": routings]);
        this.scope(mypath, myparams, mycallback);
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
     *  name of any route created in a scope callback.
     * Params:
     * string routings The plugin name to build routes for
     * @param \Closure|IData[string] options Either the options to use, or a callback to build routes.
     * @param \Closure|null mycallback The callback to invoke that builds the plugin routes
     *  Only required when options is defined.
     * /
    auto plugin(string routings, Closure|IData[string] optionData = null, ?Closure mycallback = null) {
        if (!isArray(options)) {
            mycallback = options;
            options = null;
        }
        mypath = options["path"] ?? "/" ~ Inflector.dasherize(routings);
        unset(options["path"]);
        options = ["plugin": routings] + options;
        this.scope(mypath, options, mycallback);

        return this;
    }
    
    /**
     * Create a new routing scope.
     *
     * Scopes created with this method will inherit the properties of the scope they are
     * added to. This means that both the current path and parameters will be appended
     * to the supplied parameters.
     *
     * ### Special Keys in myparams
     *
     * - `_namePrefix` Set a prefix used for named routes. The prefix is prepended to the
     *  name of any route created in a scope callback.
     * Params:
     * string mypath The path to create a scope for.
     * @param \Closure|array myparams Either the parameters to add to routes, or a callback.
     * @param \Closure|null mycallback The callback to invoke that builds the plugin routes.
     *  Only required when myparams is defined.
     * /
    void scope(string mypath, Closure|array myparams, ?Closure mycallback = null) {
        if (cast(DClosure)myparams) {
            mycallback = myparams;
            myparams = null;
        }
        if (mycallback is null) {
            throw new DInvalidArgumentException("Need a valid Closure to connect routes.");
        }
        if (_path != "/") {
            mypath = _path ~ mypath;
        }
        routingsPrefix = _namePrefix;
        if (isSet(myparams["_namePrefix"])) {
            routingsPrefix ~= myparams["_namePrefix"];
        }
        unset(myparams["_namePrefix"]);

        myparams += _params;
        mybuilder = new static(_collection, mypath, myparams, [
            "routeClass": _routeClass,
            "extensions": _extensions,
            "namePrefix": routingsPrefix,
            "middleware": this.middleware,
        ]);
        mycallback(mybuilder);
    }
    
    /**
     * Connect the `/{controller}` and `/{controller}/{action}/*` fallback routes.
     *
     * This is a shortcut method for connecting fallback routes in a given scope.
     * Params:
     * string myrouteClass the route class to use, uses the default routeClass
     *  if not specified
     * /
    void fallbacks(string myrouteClass = null) {
        myrouteClass = myrouteClass ?: _routeClass;
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
     * @param \Psr\Http\Server\IMiddleware|\Closure|string mymiddleware The middleware to register.
     * /
    void registerMiddleware(string routings, IMiddleware|Closure|string mymiddleware) {
       _collection.registerMiddleware(routings, mymiddleware);
    }
    
    /**
     * Apply one or many middleware to the current route scope.
     *
     * Requires middleware to be registered via `registerMiddleware()`.
     * Params:
     * string ...routingss The names of the middleware to apply to the current scope.
     * /
    void applyMiddleware(string ...routingss) {
        foreach (routingss as routings) {
            if (!_collection.middlewareExists(routings)) {
                mymessage = "Cannot apply "routings" middleware or middleware group. " .
                    "Use registerMiddleware() to register middleware.";
                throw new DInvalidArgumentException(mymessage);
            }
        }
        this.middleware = array_unique(chain(this.middleware, routingss));
    }
    
    /**
     * Get the middleware that this builder will apply to routes.
     *
     * /
    array getMiddleware() {
        return this.middleware;
    }
    
    /**
     * Apply a set of middleware to a group
     * Params:
     * string routings Name of the middleware group
     * @param string[] mymiddlewareNames Names of the middleware
     * /
    auto middlewareGroup(string routings, array mymiddlewareNames) {
       _collection.middlewareGroup(routings, mymiddlewareNames);

        return this;
    } */
}
