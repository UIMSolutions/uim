module uim.http.classes.requests.serverrequest;

import uim.http;

@safe:

/**
 * A class that helps wrap Request information and particulars about a single request.
 * Provides methods commonly used to introspect on the request headers and request body.
 */
class DServerRequest { // }: IServerRequest {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        this.initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

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
     * Params:
     * Json[string] configData An array of request data to create a request with.
     */
    this(Json[string] configData = null) {
        configData += [
            'params": this.params,
            'query": Json.emptyArray,
            'post": Json.emptyArray,
            'files": Json.emptyArray,
            'cookies": Json.emptyArray,
            'environment": Json.emptyArray,
            'url": "",
            'uri": Json(null),
            'base": "",
            'webroot": "",
            'input": Json(null),
        ];

       _setConfig(configData);
    }
    
    /**
     * Process the config/settings data into properties.
     * Params:
     * Json[string] configData The config data to use.
     */
    protected void _setConfig(Json[string] configData = null) {
        if (isEmpty(configData["session"])) {
            configData["session"] = new DSession([
                'cookiePath": configData["base"],
            ]);
        }
        if (isEmpty(configData["environment"]["REQUEST_METHOD"])) {
            configData["environment"]["REQUEST_METHOD"] = "GET";
        }
        this.cookies = configData["cookies"];

        if (isSet(configData["uri"])) {
            if (!configData["uri"] instanceof IUri) {
                throw new UimException("The `uri` key must be an instance of " ~ IUri.classname);
            }
            anUri = configData["uri"];
        } else {
            if (configData["url"] != "") {
                configData = this.processUrlOption(configData);
            }
            ["uri": anUri] = UriFactory.marshalUriAndBaseFromSapi(configData["environment"]);
        }
       _environmentData = configData["environment"];

        this.uri = anUri;
        _base = configData["base"];
        this.webroot = configData["webroot"];

        if (isSet(configData["input"])) {
            stream = new DStream("D://memory", "rw");
            stream.write(configData["input"]);
            stream.rewind();
        } else {
            stream = new DStream("D://input");
        }
        this.stream = stream;

        post = configData["post"];
        if (!(isArray(post) || isObject(post) || post.isNull)) {
            throw new DInvalidArgumentException(
                "`post` key must be an array, object or null. " ~ 
                " Got `%s` instead."
                .format(get_debug_type(post)
            ));
        }
        this.data = post;
        this.uploadedFiles = configData["files"];
        this.query = configData["query"];
        this.params = configData["params"];
        this.session = configData["session"];
        this.flash = new DFlashMessage(this.session);
    }
    
    /**
     * Set environment vars based on `url` option to facilitate IUri instance generation.
     *
     * `query` option is also updated based on URL`s querystring.
     * Params:
     * Json[string] configData Config array.
     */
    protected Json[string] processUrlOption(Json[string] configData = null) {
        if (configData["url"][0] != "/") {
            configData["url"] = "/" ~ configData["url"];
        }
        if (configData["url"].has("?")) {
            [configData["url"], configData["environment"]["QUERY_STRING"]] = split("?", configData["url"]);

            parse_str(configData["environment"]["QUERY_STRING"], aQueryArgs);
            configData["query"] += aQueryArgs;
        }
        configData["environment"]["REQUEST_URI"] = configData["url"];

        return configData;
    }
    
    /**
     * Get the content type used in this request.
     */
    string contentType() {
        return _getEnvironmentData("CONTENT_TYPE") ?: getEnvironmentData("HTTP_CONTENT_TYPE");
    }
    
    /**
     * Returns the instance of the Session object for this request
     */
    Session getSession() {
        return _session;
    }
    
    /**
     * Returns the instance of the FlashMessage object for this request
     */
    FlashMessage getFlash() {
        return _flash;
    }
    
