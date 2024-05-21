module uim.routings.classes.router;

import uim.routings;

@safe:

/**
 * Parses the request URL into controller, action, and parameters. Uses the connected routes
 * to match the incoming URL string to parameters that will allow the request to be dispatched. Also
 * handles converting parameter lists into URL strings, using the connected routes. Routing allows you to decouple
 * the way the world interacts with your application (URLs) and the implementation (controllers and actions).
 *
 * ### Connecting routes
 *
 * Connecting routes is done using Router.connect(). When parsing incoming requests or reverse matching
 * parameters, routes are enumerated in the order they were connected. For more information on routes and
 * how to connect them see Router.connect().
 */
class DRouter {
    // Default route class.
    // TODO protected static string _defaultRouteClass = (new DRoute).className;

    /**
     * Contains the base string that will be applied to all generated URLs
     * For example `https://example.com`
     */
    protected static string _fullBaseUrl = null;

    // Regular expression for action names
    const string ACTION = "index|show|add|create|edit|update|remove|del|delete|view|item";

    // Regular expression for years
    const string YEAR = "[12][0-9]{3}";

    // Regular expression for months
    const string MONTH = "0[1-9]|1[012]";

    // Regular expression for days
    const string DAY = "0[1-9]|[12][0-9]|3[01]";

    // Regular expression for auto increment IDs
    const string ID = "[0-9]+";

    // Regular expression for UUIDs
    const string UUID = "[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}";

    // The route collection routes would be added to.
    protected static DRouteCollection _collection;

    // A hash of request context data.
    protected static Json[string] _requestContext = null;

    // Maintains the request object reference.
    protected static DServerRequest _request = null;
    // Get the current request object.
    static DServerRequest getRequest() {
        return _request;
    }

    // Default extensions defined with Router.extensions()
    protected static string[] _defaultExtensions = null;

    // Cache of parsed route paths
    protected static Json[string] _routePaths = null;

    /*
    // Named expressions
    protected static STRINGAA _namedExpressions = [
        "Action": Router.ACTION,
        "Year": Router.YEAR,
        "Month": Router.MONTH,
        "Day": Router.DAY,
        "ID": Router.ID,
        "UUID": Router.UUID,
    ];


    /**
     * Initial state is populated the first time reload() is called which is at the bottom
     * of this file. This is a cheat as get_class_vars() returns the value of static vars even if they
     * have changed.
     */
    protected static Json[string] _initialState = null;

    /**
     * The stack of URL filters to apply against routing URLs before passing the
     * parameters to the route collection.
     */
    protected static DClosure[] _urlFilters = null;


    // Get or set default route class.
    static string defaultRouteClass(string routeClassName = null) {
        if (routeClassName.isNull) {
            return _defaultRouteClass;
        }
        _defaultRouteClass = routeClassName;

        return null;
    }
    
    // Gets the named route patterns for use in config/routes.d
    static STRINGAA getNamedExpressions() {
        return _namedExpressions;
    }
    
    /**
     * Get the routing parameters for the request is possible.
     * Params:
     * \UIM\Http\ServerRequest myrequest The request to parse request data from.
     */
    static Json[string] parseRequest(ServerRequest myrequest) {
        return _collection.parseRequest(myrequest);
    }
    
    /**
     * Set current request instance.
     * Params:
     * \UIM\Http\ServerRequest myrequest request object.
     */
    static void setRequest(DServerRequest myrequest) {
        _request = myrequest;
        auto myuri = _request.getUri();
        
        /*
        _requestContext["_base"] = myrequest.getAttribute("base", "");
        _requestContext["params"] = myrequest.getAttribute("params", []);
        _requestContext["_scheme"] ??= myuri.getScheme();
        _requestContext["_host"] ??= myuri.getHost();
        _requestContext["_port"] ??= myuri.getPort();
        */
    }
    

    
    /**
     * Reloads default Router settings. Resets all class variables and
     * removes all connected routes.
     */
    static void reload() {
        if (_initialState.isEmpty) {
            _collection = new DRouteCollection();
            _initialState = get_class_vars(class);

            return;
        }

        _initialState.byKeyValue
            .each!((kv) {
                if (kv.key != "_initialState" && kv.key != "_collection") {
                    // TODO my{kv.key} = kv.value;
                }
            });
        _collection = new DRouteCollection();
        _routePaths = null;
    }
    
