/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.requests.serverrequest;

import uim.http;

@safe:

/**
 * A class that helps wrap Request information and particulars about a single request.
 * Provides methods commonly used to introspect on the request headers and request body.
 */
class DServerRequest : UIMObject { // }: IServerRequest {
    this() {
        initialize;
    }

    this(Json[string] initData) {
        this.initialize(initData);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    _urlParams = [
        "plugin": Json(null),
        "controller": Json(null),
        "action": Json(null),
        "_ext": Json(null),
        "pass": Json.emptyArray,
    ];

    _detectors = [
        "get": ["env": 'REQUEST_METHOD", "value": 'GET"],
        "post": ["env": 'REQUEST_METHOD", "value": 'POST"],
        "put": ["env": 'REQUEST_METHOD", "value": 'PUT"],
        "patch": ["env": 'REQUEST_METHOD", "value": 'PATCH"],
        "delete": ["env": 'REQUEST_METHOD", "value": 'DELETE"],
        "head": ["env": 'REQUEST_METHOD", "value": 'HEAD"],
        "options": ["env": 'REQUEST_METHOD", "value": 'OPTIONS"],
        "https": ["env": 'HTTPS", "options": [1, "on"]],
        "ajax": ["env": 'HTTP_X_REQUESTED_WITH", "value": 'XMLHttpRequest"],
        "Json": ["accept": ["application/Json"], "param": '_ext", "value": 'Json"],
        "xml": [
            "accept": ["application/xml", "text/xml"],
            "exclude": ["text/html"],
            "param": '_ext",
            "value": 'xml",
        ],
    ];

        return true;
    }

    // Array of cookie data.
    protected Json[string] cookies = null;

    // Array of environment data.
    protected Json[string] _environmentData = null;

    // Base URL path.
    protected string _baseUrlPath;

    // Array of query string arguments
    protected Json[string] _queryArguments = null;

    // Array of parameters parsed from the URL.
    protected Json[string] _urlParams;
    
    /**
     * Get all the server environment parameters.
     *
     * Read all of the 'environment' or `server' data that was
     * used to create this request.
     */
    Json[string] getServerParams() {
        return _environmentData;
    }
    
    /**
     * Get all the query parameters in accordance to the PSR-7 specifications. To read specific query values
     * use the alternative getQuery() method.
     */
    Json[string] queryArguments() {
        return _queryArguments;
    }

    // webroot path segment for the request.
    protected string _webroot = "/";

    /**
     * Whether to trust HTTP_X headers set by most load balancers.
     * Only set to true if your application runs behind load balancers/proxies
     * that you control.
     */
    bool _trustProxy = false;

    // Trusted proxies list
    protected string[] _trustedProxies = null;

    /**
     * The built in detectors used with `is()` can be modified with `addDetector()`.
     *
     * There are several ways to specify a detector, see \UIM\Http\ServerRequest.addDetector() for the
     * various formats and ways to define detectors.
     */
    protected static Json[string] _detectors;

    /**
     * Instance cache for results of is(something) calls
     *
     * @var array<string, bool>
     */
    protected Json[string] _detectorCache = null;
    /**
     * Array of POST data. Will contain form data as well as uploaded files.
     * In PUT/PATCH/DELETE requests this property will contain the form-urlencoded
     * data.
     *
     * @var object|array|null
     */
    protected object|array|null someData = null;



    /**
     * Request body stream. Contains D://input unless `input` constructor option is used.
     *
     * @var \Psr\Http\Message\IStream
     */
    protected IStream stream;

    /**
     * Uri instance
     *
     * @var \Psr\Http\Message\IUri
     */
    protected IUri anUri;

    /**
     * Instance of a Session object relative to this request
     *
     * @var \UIM\Http\Session
     */
    protected ISession session;

    /**
     * Instance of a FlashMessage object relative to this request
     *
     * @var \UIM\Http\FlashMessage
     */
    protected DFlashMessage flash;

    /**
     * Store the additional attributes attached to the request.
     */
    protected Json[string] attributes = null;

    /**
     * A list of properties that emulated by the PSR7 attribute methods.
     */
    protected string[] emulatedAttributes = ["session", "flash", "webroot", "base", "params", "here"];

    /**
     * Array of Psr\Http\Message\IUploadedFile objects.
     *
     * @var array
     */
    protected Json[string] uploadedFiles = null;

    /**
     * The HTTP protocol version used.
     */
    protected string aprotocol = null;

    /**
     * The request target if overridden
     */
    protected string arequestTarget = null;

    /**
     * Create a new request object.
     *
     * You can supply the data as either an array or as a string. If you use
     * a string you can only supply the URL for the request. Using an array will
     * let you provide the following keys:
     *
     * - `post` POST data or non query string data
     * - `query` Additional data from the query string.
     * - `files` Uploaded files in a normalized structure, with each leaf an instance of IUploadedFile.
     * - `cookies` Cookies for this request.
     * - `environment` _SERVER and _ENV data.
     * - `url` The URL without the base path for the request.
     * - `uri` The PSR7 IUri object. If null, one will be created from `url` or `environment`.
     * - `base` The base URL for the request.
     * - `webroot` The webroot directory for the request.
     * - `input` The data that would come from D://input this is useful for simulating
     * requests with put, patch or delete data.
     * - `session` An instance of a Session object
     */
    this(Json[string] configData = null) {
        configData
            .merge("params", _params)
            .merge(["query", "post", "files", "cookies", "environment"], Json.emptyArray)
            .merge(["url", "base", "webroot"], "")
            .merge(["uri", "input"], Json(null));

       _setConfig(configData);
    }
    
    // Process the config/settings data into properties.
    protected void _setConfig(Json[string] configData = null) {
        if (isEmpty(configData["session"])) {
            configData["session"] = new DSession([
                "cookiePath": configData["base"],
            ]);
        }
        if (isEmpty(configData["environment.REQUEST_METHOD"])) {
            configData["environment.REQUEST_METHOD"] = "GET";
        }
        this.cookies = configData["cookies"];

        if (isSet(configData["uri"])) {
            if (!cast(IUri)configData["uri"] ) {
                throw new DException("The `uri` key must be an instance of " ~ IUri.classname);
            }
            anUri = configData["uri"];
        } else {
            if (configData.getString("url") != "") {
                configData = this.processUrlOption(configData);
            }
            ["uri": anUri] = UriFactory.marshalUriAndBaseFromSapi(configData["environment"]);
        }
       _environmentData = configData["environment"];

        _uri = anUri;
        _base = configData["base"];
        _webroot = configData["webroot"];

        DStream stream;
        if (configData.hasKey("input")) {
            auto stream = new DStream("d://memory", "rw");
            stream.write(configData["input"]);
            stream.rewind();
        } else {
            stream = new DStream("d://input");
        }
        _stream = stream;

        auto post = configData["post"];
        if (!(isArray(post) || isObject(post) || post.isNull)) {
            throw new DInvalidArgumentException(
                "`post` key must be an array, object or null. " ~ 
                " Got `%s` instead."
                .format(get_debug_type(post)
           ));
        }
        _data = post;
        _uploadedFiles = configData["files"];
        _query = configData["query"];
        _params = configData["params"];
        _session = configData["session"];
        _flash = new DFlashMessage(this.session);
    }
    
    /**
     * Set environment vars based on `url` option to facilitate IUri instance generation.
     * `query` option is also updated based on URL`s querystring.
     */
    protected Json[string] processUrlOption(Json[string] configData = null) {
        if (configData["url"][0] != "/") {
            configData.set("url", "/" ~ configData.getString("url"));
        }
        if (configData.getString("url").contains("?")) {
            [configData.get("url"), configData.get("environment.QUERY_STRING")] = split("?", configData.get("url"));

            parse_str(configData["environment.QUERY_STRING"], aQueryArgs);
            configData["query"] += aQueryArgs;
        }
        configData.set("environment.REQUEST_URI", configData.get("url"));

        return configData;
    }
    
    // Get the content type used in this request.
    string contentType() {
        return _getEnvironmentData("CONTENT_TYPE") ? _getEnvironmentData("CONTENT_TYPE") : getEnvironmentData("HTTP_CONTENT_TYPE");
    }
    
    // Returns the instance of the Session object for this request
    DSession getSession() {
        return _session;
    }
    
    // Returns the instance of the FlashMessage object for this request
    DFlashMessage getFlash() {
        return _flash;
    }
    
    // Get the IP the client is using, or says they are using.
    string clientIp() {
        if (_trustProxy && getEnvironmentData("HTTP_X_FORWARDED_FOR")) {
            string[] addresses = /* (string) */getEnvironmentData("HTTP_X_FORWARDED_FOR").split(",").strip;
            bool isTrusted = (count(this.isTrustedProxies) > 0);
            auto n = count(addresses);

            if (isTrusted) {
                isTrusted = array_diff(addresses, this.trustedProxies);
                isTrusted = (count(isTrusted) == 1);
            }
            if (isTrusted) {
                return addresses[0];
            }
            return addresses[n - 1];
        }
        if (_trustProxy && getEnvironmentData("HTTP_X_REAL_IP")) {
             anIpaddr = getEnvironmentData("HTTP_X_REAL_IP");
        } else if (_trustProxy && getEnvironmentData("HTTP_CLIENT_IP")) {
             anIpaddr = getEnvironmentData("HTTP_CLIENT_IP");
        } else {
             anIpaddr = getEnvironmentData("REMOTE_ADDR");
        }
        return /* (string) */ anIpaddr.strip;
    }
    
    // register trusted proxies
    void setTrustedProxies(Json[string] proxies) {
        this.trustedProxies = proxies;
        _trustProxy = true;
        this.uri = this.uri.withScheme(this.scheme());
    }
    
    // Get trusted proxies
    string[] getTrustedProxies() {
        return _trustedProxies;
    }
    
    /**
     * Returns the referer that referred this request.
     * Params:
     * bool local Attempt to return a local address.
     * Local addresses do not contain hostnames.
     */
    string referer(bool local = true) {
        auto httpReferer = getEnvironmentData("HTTP_REFERER");

        auto base = configuration.get("App.fullBaseUrl") ~ this.webroot;
        if (isEmpty(httpReferer) || base.isEmpty) {
            return null;
        }
        if (local && httpReferer.startWith(base)) {
            httpReferer = subString(httpReferer, base.length);
            if (httpReferer.isEmpty || httpReferer.startWith("//")) {
                httpReferer = "/";
            }
            if (httpReferer[0] != "/") {
                httpReferer = "/" ~ httpReferer;
            }
            return httpReferer;
        }

        return local
            ? null
            : httpReferer;
    }
    
    // Missing method handler, handles wrapping older style isAjax() type methods
    bool __call(string methodName, Json[string] params) {
        /* if (name.startWith("is")) {
            auto type = subString(methodName, 2).lower;

            params.unshift(type);

            return _is(...params);
        } */
        throw new BadMethodCallException("Method `%s()` does not exist."
        .format(methodName));
    }
    
    /**
     * Check whether a Request is a certain type.
     *
     * Uses the built-in detection rules as well as additional rules
     * defined with {@link \UIM\Http\ServerRequest.addDetector()}. Any detector can be called
     * as `is(type)` or `isType()`.
     * Params:
     * string[]|string atype The type of request you want to check. If an array
     * this method will return true if the request matches any type.
     */
    /* bool is(string[] atype, Json[string] arguments) {
        if (isArray(type)) {
            foreach (type as _type) {
                if (is(_type)) {
                    return true;
                }
            }
            return false;
        }
        type = type.lower;
        if (!_detectors.hasKey(type)) {
            throw new DInvalidArgumentException("No detector set for type `%s`."
            .format(type));
        }
        if (someArguments) {
            return _is(type, someArguments);
        }
        _detectorCache.set(_detectorCache.get(type, _is(type, someArguments)));
        return _detectorCache[type];
    } */
    
    // Clears the instance detector cache, used by the is() function
    void clearDetectorCache() {
       _detectorCache = null;
    }
    
    // Worker for the is() function
    protected bool _is(string requestType, Json[string] someArguments) {
        auto detect = _detectors[requestType];
        /* if (cast(DClosure)detect) {
            someArguments.unshift(this);

            return detect(...someArguments);
        } */
        if (detect.hasKey("env") && _environmentDetector(detect)) {
            return true;
        }
        if (detect.hasKey("header") && _headerDetector(detect)) {
            return true;
        }
        if (detect.hasKey("accept") && _acceptHeaderDetector(detect)) {
            return true;
        }
        if (detect.hasKey("param") && _paramDetector(detect)) {
            return true;
        }
        return false;
    }
    
    /**
     * Detects if a specific accept header is present.
     * Params:
     * Json[string] detect Detector options array.
     */
    protected bool _acceptHeaderDetector(Json[string] detect) {
        auto content = new DContentTypeNegotiation();
        auto options = detect["accept"];

        // Some detectors overlap with the default browser Accept header
        // For these types we use an exclude list to refine our content type
        // detection.
        auto exclude = detect.get("exclude", null);
        if (exclude) {
            options = array_merge(options, exclude);
        }
        auto accepted = content.preferredType(this, options);
        if (accepted.isNull) {
            return false;
        }
        if (exclude && isIn(accepted, exclude, true)) {
            return false;
        }
        return true;
    }
    
    // Detects if a specific header is present.
    protected bool _headerDetector(Json[string] detectorOptions) {
        foreach (header, aValue; detectorOptions.getMap("header")) {
            auto header = getEnvironmentData("http_" ~  header);
            if (!header.isNull) {
                /* if (cast(DClosure)aValue) {
                    return aValue(header);
                } */
                return header == aValue;
            }
        }
        return false;
    }
    
    // Detects if a specific request parameter is present.
    protected bool _paramDetector(Json[string] detect) {
        string key = detect.getString("param");
        if (detect.hasKey("value")) {
            auto aValue = detect.get("value");

            return _params.hasKey(key) ? _params[key] == aValue : false;
        }
        /* if (detect.hasKey("options")) {
            return isSet(_params[key]) ? isIn(_params[key], detect["options"]): false;
        } */
        return false;
    }
    
    /**
     * Detects if a specific environment variable is present.
     * Params:
     * Json[string] detect Detector options array.
     */
    protected bool _environmentDetector(Json[string] detect) {
        if (detect.hasKey("env")) {
            if (detect.hasKey("value")) {
                return _getEnvironmentData(detect.get("env")) == detect.get("value");
            }
            if (detect.hasKey("pattern")) {
                return /* (bool) */preg_match(detect.get("pattern"), /* (string) */getEnvironmentData(detect.get("env")));
            }
            if (detect.hasKey("options")) {
                auto somePattern = "/" ~ detect.get("options").join("|") ~ "/i";
                return /* (bool) */preg_match(somePattern, /* (string) */getEnvironmentData(detect.get("env")));
            }
        }
        return false;
    }
    
    /**
     * Check that a request matches all the given types.
     *
     * Allows you to test multiple types and union the results.
     * See Request.is() for how to add additional types and the
     * built-in types.
     */
    bool isAll(Json[string] types) {
        foreach (type; types) {
            /* if (!is(type)) {
                return false;
            } */
        }
        return true;
    }
    
    /**
     * Add a new detector to the list of detectors that a request can use.
     * There are several different types of detectors that can be set.
     *
     * ### Callback comparison
     *
     * Callback detectors allow you to provide a closure to handle the check.
     * The closure will receive the request object as its only parameter.
     *
     * ```
     * addDetector("custom", auto (request) { //Return a boolean });
     * ```
     *
     * ### Environment value comparison
     *
     * An environment value comparison, compares a value fetched from `enviroment()` to a known value
     * the environment value is equality checked against the provided value.
     *
     * ```
     * addDetector("post", ["env": 'REQUEST_METHOD", "value": 'POST"]);
     * ```
     *
     * ### Request parameter comparison
     *
     * Allows for custom detectors on the request parameters.
     *
     * ```
     * addDetector("admin", ["param": 'prefix", "value": 'admin"]);
     * ```
     *
     * ### Accept comparison
     *
     * Allows for detector to compare against Accept header value.
     *
     * ```
     * addDetector("csv", ["accept": 'text/csv"]);
     * ```
     *
     * ### Header comparison
     *
     * Allows for one or more headers to be compared.
     *
     * ```
     * addDetector("fancy", ["header": ["X-Fancy": 1]);
     * ```
     *
     * The `param`, `env` and comparison types allow the following
     * value comparison options:
     *
     * ### Pattern value comparison
     *
     * Pattern value comparison allows you to compare a value fetched from `enviroment()` to a regular expression.
     *
     * ```
     * addDetector("iphone", ["env": 'HTTP_USER_AGENT", "pattern": '/iPhone/i"]);
     * ```
     *
     * ### Option based comparison
     *
     * Option based comparisons use a list of options to create a regular expression. Subsequent calls
     * to add an already defined options detector will merge the options.
     *
     * ```
     * addDetector("mobile", ["env": 'HTTP_USER_AGENT", "options": ["Fennec"]]);
     * ```
     *
     * You can also make compare against multiple values
     * using the `options` key. This is useful when you want to check
     * if a request value is in a list of options.
     *
     * `addDetector("extension", ["param": '_ext", "options": ["pdf", "csv"]]`
     */
    static void addDetector(string detectorName, DClosure/* array */ detector) {
            _detectors[detectorName.lower] = detector;
    }

    static void addDetector(string name, Json[string] detector) {
        auto loweredName = name.lower;
        if (isSet(_detectors[loweredName], detector["options"])) {
            /** @var array data */
            detector.merge(_detectors.getMap(loweredName));
        }
        _detectors.get(loweredName, detector);
    }
    
    // Normalize a header name into the SERVER version.
    protected string normalizeHeaderName(string headerName) {
        string result = headerName.upper.replace("-", "_");
        return isIn(name, ["CONTENT_LENGTH", "CONTENT_TYPE"], true)
            ? result
            : "HTTP_" ~ result;
    }
    
    /**
     * Get all headers in the request.
     *
     * Returns an associative array where the header names are
     * the keys and the values are a list of header values.
     *
     * While header names are not case-sensitive, getHeaders() will normalize
     * the headers.
     */
    STRINGAA getHeaders() {
        STRINGAA result = null;
        _environmentData.byKeyValue
            .each!((kv) => {
            string name = null;
            if (key.startWith("HTTP_")) {
                name = subString(kv.key, 5);
            }
            if (kv.key.startWith("CONTENT_")) {
                name = kv.key;
            }
            if (!name.isNull) {
                name = name.lower.replace("_", " ");
                name = ucwords(name).replace(" ", "-");
                result[name] = /* (array) */kv.value;
            }
        });
        return result;
    }
    
    /**
     * Check if a header is set in the request.
     * Params:
     * string aName The header you want to get (case-insensitive)
     */
    bool hasHeader(string headerName) {
        auto normalizedName = this.normalizeHeaderName(headerName);
        return _environmentData.hasKey(normalizedName);
    }
    
    /**
     * Get a single header from the request.
     *
     * Return the header value as an array. If the header
     * is not present an empty array will be returned.
     */
    string[] getHeader(string headerName) {
        name = this.normalizeHeaderName(headerName);
        return _environmentData.hasKey(headerName)
            ? /* (array) */_environmentData[headerName]
            : null;
    }
    
    // Get a single header as a string from the request.
    string getHeaderLine(string headerName) {
        auto aValue = getHeader(headerName);

        return aValue.join(", ");
    }
    
    // Get a modified request with the provided header.
    static withHeader(string headerName, string[] headerValue) {
        auto result = this.clone;
        auto normalizedName = normalizeHeaderName(headerName);
        result._environmentData[normalizedName] = headerValue;
        return result;
    }
    
    /**
     * Get a modified request with the provided header.
     *
     * Existing header values will be retained. The provided value
     * will be appended into the existing values.
     * Params:
     * string aName The header name.
     */
    static auto withAddedHeader(string headerName, headerValue) {
        auto newRequest = this.clone;
        string normalizedName = this.normalizeHeaderName(headerName);
        auto existing = null;
        if (newRequest._environmentData[normalizedName] !is null) {
            existing = /* (array) */newRequest._environmentData[normalizedName];
        }
        existing = array_merge(existing, /* (array) */headerValue);
        newRequest._environmentData[normalizedName] = existing;

        return newRequest;
    }
    
    /**
     * Get a modified request without a provided header.
     * Params:
     * string aName The header name to remove.
     */
    static auto withoutHeader(string aName) {
        new = this.clone;
        name = this.normalizeHeaderName(name);
        removeKey(new._environmentData[name]);

        return new;
    }
    
    /**
     * Get the HTTP method used for this request.
     * There are a few ways to specify a method.
     *
     * - If your client supports it you can use native HTTP methods.
     * - You can set the HTTP-X-Method-Override header.
     * - You can submit an input with the name `_method`
     *
     * Any of these 3 approaches can be used to set the HTTP method used
     * by UIM internally, and will effect the result of this method.
     */
    string getMethod() {
        return (string)getEnvironmentData("REQUEST_METHOD");
    }
    
    /**
     * Update the request method and get a new instance.
     */
    static withMethod(string httpMethod) {
        new = this.clone;

        if (!preg_match("/^[!#%&\'*+.^_`\|~0-9a-z-]+/i", method)) {
            throw new DInvalidArgumentException(
                "Unsupported HTTP method `%s` provided."
                .format(method)
           );
        }
        new._environmentData["REQUEST_METHOD"] = method;

        return new;
    }
    
    /**
     * Update the query string data and get a new instance.
     * Params:
     * Json[string] aQuery The query string data to use
     */
    static withQueryParams(string queryString) {
        auto newQuery = this.clone;
        newQuery.query = queryString;

        return newQuery;
    }
    
    /**
     * Get the host that the request was handled on.
     */
    string host() {
        if (_trustProxy && getEnvironmentData("HTTP_X_FORWARDED_HOST")) {
            return _getEnvironmentData("HTTP_X_FORWARDED_HOST");
        }
        return _getEnvironmentData("HTTP_HOST");
    }
    
    /**
     * Get the port the request was handled on.
     */
    string port() {
        if (_trustProxy && getEnvironmentData("HTTP_X_FORWARDED_PORT")) {
            return _getEnvironmentData("HTTP_X_FORWARDED_PORT");
        }
        return _getEnvironmentData("SERVER_PORT");
    }
    
    /**
     * Get the current url scheme used for the request.
     * e.g. 'http", or 'https'
     */
    string scheme() {
        return _trustProxy && getEnvironmentData("HTTP_X_FORWARDED_PROTO")
            ? getEnvironmentData("HTTP_X_FORWARDED_PROTO")
            : _getEnvironmentData("HTTPS") ? "https' : 'http";
    }
    
    /**
     * Get the domain name and include tldLength segments of the tld.
     * Params:
     * int tldLength Number of segments your tld contains. For example: `example.com` contains 1 tld.
     * While `example.co.uk` contains 2.
     */
    string domain(int tldLength = 1) {
        auto host = this.host();
        if (host.isEmpty) {
            return null;
        }
        
        string[] segments = host.split(".");
        auto domain = segments.slice(-1 * (tldLength + 1));

        return domain.join(".");
    }
    
    /**
     * Get the subdomains for a host.
     * Params:
     * int tldLength Number of segments your tld contains. For example: `example.com` contains 1 tld.
     * While `example.co.uk` contains 2.
     */
    string[] subdomains(int tldLength = 1) {
        auto host = host();
        if (host.isEmpty()) {
            return null;
        }
        
        string[] segments = host.split(".");
        return segments.slice(0, -1 * (tldLength + 1));
    }
    
    /**
     * Find out which content types the client accepts or check if they accept a
     * particular type of content.
     *
     * #### Get all types:
     *
     * ```
     * _request.accepts();
     * ```
     *
     * #### Check for a single type:
     *
     * ```
     * _request.accepts("application/Json");
     * ```
     *
     * This method will order the returned content types by the preference values indicated
     * by the client.
     * Params:
     * string type The content type to check for. Leave null to get all types a client accepts.
     */
    string[] accepts(string contentType = null) {
        auto content = new DContentTypeNegotiation();
        if (contentType) {
            return !content.preferredType(this, [contentType]).isNull;
        }
        
        auto accept = null;
        content.parseAccept(this).each!(types => accept = array_merge(accept, types))
        return accept;
    }
    
    /**
     * Get the languages accepted by the client, or check if a specific language is accepted.
     *
     * Get the list of accepted languages:
     *
     * ```request.acceptLanguage();```
     *
     * Check if a specific language is accepted:
     *
     * ```request.acceptLanguage("es-es");```
     */
    Json acceptLanguage(string languageToTest = null) {
        auto content = new DContentTypeNegotiation();
        return languageToTest.isEmpty
            ? content.acceptedLanguages(this)
            : content.acceptLanguage(this, language);
    }
    
    /**
     * Read a specific query value or dotted path.
     *
     * Developers are encouraged to use queryArguments() if they need the whole query array,
     * as it is PSR-7 compliant, and this method is not. Using Hash.get() you can also get single params.
     *
     * ### PSR-7 Alternative
     *
     * ```
     * aValue = Hash.get(request.queryArguments(), "Post.id");
     * ```
     */
    Json getQuery(string[] path, Json defaultValue = Json(null)) {
        return getQuery(path.join("."), defaultValue);
    }

    Json getQuery(string name = null, Json defaultValue = Json(null)) {
        return name.isNull
            ? _queryArguments
            : Hash.get(_query, name, default);
    }
    
    /**
     * Provides a safe accessor for request data. Allows
     * you to use Hash.get() compatible paths.
     *
     * ### Reading values.
     *
     * ```
     * get all data
     * request.getData();
     *
     * Read a specific field.
     * request.getData("Post.title");
     *
     * With a default value.
     * request.getData("Post.not there", "default value");
     * ```
     *
     * When reading values you will get `null` for keys/values that do not exist.
     *
     * Developers are encouraged to use getParsedBody() if they need the whole data array,
     * as it is PSR-7 compliant, and this method is not. Using Hash.get() you can also get single params.
     *
     * ### PSR-7 Alternative
     *
     * ```
     * aValue = Hash.get(request.getParsedBody(), "Post.id");
     * ```
     */
    Json getData(string valueName = null, Json defaultValue = Json(null)) {
        if (valueName.isNull) {
            return _data;
        }
        return !isArray(this.data)  
            ? Hash.get(this.data, valueName, defaultValue)
            : defaultValue;
    }
    
    // Read cookie data from the request`s cookie data.
    string[] getCookie(string[] path, string[] defaultValue = null) {
        return Hash.get(this.cookies, path, defaultValue);
    }

    string[] getCookie(string key, string[] defaultValue = null) {
        return Hash.get(this.cookies, key, defaultValue);
    }
    
    /**
     * Get a cookie collection based on the request`s cookies
     *
     * The CookieCollection lets you interact with request cookies using
     * `\UIM\Http\Cookie\Cookie` objects and can make converting request cookies
     * into response cookies easier.
     *
     * This method will create a new cookie collection each time it is called.
     * This is an optimization that allows fewer objects to be allocated until
     * the more complex CookieCollection is needed. In general you should prefer
     * `getCookie()` and `getCookieParams()` over this method. Using a CookieCollection
     * is ideal if your cookies contain complex Json encoded data.
     */
    DCookieCollection getCookieCollection() {
        return CookieCollection.createFromServerRequest(this);
    }
    
    /**
     * Replace the cookies in the request with those contained in
     * the provided CookieCollection.
     */
    static withCookieCollection(DCookieCollection cookies) {
        auto newServerRequest = this.clone;
        Json[string] someValues = null;
        foreach (cookie; cookies) {
            someValues.set(cookie.name, cookie.getValue());
        }
        newServerRequest.cookies = someValues;

        return newServerRequest;
    }
    
    // Get all the cookie data from the request.
    Json[string] getCookieParams() {
        return _cookies;
    }
    
    // Replace the cookies and get a new request instance.
    static auto withCookieParams(Json[string] cookies) {
        auto newServerRequest = this.clone;
        newServerRequest.cookies = cookies;

        return newServerRequest;
    }
    
    /**
     * Get the parsed request body data.
     *
     * If the request Content-Type is either application/x-www-form-urlencoded
     * or multipart/form-data, and the request method is POST, this will be the
     * post data. For other content types, it may be the deserialized request
     * body.
     */
    /* object|array|null */ auto getParsedBody() {
        return _data;
    }
    
    /**
     * Update the parsed body and get a new instance.
     * Params:
     * object|array|null someData The deserialized body data. This will
     *   typically be in an array or object.
     */
    static auto withParsedBody(someData) {
        auto newServerRequest = this.clone;
        newServerRequest.data = someData;

        return newServerRequest;
    }
    
    // Retrieves the HTTP protocol version as a string.
    string getProtocolVersion() {
        if (_protocol) {
            return _protocol;
        }
        // Lazily populate this data as it is generally not used.
        preg_match("/^HTTP\/([\d.]+)/", (string)getEnvironmentData("SERVER_PROTOCOL"), match);
        protocol = "1.1";
        if (match[1] !is null) {
            protocol = match[1];
        }
        _protocol = protocol;

        return _protocol;
    }
    
    /**
     * Return an instance with the specified HTTP protocol version.
     *
     * The version string MUST contain only the HTTP version number (e.g.,
     * "1.1", "1.0").
     * Params:
     * string aversion HTTP protocol version
     */
    static auto withProtocolVersion(string aversion) {
        if (!preg_match("/^(1\.[01]|2)/", version)) {
            throw new DInvalidArgumentException("Unsupported protocol version `%s` provided.".format(version));
        }
        auto newServerRequest = this.clone;
        newServerRequest.protocol = aversion;

        return newServerRequest;
    }
    
    /**
     * Get a value from the request`s environment data.
     * Fallback to using enviroment() if the key is not set in the environment property.
     */
    string getEnvironmentData(string key, string defaultValue = null) {
        auto key = key.upper;
        if (!hasKey(key, _environmentData)) {
           _environmentData[key] = enviroment(key);
        }
        return _environmentData[key] !is null ? (string)_environmentData[key] : default;
    }
    
    /**
     * Update the request with a new environment data element.
     *
     * Returns an updated request object. This method returns
     * a *new* request object and does not mutate the request in-place.
     */
    static auto withEnviroment(string key, string value) {
        IRequest newRequest = this.clone;
        newRequest._environmentData.set(key, aValue);
        newRequest.clearDetectorCache();

        return newRequest;
    }
    
    /**
     * Allow only certain HTTP request methods, if the request method does not match
     * a 405 error will be shown and the required "Allow" response header will be set.
     *
     * Example:
     *
     * _request.allowMethod("post");
     * or
     * _request.allowMethod(["post", "delete"]);
     *
     * If the request would be GET, response header "Allow: POST, DELETE" will be set
     * and a 405 error will be returned.
     * Params:
     * string[]|string httpMethods Allowed HTTP request methods.
     */
    bool allowMethod(string[] amethods) {
        auto someMethods = /* (array) */ someMethods;
        foreach (method; someMethods) {
            if (is(method)) {
                return true;
            }
        }
        auto allowed = strtoupper(join(", ",  someMethods));
         auto anException = new DMethodNotAllowedException();
         anException.setHeader("Allow", allowed);
        throw  anException;
    }
    
    /**
     * Update the request with a new request data element.
     *
     * Returns an updated request object. This method returns
     * a *new* request object and does not mutate the request in-place.
     *
     * Use `withParsedBody()` if you need to replace the all request data.
     */
    static auto withData(string pathToInsert, Json value) {
        auto copy = this.clone;

        if (copy.data.isArray) {
            copy.data = Hash.insert(copy.data, pathToInsert, value);
        }
        return copy;
    }
    
    /**
     * Update the request removing a data element.
     *
     * Returns an updated request object. This method returns
     * a *new* request object and does not mutate the request in-place.
     * Params:
     * string aName The dot separated path to remove.
     */
    static withoutData(string aName) {
        auto newServerRequest = this.clone;

        if (isArray(newServerRequest.data)) {
            newServerRequest.data = Hash.removeKey(newServerRequest.data, name);
        }
        return newServerRequest;
    }
    
    /**
     * Update the request with a new routing parameter
     *
     * Returns an updated request object. This method returns
     * a *new* request object and does not mutate the request in-place.
     */
    static auto withParam(string insertPath, Json valueToInsert) {
        auto newServerRequest = this.clone;
        newServerRequest.params = Hash.insert(copy.params, insertPath, valueToInsert);

        return newServerRequest;
    }
    
    // Safely access the values in _params.
    Json getParam(string path, Json defaultValue = Json(null)) {
        return Hash.get(_params, name, default);
    }
    
    // Return an instance with the specified request attribute.
    static DServerRequest withAttribute(string attributeName, Json aValue) {
        DServerRequest newServerRequest = this.clone;
        if (isIn(attributeName, _emulatedAttributes, true)) {
            newServerRequest.{attributeName} = aValue;
        } else {
            newServerRequest.attributes[attributeName] = aValue;
        }
        return newServerRequest;
    }
    
    /**
     * Return an instance without the specified request attribute.
     * Params:
     * string aName The attribute name.
     */
    static auto withoutAttribute(string aName) {
        auto newServerRequest = this.clone;
        if (isIn(name, _emulatedAttributes, true)) {
            throw new DInvalidArgumentException(
                "You cannot unset 'name'. It is a required UIM attribute."
           );
        }
        removeKey(newServerRequest.attributes[name]);

        return newServerRequest;
    }
    
    // Read an attribute from the request, or get the default
    Json getAttribute(string attributeName, Json defaultValue = Json(null)) {
        if (isIn(attributeName, _emulatedAttributes, true)) {
            if (namattributeNamee == "here") {
                return _base ~ this.uri.getPath();
            }
            return _{attributeName};
        }
        if (hasKey(attributeName, this.attributes)) {
            return _attributes[attributeName];
        }
        return default;
    }
    
    /**
     * Get all the attributes in the request.
     *
     * This will include the params, webroot, base, and here attributes that UIM provides.
     */
    Json[string] getAttributes() {
        auto emulated = [
            "params": _params,
            "webroot": this.webroot,
            "base": this.base,
            "here": this.base ~ this.uri.getPath(),
        ];

        return _attributes + emulated;
    }
    
    /**
     * Get the uploaded file from a dotted path.
     * Params:
     * string aPath The dot separated path to the file you want.
     */
    IUploadedFile getUploadedFile(string aPath) {
        auto file = Hash.get(this.uploadedFiles, somePath);
        if (!cast(UploadedFile)file) {
            return null;
        }
        return file;
    }
    
    /**
     * Get the array of uploaded files from the request.
     */
    Json[string] getUploadedFiles() {
        return _uploadedFiles;
    }
    
    /**
     * Update the request replacing the files, and creating a new instance.
     * Params:
     * Json[string] uploadedFiles An array of uploaded file objects.
     */
    static withUploadedFiles(Json[string] uploadedFiles) {
        this.validateUploadedFiles(uploadedFiles, "");
        auto newServerRequest = this.clone;
        newServerRequest.uploadedFiles = uploadedFiles;

        return newServerRequest;
    }
    
    /**
     * Recursively validate uploaded file data.
     * Params:
     * Json[string] uploadedFiles The new files array to validate.
     */
    protected auto validateUploadedFiles(Json[string] uploadedFiles, string path) {
        foreach (key, file; uploadedFiles) {
            if (isArray(file)) {
                this.validateUploadedFiles(file, key ~ ".");
                continue;
            }
            if (!cast(IUploadedFile)file) {
                throw new DInvalidArgumentException("Invalid file at `%s%s`.".format(path, key));
            }
        }
    }
    
    // Gets the body of the message.
    IStream getBody() {
        return _stream;
    }
    
    /**
     * Return an instance with the specified message body.
     * Params:
     * \Psr\Http\Message\IStream body The new request body
     */
    static auto withBody(IStream body) {
        auto newServerRequest = this.clone;
        newServerRequest.stream = body;

        return newServerRequest;
    }
    
    // Retrieves the URI instance.
    IUri getUri() {
        return _uri;
    }
    
    /**
     * Return an instance with the specified uri
     *
     * *Warning* Replacing the Uri will not update the `base`, `webroot`,
     * and `url` attributes.
     * Params:
     * \Psr\Http\Message\IUri anUri The new request uri
     */
    static withUri(IUri anUri, bool preserveHost = false) {
        auto newServerRequest = this.clone;
        newServerRequest.uri = anUri;

        if (preserveHost && this.hasHeader("Host")) {
            return newServerRequest;
        }
        host = anUri.getHost();
        if (!host) {
            return newServerRequest;
        }
        port = anUri.getPort();
        if (port) {
            host ~= ": " ~ port;
        }
        newServerRequest._environmentData["HTTP_HOST"] = host;

        return nenewServerRequestw;
    }
    
    /**
     * Create a new instance with a specific request-target.
     *
     * You can use this method to overwrite the request target that is
     * inferred from the request`s Uri. This also lets you change the request
     * target`s form to an absolute-form, authority-form or asterisk-form
     */
    static IRequest withRequestTarget(string requestTarget) {
        IRequest newRequest = this.clone;
        newRequest.requestTarget = requestTarget;

        return newRequest;
    }
    
    /**
     * Retrieves the request`s target.
     *
     * Retrieves the message`s request-target either as it was requested,
     * or as set with `withRequestTarget()`. By default this will return the
     * application relative path without base directory, and the query string
     * defined in the SERVER environment.
     */
    string getRequestTarget() {
        if (_requestTarget !is null) {
            return _requestTarget;
        }

        string target = this.uri.getPath();
        if (this.uri.getQuery()) {
            target ~= "?" ~ this.uri.getQuery();
        }
        
        return target.isEmpty
            ? "/"
            : target;
    }
    
    // Get the path of current request.
    string getPath() {
        if (_requestTarget.isNull) {
            return _uri.getPath();
        }

        return _requestTarget.contains("?")
            ? _requestTarget.split("?")[0]
            : null;
    }
}
