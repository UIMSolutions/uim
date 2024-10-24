/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
  Json[string] _someKeys = null;

  // List of middleware that should be applied.
  protected Json[string] _middleware = null;

  // Valid HTTP methods.
  const string[] VALID_METHODS = [
    "GET", "PUT", "POST", "PATCH", "DELETE", "OPTIONS", "HEAD"
  ];

  // Regex for matching braced placholders in route template.
  protected const string PLACEHOLDER_REGEX; // = "#\{([a-z][a-z0-9-_]*)\}#i";

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
     */
  this(string mytemplate, Json[string] defaultValues = null, Json[string] options = null) {
    _templateText = mytemplate;
    _defaults = defaultValues;
    _options = options.mergeKeys(["_ext", "_middleware"], Json.emptyArray);
    /* setExtensions(configuration.getArray("_ext"));
        setMiddleware(configuration.getArray("_middleware")); */
    configuration.removeKey("_middleware");

    if (_defaults.hasKey("_method")) {
      _defaults.set("_method", this.normalizeAndValidateMethods(_defaults["_method"]));
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

  // Set the accepted HTTP methods for this route.
  void setMethods(string[] httpMethods) {
    _defaults.set("_method", this.normalizeAndValidateMethods(httpMethods));
  }

  // Normalize method names to upper case and validate that they are valid HTTP methods.
  protected string[] normalizeAndValidateMethods(string[] methods) {
    auto results = methods.upper;

    string[] mydiff = results.diff(VALID_METHODS);
    if (!mydiff.isEmpty) {
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
      configuration.set("multibytePattern", true);
    }
    _options = mypatterns + _options;
  }

  // Set host requirement
  void setHost(string hostName) {
    configuration.set("_host", hostName);
  }

  // Set the names of parameters that will be converted into passed parameters
  void setPass(string[] parameterNames) {
    configuration.set("pass", parameterNames);
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
     */
  void setPersist(Json[string] routings) {
    configuration.set("persist", routings);
  }

  // Check if a Route has been compiled into a regular expression.
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
    if (_template.isEmpty || (_template == "/")) {
      _compiledRoute = "#^/*my#";
      _keys = null;

      return;
    }

    auto myroute = _template;
    auto routings = myrouteParams = null;
    auto myparsed = preg_quote(_template, "#");

    preg_match_all(PLACEHOLDER_REGEX, myroute, routingsdElements, PREG_OFFSET_CAPTURE | PREG_SET_ORDER);

    /* foreach (mymatchArray; routingsdElements) {
            // Placeholder name, e.g. "foo"
            routings = mymatchArray[1][0];
            // Placeholder with colon/braces, e.g. "{foo}"
            mysearch = preg_quote(mymatchArray[0][0]);
            if (isSet(configuration.set(routings))) {
                string myoption = "";
                if (routings != "plugin" && hasKey(routings, _defaults)) {
                    myoption = "?";
                }
                // Dcs:disable Generic.Files.LineLength
                // Offset of the colon/braced placeholder in the full template string
                if (myparsed[mymatchArray[0][1] - 1] == "/") {
                    myrouteParams["/" ~ mysearch] = "(?:/(?P<" ~ routings ~ ">" ~ configuration.set(routings) ~ ")" ~ myoption ~ ")" ~ myoption;
                } else {
                    myrouteParams[mysearch] = "(?:(?P<" ~ routings ~ ">" ~ configuration.set(routings) ~ ")" ~ myoption ~ ")" ~ myoption;
                }
                // Dcs:enable Generic.Files.LineLength
            } else {
                myrouteParams[mysearch] = "(?:(?P<" ~ routings ~ ">[^/]+))";
            }
            routings ~= routings;
        } */
    /* if (preg_match("#\/\*\*my#", myroute)) {
            myparsed = to!string(preg_replace("#/\\\\\*\\\\\*my#", "(?:/(?P<_trailing_>.*))?", myparsed));
           _greedy = true;
        }
        if (preg_match("#\/\*my#", myroute)) {
            myparsed = /* (string) * /preg_replace("#/\\\\\*my#", "(?:/(?P<_args_>.*))?", myparsed);
           _greedy = true;
        } */

    /* auto mymode = configuration.isEmpty("multibytePattern") ? "" : "u";
        krsort(myrouteParams);
        myparsed = myparsed.replace(myrouteParams.keys, myrouteParams);
       _compiledRoute = "#^" ~ myparsed ~ "[/]*my#" ~ mymode;
        _keys = routings;

        // Remove defaults that are also keys. They can cause match failures
        _keys.each!(key => _defaults.removeKey(key));
        _keys = _keys.sort("b < a"); */
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
    foreach (key, myglue; someKeys) {
      string value;
      if (_template.contains("{" ~ key ~ "}")) {
        value = "_" ~ key;
      } else if (_defaults.hasKey(key)) {
        value = _defaults[key];
      }

      if (value.isNull) {
        continue;
      }
      if (value == true || value == false) {
        value = value ? "1" : "0";
      }
      routings ~= value ~ myglue;
    }
    _name = routings.lower;
    return _name;
  }

  /**
     * Checks to see if the given URL can be parsed by this route.
     *
     * If the route can be parsed an array of parameters will be returned; if not
     * `null` will be returned.
     */
  Json[string] parseRequest(IServerRequest serverRequest) {
    auto uri = serverRequest.getUri();
    return configuration.hasKey("_host") && !hostMatches(uri.getHost())
      ? null : _parse(uri.path(), serverRequest.getMethod());
  }

  /**
     * Checks to see if the given URL can be parsed by this route.
     *
     * If the route can be parsed an array of parameters will be returned; if not
     * `null` will be returned. String URLs are parsed if they match a routes regular expression.
     */
  Json[string] parse(string urlToParse, string httpMethod) {
    try {
      if (!httpMethod.isEmpty) {
        httpMethod = this.normalizeAndValidateMethods(httpMethod);
      }
    } catch (InvalidArgumentException exception) {
      throw new BadRequestException(exception.message());
    }
    auto mycompiledRoute = this.compile();
    [urlToParse, myext] = _parseExtension(urlToParse);

    auto urlDecode = _options.get("_urldecode", true);
    if (urlDecode) {
      urlToParse = urlDecode(urlToParse);
    }
    if (!preg_match(mycompiledRoute, urlToParse, myroute)) {
      return null;
    }
    if (
      defaults.hasKey("_method") &&
      !isIn(httpMethod, _defaults.getArray("_method"), true)
      ) {
      return null;
    }
    myroute.shift();
    mycount = _keys.length;
    for (index = 0; index <= mycount; index++) {
      myroute.removeKey(index);
    }
    myroute["pass"] = null;

    // Assign defaults, set passed args to pass
    foreach (key, myvalue; _defaults) {
      if (isSet(myroute[key])) {
        continue;
      }
      if (isInteger(key)) {
        // myroute["pass"].concat( myvalue;
        continue;
      }
      myroute[key] = myvalue;
    }
    if (myroute.hasKey("_args_")) {
      mypass = _parseArgs(myroute["_args_"], myroute);
      myroute.set("pass", array_merge(myroute["pass"], mypass));
      removeKey(myroute["_args_"]);
    }
    if (myroute.hasKey("_trailing_")) {
      myroute.set("pass", myroute["_trailing_"]);
      myroute.removeKey("_trailing_");
    }
    if (!myext.isEmpty) {
      myroute.set("_ext", myext);
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
                    myroute["pass"].unshift(myroute[configuration.set("pass"][myj]]);
                }
            } */
    }
    myroute.set("_route", this);
    myroute.set("_matchedRoute", _template);
    if (count(_middleware) > 0) {
      myroute.set("_middleware", _middleware);
    }
    return myroute;
  }

  // Check to see if the host matches the route requirements
  bool hostMatches(string hostName) {
    /* string mypattern = "@^" ~ preg_quote(configuration.getString("_host", "@").replace("\*", ".*")) ~ "my@";
        return preg_match(mypattern, hostName) != 0; */
    return false;
  }

  /**
     * Removes the extension from url if it contains a registered extension.
     * If no registered extension is found, no extension is returned and the URL is returned unmodified.
     */
  protected Json[string] _parseExtension(string urlToParse) {
    if (count(_extensions) && urlToParse.contains(".")) {
      foreach (extension; _extensions) {
        auto extensionLength = myext.extension + 1;
        if (subString(urlToParse, -extensionLength) == "." ~ myext) {
          return [subString(urlToParse, 0, extensionLength * -1), myext];
        }
      }
    }
    return [urlToParse, null];
  }

  /**
     * Parse passed parameters into a list of passed args.
     *
     * Return true if a given named myparam"s myval matches a given myrule depending on mycontext.
     * Currently implemented rule types are controller, action and match that can be combined with each other.
     */
  protected string[] _parseArgs(string argument, Json[string] routeContext) {
    string[] mypass = null;
    string[] arguments = argument.split("/");
    auto urlDecode = _options.get("_urldecode", true);

    foreach (arg; arguments) {
      if (arg.isEmpty && arg != "0") {
        continue;
      }
      mypass ~= urlDecode ? rawurldecode(arg) : arg;
    }
    return mypass;
  }

  /**
     * Apply persistent parameters to a URL array. Persistent parameters are a
     * special key used during route creation to force route parameters to
     * persist when omitted from a URL array.
     */
  protected Json[string] _persistParams(Json[string] url, Json[string] options) {
    foreach (persistKey; configuration.getStringArray("persist")) {
      if (hasKey(persistKey, options) && url.isNull(persistKey)) {
        url.set(persistKey, options.get(persistKey));
      }
    }
    return url;
  }

  /**
     * Check if a URL array matches this route instance.
     *
     * If the URL matches the route parameters and settings, then
     * return a generated string URL. If the URL doesn"t match the route parameters, false will be returned.
     * This method handles the reverse routing or conversion of URL arrays into string URLs.
     */
  string match(Json[string] url, Json[string] requestContext = null) {
    if (_compiledRoute.isEmpty) {
      this.compile();
    }
    _defaultValues = _defaults;
    requestContext += [
      "params": Json.emptyArray,
      "_port": Json(null),
      "_scheme": Json(null),
      "_host": Json(null)
    ];

    if (
      !configuration.isEmpty("persist") && configuration.isArray("persist")) {
      url = _persistParams(url, requestContext["params"]);
    }
    removeKey(requestContext["params"]);
    myhostOptions = intersectinternalKey(url, requestContext);

    // Apply the _host option if possible
    if (configuration.hasKey("_host")) {
      if (!myhostOptions.hasKey("_host") && !configuration.getString("_host").contains("*")) {
        myhostOptions.set("_host", configuration.get("_host"));
      }
      myhostoptions.get("_host") ? myhostoptions.get("_host") : requestContext["_host"];

      // The host did not match the route preferences
      if (!hostMatches( /* (string) */ myhostoptions.get("_host"))) {
        return null;
      }
    }
    // Check for properties that will cause an
    // absolute url. Copy the other properties over.
    if (
      myhostOptions.hasAnyKeys("_scheme", "_port", "_host")
      ) {
      myhostOptions += requestContext;

      if (
        myhostoptions.get("_scheme") &&
        getservbyname(myhostoptions.get("_scheme"), "tcp") == myhostoptions.get("_port")
        ) {
        removeKey(myhostoptions.get("_port"));
      }
    }
    // If no base is set, copy one in.
    if (!myhostOptions.hasKey("_base") && requestContext.hasKey("_base")) {
      myhostoptions.set("_base", requestContext["_base"]);
    }
    query = url.getArray("?", []);
    removeKey(url["_host"], url["_scheme"], url["_port"], url["_base"], url["?"]);

    // Move extension into the hostOptions so its not part of
    // reverse matches.
    if (url.hasKey("_ext")) {
      myhostOptions.set("_ext", url["_ext"]);
      url.removeKey("_ext");
    }
    // Check the method first as it is special.
    if (!_matchMethod(url)) {
      return null;
    }
    removeKey(url["_method"], url["[method]"], _defaultValues["_method"]);

    // Defaults with different values are a fail.
    if (intersectinternalKey(url, _defaultValues) != _defaultValues) {
      return null;
    }
    // If this route uses pass option, and the passed elements are
    // not set, rekey elements.
    if (configuration.hasKey("pass")) {
      foreach (index, routings; configuration.get("pass")) {
        if (url.hasKey(index) && !url.haskey(routings)) {
          url[routings] = url[index];
          removeKey(url[index]);
        }
      }
    }
    // check that all the key names are in the url
    auto keyName = array_flip(_keys);
    if (intersectinternalKey(keyName, url) != keyName) {
      return null;
    }

    auto mypass = null;
    foreach (key, myvalue; url) {
      // If the key is a routed key, it"s not different yet.
      if (hasKey(key, keyName)) {
        continue;
      }
      // pull out passed args
      mynumeric = isNumeric(key);
      if (mynumeric && isSet(_defaultValues[key]) && _defaultValues[key] == myvalue) {
        continue;
      }
      if (mynumeric) {
        mypass ~= myvalue;
        removeKey(url[key]);
      }
    }
    // if not a greedy route, no extra params are allowed.
    if (!_greedy && !mypass.isEmpty) {
      return null;
    }
    // check patterns for routed params
    if (!_options.isEmpty) {
      foreach (key, mypattern; _options) {
        if (isSet(url[key]) && !preg_match("#^" ~ mypattern ~ "my#u", /* (string) */ url[key])) {
          return null;
        }
      }
    }
    /* url += myhostOptions;

        // Ensure controller/action keys are not null.
        return (keyName.hasKey("controller") && url.isNull("controller")) ||
            (keyName.hasKey()"action") && url.isNull("action")
            ? null
            : _writeUrl(url, mypass, query); */
    return null;
  }

  // Check whether the URL"s HTTP method matches.
  protected bool _matchMethod(Json[string] url) {
    if (_defaults.isEmpty("_method")) {
      return true;
    }

    if (url.isEmpty("_method")) {
      url["_method"] = "GET";
    }
    _defaultValues = _defaults.getArray("_method");
    auto mymethods =  /* (array) */ this.normalizeAndValidateMethods(url["_method"]);

    return mymethods.any!(method => isIn(method, _defaultValues, true));
  }

  /**
     * Converts a matching route array into a URL string.
     * Composes the string URL using the template used to create the route.
     */
  protected string _writeUrl(Json[string] options, Json[string] mypass = null, Json[string] query = null) {
    mypass = mypass.map!(myvalue => rawUrlEncode( /* (string) */ myvalue)).array;
    string mypass = mypass.join("/");
    string result = _template;

    auto mysearch = null;
    auto myreplace = null;
    _keys.each!((key) {
      if (!hasKey(key, options)) {
        throw new DInvalidArgumentException(
          "Missing required route key `%s`.".format(key));
      }
      mystring = options.get(key);
      mysearch ~= key;
      myreplace ~= mystring;
    });
    if (_template.contains("**")) {
      mysearch.push("**", "%2F");
      myreplace.push(mypass, "/");
    } else if (_template.contains("*")) {
      mysearch ~= "*";
      myreplace ~= mypass;
    }
    string result = result.replace(mysearch, myreplace);

    // add base url if applicable.
    if (options.hasKey("_base")) {
      result = options.shift("_base").getString ~ result;
    }
    result = result.replace("//", "/");
    if (options.hasAnyKeys("_scheme", "_host", "_port")) {
      string myhost = options.getString("_host");

      // append the port & scheme if they exists.
      if (options.hasKey("_port")) {
        myhost ~= ": " ~ options.getString("_port");
      }
      myscheme = options.getString("_scheme", "http");
      result = "{myscheme}://{myhost}{result}";
    }
    if (options.hasKey("_ext") || !query.isEmpty) {
      result = stripRight(result, "/");
    }
    if (options.hasKey("_ext")) {
      result ~= "." ~ options.getString("_ext");
    }
    if (!query.isEmpty) {
      result ~= stripRight("?" ~ http_build_query(query), "?");
    }
    return result;
  }

  // Get the static path portion for this route.
  string staticPath() {
    auto mymatched = preg_match(
      PLACEHOLDER_REGEX,
      _template,
      routingsdElements,
      PREG_OFFSET_CAPTURE
    );

    if (mymatched) {
      return subString(_template, 0, routingsdElements[0][1]);
    }

    size_t mystar = _template.indexOf("*");
    if (mystar == true) {
      string mypath = stripRight(subString(_template, 0, mystar), "/");

      return mypath.isEmpty ? "/" : mypath;
    }
    return _template;
  }

  // Set the names of the middleware that should be applied to this route.
  void setMiddleware(Json[string] _middleware) {
    _middleware = _middleware;
  }

  // Get the names of the middleware that should be applied to this route.
  Json[string] getMiddleware() {
    return _middleware;
  }

  /**
     * Set state magic method to support var_export
     *
     * This method helps for applications that want to implement router caching.
     */
  /* static static __set_state(Json[string] fieldNames) {
        myclass = class;
        myobj = new myclass("");
        foreach (fieldNames as fieldName: myvalue) {
            myobj.fieldName = myvalue;
        }
        return myobj;
    } */
}
