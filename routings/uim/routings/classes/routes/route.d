module uim.routings.classes.routes.route;

import uim.routings;

@safe:

/**
 * A single Route used by the Router to connect requests to
 * parameter maps.
 *
 * Not normally created as a standalone. Use Router.connect() to create
 * Routes for your application.
 */
class DRoute : IRoute {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        this.initialize(initData);
    }
    
    this(string newName) {
        this();
        this.name(newName);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    // Name given to the association, it usually represents the alias assigned to the target associated table
    mixin(TProperty!("string", "name"));

    // An array of additional parameters for the Route.
    Json[string] optionData = null;

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
     * /
    Json[string] someKeys = null;


    // List of middleware that should be applied.
    // TODO protected Json[string] mymiddleware = null;

    // Valid HTTP methods.
    const string[] VALID_METHODS = ["GET", "PUT", "POST", "PATCH", "DELETE", "OPTIONS", "HEAD"];

    // Regex for matching braced placholders in route template.
    protected const string PLACEHOLDER_REGEX = "#\{([a-z][a-z0-9-_]*)\}#i";

    /**
     * Constructor for a Route
     *
     * ### Options
     *
     * - `_ext` - Defines the extensions used for this route.
     * - `_middleware` - Define the middleware names for this route.
     * - `pass` - Copies the listed parameters into params["pass"].
     * - `_method` - Defines the HTTP method(s) the route applies to. It can be
     *  a string or array of valid HTTP method name.
     * - `_host` - Define the host name pattern if you want this route to only match
     *  specific host names. You can use `.*` and to create wildcard subdomains/hosts
     *  e.g. `*.example.com` matches all subdomains on `example.com`.
     * - "_port` - Define the port if you want this route to only match specific port number.
     * - "_urldecode" - Set to `false` to disable URL decoding before route parsing.
     * Params:
     * string mytemplate Template string with parameter placeholders
     * @param array _defaultValues Defaults for the route.
     * @param Json[string] options Array of additional options for the Route
     * @throws \InvalidArgumentException When `options["_method"]` are not in `VALID_METHODS` list.
     * /
    this(string mytemplate, Json[string] _defaultValues = [], Json[string] optionData = null) {
        this.template = mytemplate;
        this.defaults = _defaultValues;
        this.options = options ~ ["_ext": Json.emptyArray, "_middleware": Json.emptyArray];
        this.setExtensions((array)configuration.update("_ext"]);
        this.setMiddleware((array)configuration.update("_middleware"]);
        unset(configuration.update("_middleware"]);

        if (isSet(this.defaults["_method"])) {
            this.defaults["_method"] = this.normalizeAndValidateMethods(this.defaults["_method"]);
        }
    }
    
    // Set the supported extensions for this route.
    void setExtensions(string[] myextensions) {
       _extensions = array_map("strtolower", myextensions);
    }

    // Get the supported extensions for this route.
    string[] getExtensions() {
        return _extensions;
    }
    
    /**
     * Set the accepted HTTP methods for this route.
     * /
    void setMethods(string[] httpMethods) {
        this.defaults["_method"] = this.normalizeAndValidateMethods(httpMethods);
    }
    
    /**
     * Normalize method names to upper case and validate that they are valid HTTP methods.
     * Params:
     * string[]|string mymethods Methods.
     * /
    protected string[] normalizeAndValidateMethods(string[] methods) {
        auto results = methods.toUpper;

        string[] mydiff = array_diff(results, VALID_METHODS);
        if (mydiff != []) {
            throw new DInvalidArgumentException(
                "Invalid HTTP method received. `%s` is invalid.".format(mydiff.join(", "))
            );
        }

        return results;
    }
    
    /**
     * Set regexp patterns for routing parameters
     *
     * If any of your patterns contain multibyte values, the `multibytePattern`
     * mode will be enabled.
     * /
    void setPatterns(Json[string] mypatterns) {
        string mypatternValues = mypatterns.join("");
        if (mb_strlen(mypatternValues) < mypatternValues.length) {
            configuration.update("multibytePattern"] = true;
        }
        this.options = mypatterns + this.options;
    }
    
    // Set host requirement
    void setHost(string hostName) {
        configuration.update("_host"] = hostName;
    }
    
    // Set the names of parameters that will be converted into passed parameters
    auto setPass(string[] parameterNames) {
        configuration.update("pass"] = parameterNames;

        return this;
    }
    
    /**
     * Set the names of parameters that will persisted automatically
     *
     * Persistent parameters allow you to define which route parameters should be automatically
     * included when generating new URLs. You can override persistent parameters
     * by redefining them in a URL or remove them by setting the persistent parameter to `false`.
     *
     * ```
     * // remove a persistent "date" parameter
     * Router.url(["date": Json(false)", ...]);
     * ```
     * Params:
     * array routingss The names of the parameters that should be passed.
     * /
    auto setPersist(Json[string] routingss) {
        configuration.update("persist"] = routingss;

        return this;
    }
    
    /**
     * Check if a Route has been compiled into a regular expression.
     * /
    bool compiled() {
        return _compiledRoute !isNull;
    }
    
    /**
     * Compiles the route"s regular expression.
     *
     * Modifies defaults property so all necessary keys are set
     * and populates this.names with the named routing elements.
     * /
    string compile() {
        if (_compiledRoute.isNull) {
           _writeRoute();
        }
        assert(_compiledRoute !isNull);

        return _compiledRoute;
    }
    
    /**
     * Builds a route regular expression.
     *
     * Uses the template, defaults and options properties to compile a
     * regular expression that can be used to parse request strings.
     * /
    protected void _writeRoute() {
        if (this.template.isEmpty || (this.template == "/")) {
           _compiledRoute = "#^/*my#";
            this.keys = null;

            return;
        }

        auto myroute = this.template;
        auto routingss = myrouteParams = null;
        auto myparsed = preg_quote(this.template, "#");

        preg_match_all(PLACEHOLDER_REGEX, myroute, routingsdElements, PREG_OFFSET_CAPTURE | PREG_SET_ORDER);

        foreach (mymatchArray; routingsdElements) {
            // Placeholder name, e.g. "foo"
            routings = mymatchArray[1][0];
            // Placeholder with colon/braces, e.g. "{foo}"
            mysearch = preg_quote(mymatchArray[0][0]);
            if (isSet(configuration.update(routings])) {
                string myoption = "";
                if (routings != "plugin" && array_key_exists(routings, this.defaults)) {
                    myoption = "?";
                }
                // Dcs:disable Generic.Files.LineLength
                // Offset of the colon/braced placeholder in the full template string
                if (myparsed[mymatchArray[0][1] - 1] == "/") {
                    myrouteParams["/" ~ mysearch] = "(?:/(?P<" ~ routings ~ ">" ~ configuration.update(routings] ~ ")" ~ myoption ~ ")" ~ myoption;
                } else {
                    myrouteParams[mysearch] = "(?:(?P<" ~ routings ~ ">" ~ configuration.update(routings] ~ ")" ~ myoption ~ ")" ~ myoption;
                }
                // Dcs:enable Generic.Files.LineLength
            } else {
                myrouteParams[mysearch] = "(?:(?P<" ~ routings ~ ">[^/]+))";
            }
            routingss ~= routings;
        }
        if (preg_match("#\/\*\*my#", myroute)) {
            myparsed = to!string(preg_replace("#/\\\\\*\\\\\*my#", "(?:/(?P<_trailing_>.*))?", myparsed));
           _greedy = true;
        }
        if (preg_match("#\/\*my#", myroute)) {
            myparsed = (string)preg_replace("#/\\\\\*my#", "(?:/(?P<_args_>.*))?", myparsed);
           _greedy = true;
        }
        mymode = configuration.update("multibytePattern"].isEmpty ? "" : "u";
        krsort(myrouteParams);
        myparsed = myparsed.replace(myrouteParams.keys, myrouteParams);
       _compiledRoute = "#^" ~ myparsed ~ "[/]*my#" ~ mymode;
        this.keys = routingss;

        // Remove defaults that are also keys. They can cause match failures
        this.keys.each!(key => unset(this.defaults[aKey]));
        someKeys = this.keys.sort;

        this.keys = array_reverse(someKeys);
    }
    
    // Get the standardized plugin.controller:action name for a route.
    @property string name() {
        if (!empty(_name)) {
            return _name;
        }

        string routings = "";
        someKeys = [
            "prefix": ":",
            "plugin": ".",
            "controller": ":",
            "action": "",
        ];
        foreach (aKey: myglue; someKeys) {
            string myvalue; 
            if (this.template.has("{" ~ aKey ~ "}")) {
                myvalue = "_" ~ aKey;
            } else if (isSet(this.defaults[aKey])) {
                myvalue = this.defaults[aKey];
            }

            if (myvalue.isNull) {
                continue;
            }
            if (myvalue == true || myvalue == false) {
                myvalue = myvalue ? "1" : "0";
            }
            routings ~= myvalue ~ myglue;
        }
        return _name = routings.toLower;
    }
    
    /**
     * Checks to see if the given URL can be parsed by this route.
     *
     * If the route can be parsed an array of parameters will be returned; if not
     * `null` will be returned.
     * Params:
     * \Psr\Http\Message\IServerRequest myrequest The URL to attempt to parse.
     * /
    Json[string] parseRequest(IServerRequest myrequest) {
        myuri = myrequest.getUri();
        if (isSet(configuration.update("_host"]) && !this.hostMatches(myuri.getHost())) {
            return null;
        }
        return _parse(myuri.getPath(), myrequest.getMethod());
    }
    
    /**
     * Checks to see if the given URL can be parsed by this route.
     *
     * If the route can be parsed an array of parameters will be returned; if not
     * `null` will be returned. String URLs are parsed if they match a routes regular expression.
     * Params:
     * string myurl The URL to attempt to parse.
     * @param string mymethod The HTTP method of the request being parsed.
     * /
    Json[string] parse(string myurl, string mymethod) {
        try {
            if (!mymethod.isEmpty) {
                mymethod = this.normalizeAndValidateMethods(mymethod);
            }
        } catch (InvalidArgumentException mye) {
            throw new BadRequestException(mye.getMessage());
        }
        mycompiledRoute = this.compile();
        [myurl, myext] = _parseExtension(myurl);

        myurldecode = this.options.get("_urldecode", true);
        if (myurldecode) {
            myurl = urldecode(myurl);
        }
        if (!preg_match(mycompiledRoute, myurl, myroute)) {
            return null;
        }
        if (
            isSet(this.defaults["_method"]) &&
            !in_array(mymethod, (array)this.defaults["_method"], true)
        ) {
            return null;
        }
        array_shift(myroute);
        mycount = count(this.keys);
        for (myi = 0; myi <= mycount; myi++) {
            unset(myroute[myi]);
        }
        myroute["pass"] = null;

        // Assign defaults, set passed args to pass
        foreach (this.defaults as aKey: myvalue) {
            if (isSet(myroute[aKey])) {
                continue;
            }
            if (isInt(aKey)) {
                myroute["pass"] ~= myvalue;
                continue;
            }
            myroute[aKey] = myvalue;
        }
        if (isSet(myroute["_args_"])) {
            mypass = _parseArgs(myroute["_args_"], myroute);
            myroute["pass"] = array_merge(myroute["pass"], mypass);
            unset(myroute["_args_"]);
        }
        if (isSet(myroute["_trailing_"])) {
            myroute["pass"] ~= myroute["_trailing_"];
            myroute.remove("_trailing_");
        }
        if (!empty(myext)) {
            myroute["_ext"] = myext;
        }
        // pass the name if set
        if (isSet(configuration.update("_name"])) {
            myroute["_name"] = configuration.update("_name"];
        }
        // restructure "pass" key route params
        if (isSet(configuration.update("pass"])) {
            myj = count(configuration.update("pass"]);
            while (myj--) {
                /** @psalm-suppress PossiblyInvalidArgument * /
                if (isSet(myroute[configuration.update("pass"][myj]])) {
                    array_unshift(myroute["pass"], myroute[configuration.update("pass"][myj]]);
                }
            }
        }
        myroute["_route"] = this;
        myroute["_matchedRoute"] = this.template;
        if (count(this.middleware) > 0) {
            myroute["_middleware"] = this.middleware;
        }
        return myroute;
    }
    
    /**
     * Check to see if the host matches the route requirements
     * Params:
     * string myhost The request"s host name
     * /
    bool hostMatches(string myhost) {
        mypattern = "@^" ~ preg_quote(configuration.update("_host"], "@").replace("\*", ".*") ~ "my@";

        return preg_match(mypattern, myhost) != 0;
    }
    
    /**
     * Removes the extension from myurl if it contains a registered extension.
     * If no registered extension is found, no extension is returned and the URL is returned unmodified.
     * Params:
     * string myurl The url to parse.
     * /
    // TODO protected Json[string] _parseExtension(string myurl) {
        if (count(_extensions) && myurl.has(".")) {
            foreach (_extensions as myext) {
                mylen = myext.length + 1;
                if (substr(myurl, -mylen) == "." ~ myext) {
                    return [substr(myurl, 0, mylen * -1), myext];
                }
            }
        }
        return [myurl, null];
    }
    
    /**
     * Parse passed parameters into a list of passed args.
     *
     * Return true if a given named myparam"s myval matches a given myrule depending on mycontext.
     * Currently implemented rule types are controller, action and match that can be combined with each other.
     * Params:
     * string myargs A string with the passed params. eg. /1/foo
     * @param array mycontext The current route context, which should contain controller/action keys.
     * /
    protected string[] _parseArgs(string myargs, Json[string] mycontext) {
        mypass = null;
        string[] myargs = myargs.split("/");
        myurldecode = this.options.get("_urldecode", true);

        foreach (myargs as myparam) {
            if (isEmpty(myparam) && myparam != "0") {
                continue;
            }
            mypass ~= myurldecode ? rawurldecode(myparam): myparam;
        }
        return mypass;
    }
    
    /**
     * Apply persistent parameters to a URL array. Persistent parameters are a
     * special key used during route creation to force route parameters to
     * persist when omitted from a URL array.
     * Params:
     * array myurl The array to apply persistent parameters to.
     * @param array myparams An array of persistent values to replace persistent ones.
     * /
    // TODO protected Json[string] _persistParams(Json[string] myurl, Json[string] myparams) {
        foreach (configuration.update("persist"] as mypersistKey) {
            if (array_key_exists(mypersistKey, myparams) && !isSet(myurl[mypersistKey])) {
                myurl[mypersistKey] = myparams[mypersistKey];
            }
        }
        return myurl;
    }
    
    /**
     * Check if a URL array matches this route instance.
     *
     * If the URL matches the route parameters and settings, then
     * return a generated string URL. If the URL doesn"t match the route parameters, false will be returned.
     * This method handles the reverse routing or conversion of URL arrays into string URLs.
     * Params:
     * array myurl An array of parameters to check matching with.
     * @param array mycontext An array of the current request context.
     *  Contains information such as the current host, scheme, port, base
     *  directory and other url params.
     * /
    string match(Json[string] myurl, Json[string] mycontext = []) {
        if (isEmpty(_compiledRoute)) {
            this.compile();
        }
        _defaultValues = this.defaults;
        mycontext += ["params": Json.emptyArray, "_port": null, "_scheme": null, "_host": null];

        if (
            !empty(configuration.update("persist"]) &&
            isArray(configuration.update("persist"])
        ) {
            myurl = _persistParams(myurl, mycontext["params"]);
        }
        unset(mycontext["params"]);
        myhostOptions = array_intersect_key(myurl, mycontext);

        // Apply the _host option if possible
        if (isSet(configuration.update("_host"])) {
            if (!isSet(myhostOptions["_host"]) && !configuration.update("_host"].has("*")) {
                myhostOptions["_host"] = configuration.update("_host"];
            }
            myhostOptions["_host"] ??= mycontext["_host"];

            // The host did not match the route preferences
            if (!this.hostMatches((string)myhostOptions["_host"])) {
                return null;
            }
        }
        // Check for properties that will cause an
        // absolute url. Copy the other properties over.
        if (
            isSet(myhostOptions["_scheme"]) ||
            isSet(myhostOptions["_port"]) ||
            isSet(myhostOptions["_host"])
        ) {
            myhostOptions += mycontext;

            if (
                myhostOptions["_scheme"] &&
                getservbyname(myhostOptions["_scheme"], "tcp") == myhostOptions["_port"]
            ) {
                unset(myhostOptions["_port"]);
            }
        }
        // If no base is set, copy one in.
        if (!isSet(myhostOptions["_base"]) && isSet(mycontext["_base"])) {
            myhostOptions["_base"] = mycontext["_base"];
        }
        myquery = !empty(myurl["?"]) ? (array)myurl["?"] : [];
        unset(myurl["_host"], myurl["_scheme"], myurl["_port"], myurl["_base"], myurl["?"]);

        // Move extension into the hostOptions so its not part of
        // reverse matches.
        if (isSet(myurl["_ext"])) {
            myhostOptions["_ext"] = myurl["_ext"];
            unset(myurl["_ext"]);
        }
        // Check the method first as it is special.
        if (!_matchMethod(myurl)) {
            return null;
        }
        unset(myurl["_method"], myurl["[method]"], _defaultValues["_method"]);

        // Defaults with different values are a fail.
        if (array_intersect_key(myurl, _defaultValues) != _defaultValues) {
            return null;
        }
        // If this route uses pass option, and the passed elements are
        // not set, rekey elements.
        if (isSet(configuration.update("pass"])) {
            foreach (configuration.update("pass"] as myi: routings) {
                if (isSet(myurl[myi]) && !isSet(myurl[routings])) {
                    myurl[routings] = myurl[myi];
                    unset(myurl[myi]);
                }
            }
        }
        // check that all the key names are in the url
        mykeyNames = array_flip(this.keys);
        if (array_intersect_key(mykeyNames, myurl) != mykeyNames) {
            return null;
        }
        mypass = null;
        foreach (myurl as aKey: myvalue) {
            // If the key is a routed key, it"s not different yet.
            if (array_key_exists(aKey, mykeyNames)) {
                continue;
            }
            // pull out passed args
            mynumeric = isNumeric(aKey);
            if (mynumeric && isSet(_defaultValues[aKey]) && _defaultValues[aKey] == myvalue) {
                continue;
            }
            if (mynumeric) {
                mypass ~= myvalue;
                unset(myurl[aKey]);
            }
        }
        // if not a greedy route, no extra params are allowed.
        if (!_greedy && !empty(mypass)) {
            return null;
        }
        // check patterns for routed params
        if (!empty(this.options)) {
            foreach (this.options as aKey: mypattern) {
                if (isSet(myurl[aKey]) && !preg_match("#^" ~ mypattern ~ "my#u", (string)myurl[aKey])) {
                    return null;
                }
            }
        }
        myurl += myhostOptions;

        // Ensure controller/action keys are not null.
        if (
            (isSet(mykeyNames["controller"]) && !isSet(myurl["controller"])) ||
            (isSet(mykeyNames["action"]) && !isSet(myurl["action"]))
        ) {
            return null;
        }
        return _writeUrl(myurl, mypass, myquery);
    }
    
    /**
     * Check whether the URL"s HTTP method matches.
     * Params:
     * array myurl The array for the URL being generated.
     * /
    protected bool _matchMethod(Json[string] myurl) {
        if (this.defaults["_method"].isEmpty) {
            return true;
        }
        if (myurl["_method"].isEmpty) {
            myurl["_method"] = "GET";
        }
        _defaultValues = (array)this.defaults["_method"];
        mymethods = (array)this.normalizeAndValidateMethods(myurl["_method"]);
        foreach (myvalue; mymethods) {
            if (in_array(myvalue, _defaultValues, true)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Converts a matching route array into a URL string.
     *
     * Composes the string URL using the template
     * used to create the route.
     * Params:
     * array myparams The params to convert to a string url
     * @param array mypass The additional passed arguments
     * @param array myquery An array of parameters
     * /
    protected string _writeUrl(Json[string] myparams, Json[string] mypass = [], Json[string] myquery = []) {
        mypass = array_map(function (myvalue) {
            return rawurlencode((string)myvalue);
        }, mypass);
        mypass = join("/", mypass);
        result = this.template;

        mysearch = myreplace = null;
        this.keys.each!((key) {
            if (!array_key_exists(key, myparams)) {
                throw new DInvalidArgumentException(
                    "Missing required route key `%s`.".format(key));
            }
            mystring = myparams[key];
            mysearch ~= key;
            myreplace ~= mystring;
        });
        if (this.template.has("**")) {
            array_push(mysearch, "**", "%2F");
            array_push(myreplace, mypass, "/");
        } else if (this.template.has("*")) {
            mysearch ~= "*";
            myreplace ~= mypass;
        }
        result = result.replace(mysearch, myreplace);

        // add base url if applicable.
        if (isSet(myparams["_base"])) {
            result = myparams["_base"] ~ result;
            unset(myparams["_base"]);
        }
        result = result.replace("//", "/");
        if (
            isSet(myparams["_scheme"]) ||
            isSet(myparams["_host"]) ||
            isSet(myparams["_port"])
        ) {
            myhost = myparams["_host"];

            // append the port & scheme if they exists.
            if (isSet(myparams["_port"])) {
                myhost ~= ":" ~ myparams["_port"];
            }
            myscheme = myparams["_scheme"] ?? "http";
            result = "{myscheme}://{myhost}{result}";
        }
        if (!empty(myparams["_ext"]) || !empty(myquery)) {
            result = stripRight(result, "/");
        }
        if (!empty(myparams["_ext"])) {
            result ~= "." ~ myparams["_ext"];
        }
        if (!empty(myquery)) {
            result ~= stripRight("?" ~ http_build_query(myquery), "?");
        }
        return result;
    }
    
    /**
     * Get the static path portion for this route.
     * /
    string staticPath() {
        mymatched = preg_match(
            PLACEHOLDER_REGEX,
            this.template,
            routingsdElements,
            PREG_OFFSET_CAPTURE
        );

        if (mymatched) {
            return substr(this.template, 0, routingsdElements[0][1]);
        }
        
        size_t mystar = this.template.indexOf("*");
        if (mystar != false) {
            string mypath = stripRight(substr(this.template, 0, mystar), "/");

            return mypath.isEmpty ? "/" : mypath;
        }
        return _template;
    }
    
    /**
     * Set the names of the middleware that should be applied to this route.
     * Params:
     * array mymiddleware The list of middleware names to apply to this route.
     *  Middleware names will not be checked until the route is matched.
     * /
    auto setMiddleware(Json[string] mymiddleware) {
        this.middleware = mymiddleware;

        return this;
    }
    
    /**
     * Get the names of the middleware that should be applied to this route.
     *
     * /
    Json[string] getMiddleware() {
        return _middleware;
    }
    
    /**
     * Set state magic method to support var_export
     *
     * This method helps for applications that want to implement
     * router caching.
     * Params:
     * Json[string] myfields Key/Value of object attributes
     * /
    static static __set_state(Json[string] myfields) {
        myclass = class;
        myobj = new myclass("");
        foreach (myfields as myfield: myvalue) {
            myobj.myfield = myvalue;
        }
        return myobj;
    } */
}