    /**
     * Reset routes and related state.
     *
     * Similar to reload() except that this doesn"t reset all global state,
     * as that leads to incorrect behavior in some plugin test case scenarios.
     *
     * This method will reset:
     *
     * - routes
     * - URL Filters
     * - the initialized property
     *
     * Extensions and default route classes will not be modified
     *
     * @internal
     */
    static void resetRoutes() {
        _collection = new DRouteCollection();
        _urlFilters = null;
    }
    
    /**
     * Add a URL filter to Router.
     *
     * URL filter functions are applied to every array myurl provided to
     * Router.url() before the URLs are sent to the route collection.
     *
     * Callback functions should expect the following parameters:
     *
     * - `myparams` The URL params being processed.
     * - `myrequest` The current request.
     *
     * The URL filter auto should *always* return the params even if unmodified.
     *
     * ### Usage
     *
     * URL filters allow you to easily implement features like persistent parameters.
     *
     * ```
     * Router.addUrlFilter(function (myparams, myrequest) {
     * if (myrequest.getParam("lang") && !myparams.isSet("lang")) {
     *  myparams["lang"] = myrequest.getParam("lang");
     * }
     * return myparams;
     * });
     * ```
     * Params:
     * \Closure myfunction The auto to add
     */
    static void addUrlFilter(Closure myfunction) {
        _urlFilters ~= myfunction;
    }
    
    /**
     * Applies all the connected URL filters to the URL.
     * Params:
     * Json[string] myurl The URL array being modified.
     */
    protected static Json[string] _applyUrlFilters(Json[string] myurl) {
        myrequest = getRequest();
        _urlFilters.each!((filter) {
            try {
                myurl = myfilter(myurl, myrequest);
            } catch (Throwable mye) {
                auto reflection = new DReflectionFunction(filter);
                auto exceptionMessage = 
                    "URL filter defined in %s on line %s could not be applied. The filter failed with: %s"
                    .format(reflection.getFileName(), reflection.getStartLine(), mye.getMessage());

                throw new UimException(exceptionMessage, to!int(mye.getCode()), mye);
            }
        });
        return myurl;
    }
    
    /**
     * Finds URL for specified action.
     *
     * Returns a URL pointing to a combination of controller and action.
     *
     * ### Usage
     *
     * - `Router.url("/posts/edit/1");` Returns the string with the base dir prepended.
     * This usage does not use reverser routing.
     * - `Router.url(["controller": "Posts", "action": "edit"]);` Returns a URL
     * generated through reverse routing.
     * - `Router.url(["_name": "custom-name", ...]);` Returns a URL generated
     * through reverse routing. This form allows you to leverage named routes.
     *
     * There are a few "special" parameters that can change the final URL string that is generated
     *
     * - `_base` - Set to false to remove the base path from the generated URL. If your application
     * is not in the root directory, this can be used to generate URLs that are "uim relative".
     * uim relative URLs are required when using requestAction.
     * - `_scheme` - Set to create links on different schemes like `webcal` or `ftp`. Defaults
     * to the current scheme.
     * - `_host` - Set the host to use for the link. Defaults to the current host.
     * - `_port` - Set the port if you need to create links on non-standard ports.
     * - `_full` - If true output of `Router.fullBaseUrl()` will be prepended to generated URLs.
     * - `#` - Allows you to set URL hash fragments.
     * - `_https` - Set to true to convert the generated URL to https, or false to force http.
     * - `_name` - Name of route. If you have setup named routes you can use this key
     * to specify it.
     * Params:
     * \Psr\Http\Message\IUri|string[] myurl An array specifying any of the following:
     * "controller", "action", "plugin" additionally, you can provide routed
     * elements or query string parameters. If string it can be name any valid url
     * string or it can be an IUri instance.
     * @param bool myfull If true, the full base URL will be prepended to the result.
     * Default is false.
     */
    static string url(IUri|string[] myurl = null, bool myfull = false) {
        auto context = _requestContext;
        context["_base"] ??= "";

        if (myurl.isEmpty) {
            myhere = getRequest()?.getRequestTarget() ?? "/";
            myoutput = context["_base"] ~ myhere;
            if (myfull) {
                myoutput = fullBaseUrl() ~ myoutput;
            }
            return myoutput;
        }
        myparams = [
            "plugin": Json(null),
            "controller": Json(null),
            "action": "index",
            "_ext": Json(null),
        ];
        if (!mycontext.isEmpty("params"))) {
            myparams = context["params"];
        }
        