    /**
     * Get the IP the client is using, or says they are using.
     */
    string clientIp() {
        if (this.trustProxy && getEnvironmentData("HTTP_X_FORWARDED_FOR")) {
            addresses = array_map("trim", split(",", (string)getEnvironmentData("HTTP_X_FORWARDED_FOR")));
            trusted = (count(this.trustedProxies) > 0);
            n = count(addresses);

            if (trusted) {
                trusted = array_diff(addresses, this.trustedProxies);
                trusted = (count(trusted) == 1);
            }
            if (trusted) {
                return addresses[0];
            }
            return addresses[n - 1];
        }
        if (this.trustProxy && getEnvironmentData("HTTP_X_REAL_IP")) {
             anIpaddr = getEnvironmentData("HTTP_X_REAL_IP");
        } elseif (this.trustProxy && getEnvironmentData("HTTP_CLIENT_IP")) {
             anIpaddr = getEnvironmentData("HTTP_CLIENT_IP");
        } else {
             anIpaddr = getEnvironmentData("REMOTE_ADDR");
        }
        return strip((string) anIpaddr);
    }
    
    /**
     * register trusted proxies
     * Params:
     * string[] proxies ips list of trusted proxies
     */
    void setTrustedProxies(Json[string] proxies) {
        this.trustedProxies = proxies;
        this.trustProxy = true;
        this.uri = this.uri.withScheme(this.scheme());
    }
    
    /**
     * Get trusted proxies
     */
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
        ref = getEnvironmentData("HTTP_REFERER");

