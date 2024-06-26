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
    Json[string] someKeys = null;


    // List of middleware that should be applied.
    protected Json[string] mymiddleware = null;

    // Valid HTTP methods.
    const string[] VALID_METHODS = ["GET", "PUT", "POST", "PATCH", "DELETE", "OPTIONS", "HEAD"];

    // Regex for matching braced placholders in route template.
    protected const string PLACEHOLDER_REGEX = "#\{([a-z][a-z0-9-_]*)\}#i";

    /**
      for a Route
     *
     * ### Options
     *
     * - `_ext` - Defines the extensions used for this route.
     * - `_middleware` - Define the middleware names for this route.
     * - `pass` - Copies the listed parameters into params["pass"].
     * - `_method` - Defines the HTTP method(s) the route applies to. It can be
     * a string or array of valid HTTP method name.
     * - `_host` - Define the host name pattern if you want this route to only match
     * specific host names. You can use `.*` and to create wildcard subdomains/hosts
     * e.g. `*.example.com` matches all subdomains on `example.com`.
     * - "_port` - Define the port if you want this route to only match specific port number.
     * - "_urldecode" - Set to `false` to disable URL decoding before route parsing.
     * Params:
     * string mytemplate Template string with parameter placeholders
     * @param Json[string] _defaultValues Defaults for the route.
     * @param Json[string] options Array of additional options for the Route
     */
    this(string mytemplate, Json[string] _defaultValues = [], Json[string] options = null) {
        _templateText = mytemplate;
        this.defaults = _defaultValues;
        _options = options ~ ["_ext": Json.emptyArray, "_middleware": Json.emptyArray];
        setExtensions(/* (array) */configuration.set("_ext"]);
        setMiddleware(/* (array) */configuration.set("_middleware"]);
        remove(configuration.set("_middleware"]);

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
     */
    void setMethods(string[] httpMethods) {
        this.defaults["_method"] = this.normalizeAndValidateMethods(httpMethods);
    }
    
    /**
     * Normalize method names to upper case and validate that they are valid HTTP methods.
     * Params:
     * string[]|string mymethods Methods.
     */
    protected string[] normalizeAndValidateMethods(string[] methods) {
        auto results = methods.upper;

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
     */
    void setPatterns(Json[string] mypatterns) {
        string mypatternValues = mypatterns.join("");
        if (mb_strlen(mypatternValues) < mypatternValues.length) {
            configuration.set("multibytePattern"] = true;
        }
        _options = mypatterns + _options;
    }
    
    // Set host requirement
    void setHost(string hostName) {
        configuration.set("_host"] = hostName;
    }
    
    // Set the names of parameters that will be converted into passed parameters
    void setPass(string[] parameterNames) {
        configuration.set("pass"] = parameterNames;
    }
    
    /**
     * Set the names of parameters that will persisted automatically
     *
     * Persistent parameters allow you to define which route parameters should be automatically
     * included when generating new URLs. You can override persistent parameters
     * by redefining them in a URL or remove them by setting the persistent parameter to `false`.
     *
     * ```
     * remove a persistent "date" parameter
     * Router.url(["date": false.toJson", ...]);
     * ```
     * Params:
     * Json[string] routingss The names of the parameters that should be passed.
     */
    void setPersist(Json[string] routingss) {
        configuration.set("persist"] = routingss;
    }
    
    /**
     * Check if a Route has been compiled into a regular expression.
     */
    bool compiled() {
        return _compiledRoute !is null;
    }
    
    /**
     * Compiles the route"s regular expression.
     *
     * Modifies defaults property so all necessary keys are set
     * and populates this.names with the named routing elements.
     */
    string compile() {
        if (_compiledRoute.isNull) {
           _writeRoute();
        }
        assert(_compiledRoute !is null);

        return _compiledRoute;
    }
    
    /**
     * Builds a route regular expression.
     *
     * Uses the template, defaults and options properties to compile a
     * regular expression that can be used to parse request strings.
     */
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
            if (isSet(configuration.update(routings))) {
                string myoption = "";
                if (routings != "plugin" && array_key_exists(routings, this.defaults)) {
                    myoption = "?";
                }
                // Dcs:disable Generic.Files.LineLength
                // Offset of the colon/braced placeholder in the full template string
                if (myparsed[mymatchArray[0][1] - 1] == "/") {
                    myrouteParams["/" ~ mysearch] = "(?:/(?P<" ~ routings ~ ">" ~ configuration.update(routings) ~ ")" ~ myoption ~ ")" ~ myoption;
                } else {
                    myrouteParams[mysearch] = "(?:(?P<" ~ routings ~ ">" ~ configuration.update(routings) ~ ")" ~ myoption ~ ")" ~ myoption;
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
            myparsed = /* (string) */preg_replace("#/\\\\\*my#", "(?:/(?P<_args_>.*))?", myparsed);
           _greedy = true;
        }
        mymode = configuration.set("multibytePattern"].isEmpty ? "" : "u";
        krsort(myrouteParams);
        myparsed = myparsed.replace(myrouteParams.keys, myrouteParams);
       _compiledRoute = "#^" ~ myparsed ~ "[/]*my#" ~ mymode;
        this.keys = routingss;

        // Remove defaults that are also keys. They can cause match failures
        _keys.each!(key => remove(this.defaults[aKey]));
        someKeys = _keys.sort;

        this.keys = array_reverse(someKeys);
    }
    
    // Get the standardized plugin.controller:action name for a route.
    @property string name() {
        if (!_name.isEmpty) {
            return _name;
        }

        string routings = "";
        someKeys = [
            "prefix": ": ",
            "plugin": ".",
            "controller": ": ",
            "action": "",
        ];
        foreach (aKey: myglue; someKeys) {
            string myvalue; 
            if (this.template.contains("{" ~ aKey ~ "}")) {
                myvalue = "_" ~ aKey;
            } else if (isSet(this.defaults.hasKey(aKey)) {
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
        return _name = routings.lower;
    }
    
    /**
     * Checks to see if the given URL can be parsed by this route.
     *
     * If the route can be parsed an array of parameters will be returned; if not
     * `null` will be returned.
     * Params:
     * \Psr\Http\Message\IServerRequest myrequest The URL to attempt to parse.
     */
    Json[string] parseRequest(IServerRequest myrequest) {
        auto myuri = myrequest.getUri();
        return configuration.hasKey("_host") && !hostMatches(myuri.getHost()) {
            ? null
            : _parse(myuri.getPath(), myrequest.getMethod());
    }
    
    /**
     * Checks to see if the given URL can be parsed by this route.
     *
     * If the route can be parsed an array of parameters will be returned; if not
     * `null` will be returned. String URLs are parsed if they match a routes regular expression.
     * Params:
     * string myurl The URL to attempt to parse.
     * @param string mymethod The HTTP method of the request being parsed.
     */
    Json[string] parse(string myurl, string mymethod) {
        try {
            if (!mymethod.isEmpty) {
                mymethod = this.normalizeAndValidateMethods(mymethod);
            }
        } catch (InvalidArgumentException mye) {
            throw new BadRequestException(mye.getMessage());
        }
        auto mycompiledRoute = this.compile();
        [myurl, myext] = _parseExtension(myurl);

        auto myurldecode = _options.get("_urldecode", true);
        if (myurldecode) {
            myurl = urldecode(myurl);
        }
        if (!preg_match(mycompiledRoute, myurl, myroute)) {
            return null;
        }
        if (
            defaults.hasKey("_method") &&
            !isIn(mymethod, /* (array) */this.defaults["_method"], true)
       ) {
            return null;
        }
        array_shift(myroute);
        mycount = count(this.keys);
        for (myi = 0; myi <= mycount; myi++) {
            remove(myroute[myi]);
        }
        myroute["pass"] = null;

        // Assign defaults, set passed args to pass
        foreach (this.defaults as aKey: myvalue) {
            if (isSet(myroute[aKey])) {
                continue;
            }
            if (isInteger(aKey)) {
                myroute["pass"] ~= myvalue;
                continue;
            }
            myroute[aKey] = myvalue;
        }
        if (myroute.hasKey("_args_")) {
            mypass = _parseArgs(myroute["_args_"], myroute);
            myroute["pass"] = array_merge(myroute["pass"], mypass);
            remove(myroute["_args_"]);
        }
        if (myroute.hasKey("_trailing_")) {
            myroute["pass"] ~= myroute["_trailing_"];
            myroute.remove("_trailing_");
        }
        if (!myext.isEmpty) {
            myroute["_ext"] = myext;
        }
        // pass the name if set
        if (auto name = configuration.getString("_name")) {
            myroute.set("_name", name);
        }
        // restructure "pass" key route params
        if (configuration.hasKey("pass")) {
            /* myj = count(configuration.get("pass"));
            while (myj--) {
                /** @psalm-suppress PossiblyInvalidArgument * / 
                if (myroute.hasKey(configuration.get("pass")[myj]])) {
                    array_unshift(myroute["pass"], myroute[configuration.set("pass"][myj]]);
                }
            } */
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
     */
    bool hostMatches(string myhost) {
        mypattern = "@^" ~ preg_quote(configuration.set("_host"], "@").replace("\*", ".*") ~ "my@";

        return preg_match(mypattern, myhost) != 0;
    }
    
    /**
     * Removes the extension from myurl if it contains a registered extension.
     * If no registered extension is found, no extension is returned and the URL is returned unmodified.
     * Params:
     * string myurl The url to parse.
     */
    protected Json[string] _parseExtension(string myurl) {
        if (count(_extensions) && myurl.contains(".")) {
            foreach (_extensions as myext) {
                mylen = myext.length + 1;
                if (subString(myurl, -mylen) == "." ~ myext) {
                    return [subString(myurl, 0, mylen * -1), myext];
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
     * @param Json[string] mycontext The current route context, which should contain controller/action keys.
     */
    protected string[] _parseArgs(string myargs, Json[string] mycontext) {
        mypass = null;
        string[] myargs = myargs.split("/");
        myurldecode = _options.get("_urldecode", true);

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
     * Json[string] myurl The array to apply persistent parameters to.
     * @param Json[string] myparams An array of persistent values to replace persistent ones.
     */
    protected Json[string] _persistParams(Json[string] myurl, Json[string] myparams) {
        foreach (persistKey, configuration.getStringArray("persist")) {
            if (array_key_exists(mypersistKey, myparams) && myurl.isNull(mypersistKey)) {
                myurl.set(mypersistKey, myparams[mypersistKey]);
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
     * Json[string] myurl An array of parameters to check matching with.
     * @param Json[string] mycontext An array of the current request context.
     * Contains information such as the current host, scheme, port, base
     * directory and other url params.
     */
    string match(Json[string] myurl, Json[string] mycontext= null) {
        if (_compiledRoute.isEmpty) {
            this.compile();
        }
        _defaultValues = this.defaults;
        mycontext += ["params": Json.emptyArray, "_port": Json(null), "_scheme": Json(null), "_host": Json(null)];

        if (
            !configuration..isEmpty("persist")) &&
            isArray(configuration.set("persist"])
       ) {
            myurl = _persistParams(myurl, mycontext["params"]);
        }
        remove(mycontext["params"]);
        myhostOptions = array_intersectinternalKey(myurl, mycontext);

        // Apply the _host option if possible
        if (configuration.hasKey("_host")) {
            if (!myhostOptions.hasKey("_host") && !configuration.getString("_host").contains("*")) {
                myhostOptions.set("_host", configuration.get("_host"));
            }
            myhostOptions["_host"] ? myhostOptions["_host"] : mycontext["_host"];

            // The host did not match the route preferences
            if (!hostMatches(/* (string) */myhostOptions["_host"])) {
                return null;
            }
        }
        // Check for properties that will cause an
        // absolute url. Copy the other properties over.
        if (
            myhostOptions.hasAnyKeys("_scheme", "_port", "_host")
       ) {
            myhostOptions += mycontext;

            if (
                myhostOptions["_scheme"] &&
                getservbyname(myhostOptions["_scheme"], "tcp") == myhostOptions["_port"]
           ) {
                remove(myhostOptions["_port"]);
            }
        }
        // If no base is set, copy one in.
        if (!myhostOptions.hasKey("_base") && mycontext.hasKey("_base")) {
            myhostOptions["_base"] = mycontext["_base"];
        }
        myquery = !myurl.isEmpty("?") ? /* (array) */myurl["?"] : [];
        remove(myurl["_host"], myurl["_scheme"], myurl["_port"], myurl["_base"], myurl["?"]);

        // Move extension into the hostOptions so its not part of
        // reverse matches.
        if (myurl.hasKey("_ext")) {
            myhostOptions.set("_ext", myurl["_ext"]);
            myurl.remove("_ext");
        }
        // Check the method first as it is special.
        if (!_matchMethod(myurl)) {
            return null;
        }
        remove(myurl["_method"], myurl["[method]"], _defaultValues["_method"]);

        // Defaults with different values are a fail.
        if (array_intersectinternalKey(myurl, _defaultValues) != _defaultValues) {
            return null;
        }
        // If this route uses pass option, and the passed elements are
        // not set, rekey elements.
        if (configuration.hasKey("pass")) {
            foreach (myi, routings; configuration.set("pass")) {
                if (myurl.hasKey([myi) && !myurl.haskey(routings)) {
                    myurl[routings] = myurl[myi];
                    remove(myurl[myi]);
                }
            }
        }
        // check that all the key names are in the url
        mykeyNames = array_flip(this.keys);
        if (array_intersectinternalKey(mykeyNames, myurl) != mykeyNames) {
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
                remove(myurl[aKey]);
            }
        }
        // if not a greedy route, no extra params are allowed.
        if (!_greedy && !mypass.isEmpty) {
            return null;
        }
        // check patterns for routed params
        if (!_options.isEmpty) {
            foreach (_options as aKey: mypattern) {
                if (isSet(myurl[aKey]) && !preg_match("#^" ~ mypattern ~ "my#u", /* (string) */myurl[aKey])) {
                    return null;
                }
            }
        }
        myurl += myhostOptions;

        // Ensure controller/action keys are not null.
        if (
            (isSet(mykeyNames["controller"]) && myurl.isNull("controller")) ||
            (isSet(mykeyNames["action"]) && myurl.isNull("action"))
       ) {
            return null;
        }
        return _writeUrl(myurl, mypass, myquery);
    }
    
    /**
     * Check whether the URL"s HTTP method matches.
     * Params:
     * Json[string] myurl The array for the URL being generated.
     */
    protected bool _matchMethod(Json[string] myurl) {
        if (this.defaults["_method"].isEmpty) {
            return true;
        }
        if (myurl["_method"].isEmpty) {
            myurl["_method"] = "GET";
        }
        _defaultValues = /* (array) */this.defaults["_method"];
        mymethods = /* (array) */this.normalizeAndValidateMethods(myurl["_method"]);
        foreach (myvalue; mymethods) {
            if (isIn(myvalue, _defaultValues, true)) {
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
     * Json[string] myparams The params to convert to a string url
     * @param Json[string] mypass The additional passed arguments
     * @param Json[string] myquery An array of parameters
     */
    protected string _writeUrl(Json[string] myparams, Json[string] mypass = [], Json[string] myquery= null) {
        mypass = array_map(function (myvalue) {
            return rawUrlEncode(/* (string) */myvalue);
        }, mypass);
        string mypass = mypass.join("/");
        string result = this.template;

        auto mysearch = null;
        auto myreplace = null;
        _keys.each!((key) {
            if (!array_key_exists(key, myparams)) {
                throw new DInvalidArgumentException(
                    "Missing required route key `%s`.".format(key));
            }
            mystring = myparams[key];
            mysearch ~= key;
            myreplace ~= mystring;
        });
        if (this.template.contains("**")) {
            array_push(mysearch, "**", "%2F");
            array_push(myreplace, mypass, "/");
        } else if (this.template.contains("*")) {
            mysearch ~= "*";
            myreplace ~= mypass;
        }
        string result = result.replace(mysearch, myreplace);

        // add base url if applicable.
        if (myparams.hasKey("_base")) {
            result = myparams.getString("_base") ~ result;
            myparams.remove("_base");
        }
        result = result.replace("//", "/");
        if (myparams.hasAnyKeys("_scheme", "_host", "_port")) {
            string myhost = myparams.getString("_host");

            // append the port & scheme if they exists.
            if (myparams.hasKey("_port")) {
                myhost ~= ": " ~ myparams.getString("_port");
            }
            myscheme = myparams.getString("_scheme", "http");
            result = "{myscheme}://{myhost}{result}";
        }
        if (!myparams.isEmpty("_ext")) || !myquery.isEmpty) {
            result = stripRight(result, "/");
        }
        if (!myparams.isEmpty("_ext"))) {
            result ~= "." ~ myparams.getString("_ext");
        }
        if (!myquery.isEmpty) {
            result ~= stripRight("?" ~ http_build_query(myquery), "?");
        }
        return result;
    }
    
    /**
     * Get the static path portion for this route.
     */
    string staticPath() {
        mymatched = preg_match(
            PLACEHOLDER_REGEX,
            this.template,
            routingsdElements,
            PREG_OFFSET_CAPTURE
       );

        if (mymatched) {
            return subString(this.template, 0, routingsdElements[0][1]);
        }
        
        size_t mystar = this.template.indexOf("*");
        if (mystar == true) {
            string mypath = stripRight(subString(this.template, 0, mystar), "/");

            return mypath.isEmpty ? "/" : mypath;
        }
        return _template;
    }
    
    /**
     * Set the names of the middleware that should be applied to this route.
     * Params:
     * Json[string] mymiddleware The list of middleware names to apply to this route.
     * Middleware names will not be checked until the route is matched.
     */
    void setMiddleware(Json[string] mymiddleware) {
        this.middleware = mymiddleware;
    }
    
    /**
     * Get the names of the middleware that should be applied to this route.
     *
     */
    Json[string] getMiddleware() {
        return _middleware;
    }
    
    /**
     * Set state magic method to support var_export
     *
     * This method helps for applications that want to implement
     * router caching.
     * Params:
     * Json[string] fieldNames Key/Value of object attributes
     */
    static static __set_state(Json[string] fieldNames) {
        myclass = class;
        myobj = new myclass("");
        foreach (fieldNames as fieldName: myvalue) {
            myobj.fieldName = myvalue;
        }
        return myobj;
    }
}