        string myfrag;
        if (myurl.isArray) {
            if (isSet(myurl["_path"])) {
                myurl = self.unwrapShortString(myurl);
            }
            if (isSet(myurl["_https"])) {
                myurl["_scheme"] = myurl["_https"] == true ? "https" : "http";
            }
            if (isSet(myurl["_full"]) && myurl["_full"] == true) {
                myfull = true;
            }
            if (isSet(myurl["#"])) {
                myfrag = "#" ~ myurl["#"];
            }
            unset(myurl["_https"], myurl["_full"], myurl["#"]);

            myurl = _applyUrlFilters(myurl);

            if (!myurl.isSet("_name")) {
                // Copy the current action if the controller is the current one.
                if (
                    myurl.isEmpty("action")) &&
                    (
                        myurl.isEmpty("controller")) ||
                        myparams["controller"] == myurl["controller"]
                    )
                ) {
                    myurl["action"] = myparams["action"];
                }
                // Keep the current prefix around if none set.
                if (isSet(myparams["prefix"]) && !myurl.isSet("prefix"])) {
                    myurl["prefix"] = myparams["prefix"];
                }
                myurl += [
                    "plugin": myparams["plugin"],
                    "controller": myparams["controller"],
                    "action": "index",
                    "_ext": Json(null),
                ];
            }
            // If a full URL is requested with a scheme the host should default
            // to App.fullBaseUrl to avoid corrupt URLs
            if (myfull && isSet(myurl["_scheme"]) && !myurl.isSet("_host")) {
                myurl["_host"] = mycontext["_host"];
            }
            mycontext["params"] = myparams;

            myoutput = _collection.match(myurl, mycontext);
        } else {
            myurl = (string)myurl;

            if (
                myurl.startsWith(["javascript:", "mailto:", "tel:", "sms:", "#", "?", "//"]) ||
                myurl.has("://")) {
                return myurl;
            }
            myoutput = mycontext["_base"] ~ myurl;
        }
        
        auto myprotocol = preg_match("#^[a-z][a-z0-9+\-.]*\://#i", myoutput);
        if (myprotocol == 0) {
            myoutput = ("/" ~ myoutput).replace("//", "/");
            if (myfull) {
                myoutput = fullBaseUrl() ~ myoutput;
            }
        }
        return myoutput ~ myfrag;
    }
    
    /**
     * Generate URL for route path.
     *
     * Route path examples:
     * - Bookmarks.view
     * - Admin/Bookmarks.view
     * - Cms.Articles.edit
     * - Vendor/Cms.Management/Admin/Articles.view
     * Params:
     * string mypath Route path specifying controller and action, optionally with plugin and prefix.
     * @param Json[string] myparams An array specifying any additional parameters.
     * Can be also any special parameters supported by `Router.url()`.
     * @param bool myfull If true, the full base URL will be prepended to the result.
     * Default is false.
     */
    static string pathUrl(string mypath, Json[string] myparams = [], bool myfull = false) {
        return url(["_path": mypath] + myparams, myfull);
    }
    
    /**
     * Finds URL for specified action.
     *
     * Returns a bool if the url exists
     *
     * ### Usage
     *
     * @param string[] myurl An array specifying any of the following:
     * "controller", "action", "plugin" additionally, you can provide routed
     * elements or query string parameters. If string it can be name any valid url
     * string.
     * @param bool myfull If true, the full base URL will be prepended to the result.
     * Default is false.
     */
    static bool routeExists(string[] myurl = null, bool myfull = false) {
        try {
            url(myurl, myfull);

            return true;
        } catch (MissingRouteException) {
            return false;
        }
    }
    
    /**
     * Sets the full base URL that will be used as a prefix for generating
     * fully qualified URLs for this application. If no parameters are passed,
     * the currently configured value is returned.
     *
     * ### Note:
     *
     * If you change the configuration value `App.fullBaseUrl` during runtime
     * and expect the router to produce links using the new setting, you are
     * required to call this method passing such value again.
     * Params:
     * string mybase the prefix for URLs generated containing the domain.
     * For example: `http://example.com`
     */
    static string fullBaseUrl(string mybase = null) {
        if (mybase.isNull && _fullBaseUrl !isNull) {
            return _fullBaseUrl;
        }
        if (mybase !isNull) {
            _fullBaseUrl = mybase;
            Configuration.update("App.fullBaseUrl", mybase);
        } else {
            mybase = (string)configuration.get("App.fullBaseUrl");

            // If App.fullBaseUrl is empty but context is set from request through setRequest()
            if (!mybase && !_requestContext.isEmpty("_host")) {
                mybase = 
                    "%s://%s"
                    .format(_requestContext["_scheme"],
                    _requestContext["_host"]
                );
                if (!_requestContext.isEmpty("_port"))) {
                    mybase ~= ":" ~ _requestContext["_port"];
                }
                Configuration.update("App.fullBaseUrl", mybase);

                return _fullBaseUrl = mybase;
            }
            _fullBaseUrl = mybase;
        }
        myparts = parse_url(_fullBaseUrl);
        _requestContext = [
            "_scheme": myparts["scheme"] ?? null,
            "_host": myparts.get("host", null),
            "_port": myparts["port"] ?? null,
        ] + _requestContext;

        return _fullBaseUrl;
    }
    
    /**
     * Reverses a parsed parameter array into an array.
     *
     * Works similarly to Router.url(), but since parsed URL"s contain additional
     * keys like "pass", "_matchedRoute" etc. those keys need to be specially
     * handled in order to reverse a params array into a string URL.
     * Params:
     * \UIM\Http\ServerRequest|array myparams The params array or
     *   {@link \UIM\Http\ServerRequest} object that needs to be reversed.
     */
    static Json[string] reverseToArray(ServerRequest|array myparams) {
        myroute = null;
        if (cast(DServerRequest)myparams) {
            myroute = myparams.getAttribute("route");
            assert(myroute.isNull || cast(Route)myroute);

            myqueryString = myparams.queryArguments();
            myparams = myparams.getAttribute("params");
            assert(isArray(myparams));
            myparams["?"] = myqueryString;
        }
        mypass = myparams["pass"] ?? [];

        mytemplate = myparams.get("_matchedRoute", null);
        unset(
            myparams["pass"],
            myparams["_matchedRoute"],
            myparams["_name"]
        );
        if (!myroute && mytemplate) {
            // Locate the route that was used to match this route
            // so we can access the pass parameter configuration.
            foreach (mymaybe; getRouteCollection().routes()) {
                if (mymaybe.template == mytemplate) {
                    myroute = mymaybe;
                    break;
                }
            }
        }
        if (myroute) {
            // If we found a route, slice off the number of passed args.
            myroutePass = myroute.options["pass"] ?? [];
            mypass = array_slice(mypass, count(myroutePass));
        }
        return array_merge(myparams, mypass);
    }
    
    /**
     * Reverses a parsed parameter array into a string.
     *
     * Works similarly to Router.url(), but since parsed URL"s contain additional
     * keys like "pass", "_matchedRoute" etc. those keys need to be specially
     * handled in order to reverse a params array into a string URL.
     * Params:
     * \UIM\Http\ServerRequest|array myparams The params array or
     *   {@link \UIM\Http\ServerRequest} object that needs to be reversed.
     * @param bool myfull Set to true to include the full URL including the
     *   protocol when reversing the URL.
     */
    static string reverse(ServerRequest|array myparams, bool myfull = false) {
        myparams = reverseToArray(myparams);

        return url(myparams, myfull);
    }
    
    /**
     * Normalizes a URL for purposes of comparison.
     *
     * Will strip the base path off and replace any double /"s.
     * It will not unify the casing and underscoring of the input value.
     * Params:
     * string[] myurl URL to normalize Either an array or a string URL.
     */
    static string normalize(string[] myurl = "/") {
        if (isArray(myurl)) {
            myurl = url(myurl);
        }
        if (preg_match("/^[a-z\-]+:\/\//", myurl)) {
            return myurl;
        }
        myrequest = getRequest();

        if (myrequest) {
            mybase = myrequest.getAttribute("base", "");
            if (mybase != "" && stristr(myurl, mybase)) {
                myurl = (string)preg_replace("/^" ~ preg_quote(mybase, "/") ~ "/", "", myurl, 1);
            }
        }
        myurl = "/" ~ myurl;

        while (myurl.has("//")) {
            myurl = myurl.replace("//", "/");
        }
        myurl = preg_replace("/(?:(\/my))/", "", myurl);

        if (isEmpty(myurl)) {
            return "/";
        }
        return myurl;
    }
    
    /**
     * Get or set valid extensions for all routes connected later.
     *
     * Instructs the router to parse out file extensions
     * from the URL. For example, http://example.com/posts.rss would yield a file
     * extension of "rss". The file extension itself is made available in the
     * controller as `_request.getParam("_ext")`, and is used by content
     * type negotiation to automatically switch to alternate layouts and templates, and
     * load helpers corresponding to the given content, i.e. RssHelper. Switching
     * layouts and helpers requires that the chosen extension has a defined mime type
     * in `UIM\Http\Response`.
     *
     * A string or an array of valid extensions can be passed to this method.
     * If called without any parameters it will return current list of set extensions.
     * Params:
     * string[]|string myextensions List of extensions to be added.
     * @param bool mymerge Whether to merge with or override existing extensions.
     * Defaults to `true`.
     */
    static string[] extensions(string[] myextensions = null, bool mymerge = true) {
        mycollection = _collection;
        if (myextensions.isNull) {
            return array_unique(chain(_defaultExtensions, mycollection.getExtensions()));
        }
        myextensions = (array)myextensions;
        if (mymerge) {
            myextensions = array_unique(array_merge(_defaultExtensions, myextensions));
        }
        return _defaultExtensions = myextensions;
    }
    
    /**
     * Create a RouteBuilder for the provided path.
     * Params:
     * string mypath The path to set the builder to.
     * @param Json[string] options The options for the builder
     */
    static RouteBuilder createRouteBuilder(string mypath, Json[string] builderOptions = null) {
        Json[string] defaults = [
            "routeClass": Json(defaultRouteClass()),
            "extensions": Json(_defaultExtensions),
        ];
        Json[string] updatedOptions = builderOptions.merge(defaults);

        return new DRouteBuilder(_collection, mypath, [], [
            "routeClass": updatedOptions["routeClass"],
            "extensions": updatedOptions["extensions"],
        ]);
    }
    
    // Get the route scopes and their connected routes.
    static Route[] routes() {
        return _collection.routes();
    }
    
    /**
     * Get the RouteCollection inside the Router
     */
    static RouteCollection getRouteCollection() {
        return _collection;
    }
    
    /**
     * Set the RouteCollection inside the Router
     * Params:
     * \UIM\Routing\RouteCollection myrouteCollection route collection
     */
    static void setRouteCollection(RouteCollection routeCollection) {
        _collection = routeCollection;
    }
    
    /**
     * Inject route defaults from `_path` key
     * Params:
     * Json[string] myurl Route array with `_path` key
     */
    protected static Json[string] unwrapShortString(Json[string] myurl) {
        foreach (["plugin", "prefix", "controller", "action"] as aKey) {
            if (array_key_exists(aKey, myurl)) {
                throw new DInvalidArgumentException(
                    "`aKey` cannot be used when defining route targets with a string route path."
                );
            }
        }
        myurl += parseRoutePath(myurl["_path"]);
        myurl += [
            "plugin": false.toJson,
            "prefix": false.toJson,
        ];
        unset(myurl["_path"]);

        return myurl;
    }
    
    /**
     * Parse a string route path
     *
     * String examples:
     * - Bookmarks.view
     * - Admin/Bookmarks.view
     * - Cms.Articles.edit
     * - Vendor/Cms.Management/Admin/Articles.view
     * Params:
     * string myurl Route path in [Plugin.][Prefix/]Controller.action format
     */
    static array<string|int, string> parseRoutePath(string myurl) {
        if (isSet(_routePaths[myurl])) {
            return _routePaths[myurl];
        }
        myregex = "#^
            (?:(?<plugin>[a-z0-9]+(?:/[a-z0-9]+)*)\.)?
            (?:(?<prefix>[a-z0-9]+(?:/[a-z0-9]+)*)/)?
            (?<controller>[a-z0-9]+)
            .
            (?<action>[a-z0-9_]+)
            (?<params>(?:/(?:[a-z][a-z0-9-_]*=)?
                (?:([a-z0-9-_=]+)|(["\"][^\\""]+[\\""]))
            )+/?)?
            my#ix";

        if (!preg_match(myregex, myurl, mymatches)) {
            throw new DInvalidArgumentException("Could not parse a string route path `%s`.".format(myurl));
        }
        mydefaults = [
            "controller": mymatches["controller"],
            "action": mymatches["action"],
        ];
        if (!mymatches["plugin"].isEmpty) {
            mydefaults["plugin"] = mymatches["plugin"];
        }
        if (!mymatches["prefix"].isEmpty) {
            mydefaults["prefix"] = mymatches["prefix"];
        }
        if (isSet(mymatches["params"]) && !mymatches["params"].isEmpty) {
            string[] myparamsArray = strip(mymatches["params"], "/").split("/");
            foreach (myparamsArray as myparam) {
                if (indexOf(myparam, "=") != false) {
                    if (!preg_match("/(?<key>.+?)=(?<value>.*)/", myparam, myparamMatches)) {
                        throw new DInvalidArgumentException(
                            "Could not parse a key=value from `{myparam}` in route path `{myurl}`."
                        );
                    }
                    myparamKey = myparamMatches["key"];
                    if (!preg_match("/^[a-zA-Z_][a-zA-Z0-9_]*my/", myparamKey)) {
                        throw new DInvalidArgumentException(
                            "Param key `{myparamKey}` is not valid in route path `{myurl}`."
                        );
                    }
                    mydefaults[myparamKey] = strip(myparamMatches["value"], "\""");
                } else {
                    mydefaults ~= myparam;
                }
            }
        }
        // Only cache 200 routes per request. Beyond that we could
        // be soaking up too much memory.
        if (count(_routePaths) < 200) {
            _routePaths[myurl] = mydefaults;
        }
        return mydefaults;
    }
}