        base = configuration.get("App.fullBaseUrl") ~ this.webroot;
        if (isEmpty(ref) || base.isEmpty) {
            return null;
        }
        if (local && ref.startWith(base)) {
            ref = substr(ref, base.length);
            if (ref.isEmpty || ref.startWith("//")) {
                ref = "/";
            }
            if (ref[0] != "/") {
                ref = "/" ~ ref;
            }
            return ref;
        }
        if (local) {
            return null;
        }
        return ref;
    }
    
    /**
     * Missing method handler, handles wrapping older style isAjax() type methods
     * Params:
     * string aName The method called
     * @param Json[string] params Array of parameters for the method call
     */
    bool __call(string aName, Json[string] params) {
        if (name.startWith("is")) {
            type = substr(name, 2).lower;

            array_unshift(params, type);

            return _is(...params);
        }
        throw new BadMethodCallException("Method `%s()` does not exist."
        .format(name));
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
     * @param Json ...someArguments List of arguments
     */
    bool is(string[] atype, Json ...someArguments) {
        if (isArray(type)) {
            foreach (type as _type) {
                if (this.is(_type)) {
                    return true;
                }
            }
            return false;
        }
        type = type.lower;
        if (!_detectors.isSet(type)) {
            throw new DInvalidArgumentException("No detector set for type `%s`."
            .format(type));
        }
        if (someArguments) {
            return _is(type, someArguments);
        }
        return _detectorCache[type] = _detectorCache[type] ?? _is(type, someArguments);
    }
    
    // Clears the instance detector cache, used by the is() function
    void clearDetectorCache() {
       _detectorCache = null;
    }
    
    /**
     * Worker for the is() function
     * Params:
     * string atype The type of request you want to check.
     * @param Json[string] someArguments Array of custom detector arguments.
     */
    protected bool _is(string atype, Json[string] someArguments) {
        auto detect = _detectors[type];
        if (cast(DClosure)detect) {
            array_unshift(someArguments, this);

            return detect(...someArguments);
        }
        if (isSet(detect["env"]) && _environmentDetector(detect)) {
            return true;
        }
        if (isSet(detect["header"]) && _headerDetector(detect)) {
            return true;
        }
        if (isSet(detect["accept"]) && _acceptHeaderDetector(detect)) {
            return true;
        }
        if (isSet(detect["param"]) && _paramDetector(detect)) {
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
        content = new DContentTypeNegotiation();
        options = detect["accept"];

        // Some detectors overlap with the default browser Accept header
        // For these types we use an exclude list to refine our content type
        // detection.
        exclude = detect.get("exclude", null);
        if (exclude) {
            options = array_merge(options, exclude);
        }
        accepted = content.preferredType(this, options);
        if (accepted.isNull) {
            return false;
        }
        if (exclude && in_array(accepted, exclude, true)) {
            return false;
        }
        return true;
    }
    
    /**
     * Detects if a specific header is present.
     */
    protected bool _headerDetector(Json[string] detectorOptions) {
        foreach (detectorOptions["header"] as  aHeader: aValue) {
            auto aHeader = getEnvironmentData("http_" ~  aHeader);
            if (!aHeader.isNull) {
                if (cast(DClosure)aValue) {
                    return aValue(aHeader);
                }
                return aHeader == aValue;
            }
        }
        return false;
    }
    
    /**
     * Detects if a specific request parameter is present.
     * Params:
     * Json[string] detect Detector options array.
     */
    protected bool _paramDetector(Json[string] detect) {
        aKey = detect["param"];
        if (isSet(detect["value"])) {
            aValue = detect["value"];

            return isSet(this.params[aKey]) ? this.params[aKey] == aValue : false;
        }
        if (isSet(detect["options"])) {
            return isSet(this.params[aKey]) ? in_array(this.params[aKey], detect["options"]): false;
        }
        return false;
    }
    
    /**
     * Detects if a specific environment variable is present.
     * Params:
     * Json[string] detect Detector options array.
     */
    protected bool _environmentDetector(Json[string] detect) {
        if (isSet(detect["env"])) {
            if (isSet(detect["value"])) {
                return _getEnvironmentData(detect["env"]) == detect["value"];
            }
            if (isSet(detect["pattern"])) {
                return (bool)preg_match(detect["pattern"], (string)getEnvironmentData(detect["env"]));
            }
            if (isSet(detect["options"])) {
                 somePattern = "/" ~ join("|", detect["options"]) ~ "/i";

                return (bool)preg_match(somePattern, (string)getEnvironmentData(detect["env"]));
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
     * Params:
     * string[] types The types to check.
     */
    bool isAll(Json[string] types) {
        foreach (types as type) {
            if (!this.is(type)) {
                return false;
            }
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
     * Params:
     * string aName The name of the detector.
     * @param \Closure|array detector A Closure or options array for the detector definition.
     */
    static void addDetector(string aName, Closure|array detector) {
        name = name.lower;
        if (cast(DClosure)detector) {
            _detectors[name] = detector;

            return;
        }
        if (isSet(_detectors[name], detector["options"])) {
            /** @var array data */
            someData = _detectors[name];
            detector = Hash.merge(someData, detector);
        }
        _detectors[name] = detector;
    }
    
    // Normalize a header name into the SERVER version.
    protected string normalizeHeaderName(string headerName) {
        string result = headerName.upper.replace("-", "_");
        return in_array(name, ["CONTENT_LENGTH", "CONTENT_TYPE"], true)
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
            if (aKey.startWith("HTTP_")) {
                name = substr(kv.key, 5);
            }
            if (kv.key.startWith("CONTENT_")) {
                name = kv.key;
            }
            if (!name.isNull) {
                name = name.lower.replace("_", " ");
                name = ucwords(name).replace(" ", "-");
                result[name] = (array)kv.value;
            }
        }
        return result;
    }
    
    /**
     * Check if a header is set in the request.
     * Params:
     * string aName The header you want to get (case-insensitive)
     */
    bool hasHeader(string headerName) {
        auto normalizedName = this.normalizeHeaderName(headerName);
        return _environmentData.isSet(normalizedName);
    }
    
    /**
     * Get a single header from the request.
     *
     * Return the header value as an array. If the header
     * is not present an empty array will be returned.
     */
    string[] getHeader(string headerName) {
        name = this.normalizeHeaderName(headerName);
        return _environmentData.isSet(headerName)
            ? (array)_environmentData[headerName]
            : null;
    }
    
    // Get a single header as a string from the request.
    string getHeaderLine(string headerName) {
        auto aValue = getHeader(headerName);

        return aValue.join(", ");
    }
    
    // Get a modified request with the provided header.
    static withHeader(string headerName, string[] headerValue) {
        auto result = clone this;
        name = this.normalizeHeaderName(headerName);
        result._environmentData[headerName] = aValue;

        return result;
    }
    
    /**
     * Get a modified request with the provided header.
     *
     * Existing header values will be retained. The provided value
     * will be appended into the existing values.
     * Params:
     * string aName The header name.
     * @param string[] avalue The header value
     */
    static auto withAddedHeader(string aName, aValue) {
        new = clone this;
        name = this.normalizeHeaderName(name);
        existing = null;
        if (isSet(new._environmentData[name])) {
            existing = (array)new._environmentData[name];
        }
        existing = array_merge(existing, (array)aValue);
        new._environmentData[name] = existing;

        return new;
    }
    
    /**
     * Get a modified request without a provided header.
     * Params:
     * string aName The header name to remove.
     */
    static auto withoutHeader(string aName) {
        new = clone this;
        name = this.normalizeHeaderName(name);
        unset(new._environmentData[name]);

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
     * Params:
     * string httpMethod The HTTP method to use.
     */
    static withMethod(string httpMethod) {
        new = clone this;

        if (!preg_match("/^[!#%&\'*+.^_`\|~0-9a-z-]+/i", method)) {
            throw new DInvalidArgumentException(
                "Unsupported HTTP method `%s` provided."
                .format(method
            ));
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
        auto newQuery = clone this;
        newQuery.query = queryString;

        return newQuery;
    }
    
    /**
     * Get the host that the request was handled on.
     */
    string host() {
        if (this.trustProxy && getEnvironmentData("HTTP_X_FORWARDED_HOST")) {
            return _getEnvironmentData("HTTP_X_FORWARDED_HOST");
        }
        return _getEnvironmentData("HTTP_HOST");
    }
    
    /**
     * Get the port the request was handled on.
     */
    string port() {
        if (this.trustProxy && getEnvironmentData("HTTP_X_FORWARDED_PORT")) {
            return _getEnvironmentData("HTTP_X_FORWARDED_PORT");
        }
        return _getEnvironmentData("SERVER_PORT");
    }
    
    /**
     * Get the current url scheme used for the request.
     *
     * e.g. 'http", or 'https'
     */
    string scheme() {
        if (this.trustProxy && getEnvironmentData("HTTP_X_FORWARDED_PROTO")) {
            return (string)getEnvironmentData("HTTP_X_FORWARDED_PROTO");
        }
        return _getEnvironmentData("HTTPS") ? "https' : 'http";
    }
    
    /**
     * Get the domain name and include tldLength segments of the tld.
     * Params:
     * int tldLength Number of segments your tld contains. For example: `example.com` contains 1 tld.
     * While `example.co.uk` contains 2.
     */
    string domain(int tldLength = 1) {
        auto host = this.host();
        if (isEmpty(host)) {
            return "";
        }
        
        string[] segments = host.split(".");
        domain = array_slice(segments, -1 * (tldLength + 1));

        return join(".", domain);
    }
    
    /**
     * Get the subdomains for a host.
     * Params:
     * int tldLength Number of segments your tld contains. For example: `example.com` contains 1 tld.
     * While `example.co.uk` contains 2.
     */
    string[] subdomains(int tldLength = 1) {
        auto host = host();
        if (host.isEmpty() {
            return null;
        }
        
        string[] segments = host.split(".");
        return array_slice(segments, 0, -1 * (tldLength + 1));
    }
    
    /**
     * Find out which content types the client accepts or check if they accept a
     * particular type of content.
     *
     * #### Get all types:
     *
     * ```
     * this.request.accepts();
     * ```
     *
     * #### Check for a single type:
     *
     * ```
     * this.request.accepts("application/Json");
     * ```
     *
     * This method will order the returned content types by the preference values indicated
     * by the client.
     * Params:
     * string type The content type to check for. Leave null to get all types a client accepts.
     */
    string[] accepts(string atype = null) {
        auto content = new DContentTypeNegotiation();
        if (type) {
            return !content.preferredType(this, [type]).isNull;
        }
        
        auto accept = null;
        foreach (content.parseAccept(this) as types) {
            accept = array_merge(accept, types);
        }
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
     * Params:
     * string language The language to test.
     */
    Json acceptLanguage(string languageToTest = null) {
        content = new DContentTypeNegotiation();
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
     * Params:
     * string name The name or dotted path to the query param or null to read all.
     * @param Json defaultValue The default value if the named parameter is not set, and name is not null.
     */
    Json getQuery(string nameOrPath = null, Json defaultValue = Json(null)) {
        return nameOrPath.isNull
            ? _queryArguments
            : Hash.get(this.query, nameOrPath, default);
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
     * Params:
     * string name Dot separated name of the value to read. Or null to read all data.
     * @param Json defaultValue The default data.
     */
    Json getData(string aName = null, Json defaultValue = Json(null)) {
        if (name.isNull) {
            return _data;
        }
        return !isArray(this.data)  
            ? Hash.get(this.data, name, defaultValue)
            : defaultValue;
    }
    
    /**
     * Read cookie data from the request`s cookie data.
     * Params:
     * string aKey The key or dotted path you want to read.
     * @param string[] default The default value if the cookie is not set.
     */
    string[] getCookie(string keyOrPath, string[] defaultValue = null) {
        return Hash.get(this.cookies, keyOrPath, defaultValue);
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
     * Params:
     * \UIM\Http\Cookie\CookieCollection cookies The cookie collection
     */
    static withCookieCollection(CookieCollection cookies) {
        new = clone this;
         someValues = null;
        foreach (cookies as cookie) {
             someValues[cookie.name] = cookie.getValue();
        }
        new.cookies = someValues;

        return new;
    }
    
    // Get all the cookie data from the request.
    Json[string] getCookieParams() {
        return _cookies;
    }
    
    /**
     * Replace the cookies and get a new request instance.
     * Params:
     * Json[string] cookies The new cookie data to use.
     */
    static auto withCookieParams(Json[string] cookies): static
    {
        new = clone this;
        new.cookies = cookies;

        return new;
    }
    
    /**
     * Get the parsed request body data.
     *
     * If the request Content-Type is either application/x-www-form-urlencoded
     * or multipart/form-data, and the request method is POST, this will be the
     * post data. For other content types, it may be the deserialized request
     * body.
     */
    object|array|null getParsedBody() {
        return _data;
    }
    
    /**
     * Update the parsed body and get a new instance.
     * Params:
     * object|array|null someData The deserialized body data. This will
     *   typically be in an array or object.
     */
    static withParsedBody(someData) {
        new = clone this;
        new.data = someData;

        return new;
    }
    
    /**
     * Retrieves the HTTP protocol version as a string.
     */
    string getProtocolVersion() {
        if (this.protocol) {
            return _protocol;
        }
        // Lazily populate this data as it is generally not used.
        preg_match("/^HTTP\/([\d.]+)/", (string)getEnvironmentData("SERVER_PROTOCOL"), match);
        protocol = "1.1";
        if (isSet(match[1])) {
            protocol = match[1];
        }
        this.protocol = protocol;

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
    static withProtocolVersion(string aversion) {
        if (!preg_match("/^(1\.[01]|2)/", version)) {
            throw new DInvalidArgumentException("Unsupported protocol version `%s` provided.".format(version));
        }
        new = clone this;
        new.protocol = version;

        return new;
    }
    
    /**
     * Get a value from the request`s environment data.
     * Fallback to using enviroment() if the key is not set in the environment property.
     * Params:
     * string aKey The key you want to read from.
     * @param string default Default value when trying to retrieve an environment
     * variable`s value that does not exist.
     */
    string getEnvironmentData(string aKey, string adefault = null) {
        aKey = aKey.upper;
        if (!array_key_exists(aKey, _environmentData)) {
           _environmentData[aKey] = enviroment(aKey);
        }
        return _environmentData[aKey] !isNull ? (string)_environmentData[aKey] : default;
    }
    
    /**
     * Update the request with a new environment data element.
     *
     * Returns an updated request object. This method returns
     * a *new* request object and does not mutate the request in-place.
     * Params:
     * string aKey The key you want to write to.
     * @param string avalue Value to set
     */
    static auto withenviroment(string aKey, string avalue) {
        new = clone this;
        new._environmentData[aKey] = aValue;
        new.clearDetectorCache();

        return new;
    }
    
    /**
     * Allow only certain HTTP request methods, if the request method does not match
     * a 405 error will be shown and the required "Allow" response header will be set.
     *
     * Example:
     *
     * this.request.allowMethod("post");
     * or
     * this.request.allowMethod(["post", "delete"]);
     *
     * If the request would be GET, response header "Allow: POST, DELETE" will be set
     * and a 405 error will be returned.
     * Params:
     * string[]|string httpMethods Allowed HTTP request methods.
     */
    bool allowMethod(string[] amethods) {
         someMethods = (array) someMethods;
        foreach (someMethods as method) {
            if (this.is(method)) {
                return true;
            }
        }
        allowed = strtoupper(join(", ",  someMethods));
         anException = new DMethodNotAllowedException();
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
     * Params:
     * @param Json aValue The value to insert into the request data.
     */
    static auto withData(string pathToInsert, Json aValue): static
    {
        copy = clone this;

        if (isArray(copy.data)) {
            copy.data = Hash.insert(copy.data, pathToInsert, aValue);
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
        copy = clone this;

        if (isArray(copy.data)) {
            copy.data = Hash.remove(copy.data, name);
        }
        return copy;
    }
    
    /**
     * Update the request with a new routing parameter
     *
     * Returns an updated request object. This method returns
     * a *new* request object and does not mutate the request in-place.
     * Params:
     * @param Json aValue The value to insert into the the request parameters.
     */
    static auto withParam(string insertPath, Json aValue) {
        copy = clone this;
        copy.params = Hash.insert(copy.params, insertPath, aValue);

        return copy;
    }
    
    // Safely access the values in this.params.
    Json getParam(string path, Json defaultValue = Json(null)) {
        return Hash.get(this.params, name, default);
    }
    
    /**
     * Return an instance with the specified request attribute.
     * Params:
     * @param Json aValue The value of the attribute.
     */
    static withAttribute(string attributeName, Json aValue) {
        new = clone this;
        if (in_array(attributeName, this.emulatedAttributes, true)) {
            new.{attributeName} = aValue;
        } else {
            new.attributes[attributeName] = aValue;
        }
        return new;
    }
    
    /**
     * Return an instance without the specified request attribute.
     * Params:
     * string aName The attribute name.
     */
    static auto withoutAttribute(string aName) {
        new = clone this;
        if (in_array(name, this.emulatedAttributes, true)) {
            throw new DInvalidArgumentException(
                "You cannot unset 'name'. It is a required UIM attribute."
            );
        }
        unset(new.attributes[name]);

        return new;
    }
    
    /**
     * Read an attribute from the request, or get the default
     * Params:
     * string aName The attribute name.
     * @param Json defaultValue The default value if the attribute has not been set.
     */
    Json getAttribute(string aName, Json defaultValue = Json(null)) {
        if (in_array(name, this.emulatedAttributes, true)) {
            if (name == "here") {
                return _base ~ this.uri.getPath();
            }
            return _{name};
        }
        if (array_key_exists(name, this.attributes)) {
            return _attributes[name];
        }
        return default;
    }
    
    /**
     * Get all the attributes in the request.
     *
     * This will include the params, webroot, base, and here attributes that UIM provides.
     */
    Json[string] getAttributes() {
        emulated = [
            "params": this.params,
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
        file = Hash.get(this.uploadedFiles, somePath);
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
        new = clone this;
        new.uploadedFiles = uploadedFiles;

        return new;
    }
    
    /**
     * Recursively validate uploaded file data.
     * Params:
     * Json[string] uploadedFiles The new files array to validate.
     * @param string aPath The path thus far.
     */
    protected auto validateUploadedFiles(Json[string] uploadedFiles, string aPath) {
        foreach (uploadedFiles as aKey: file) {
            if (isArray(file)) {
                this.validateUploadedFiles(file, aKey ~ ".");
                continue;
            }
            if (!file instanceof IUploadedFile) {
                throw new DInvalidArgumentException("Invalid file at `%s%s`.".format(somePath, aKey));
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
        new = clone this;
        new.stream = body;

        return new;
    }
    
    /**
     * Retrieves the URI instance.
     */
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
        new = clone this;
        new.uri = anUri;

        if (preserveHost && this.hasHeader("Host")) {
            return new;
        }
        host = anUri.getHost();
        if (!host) {
            return new;
        }
        port = anUri.getPort();
        if (port) {
            host ~= ":" ~ port;
        }
        new._environmentData["HTTP_HOST"] = host;

        return new;
    }
    
    /**
     * Create a new instance with a specific request-target.
     *
     * You can use this method to overwrite the request target that is
     * inferred from the request`s Uri. This also lets you change the request
     * target`s form to an absolute-form, authority-form or asterisk-form
     *
     * @link https://tools.ietf.org/html/rfc7230#section-2.7 (for the various
     * request-target forms allowed in request messages)
     * @param string arequestTarget The request target.
     */
    static withRequestTarget(string arequestTarget) {
        new = clone this;
        new.requestTarget = requestTarget;

        return new;
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
        if (this.requestTarget !isNull) {
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
        if (this.requestTarget.isNull) {
            return _uri.getPath();
        }
        [somePath] = this.requestTarget.split("?");

        return somePath;
    }
}
