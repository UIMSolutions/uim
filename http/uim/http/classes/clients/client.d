module httuim.http.classes.clients.client;

import uim.http;

@safe:

/**
 * The end user interface for doing HTTP requests.
 *
 * ### Scoped clients
 *
 * If you're doing multiple requests to the same hostname it`s often convenient
 * to use the constructor arguments to create a scoped client. This allows you
 * to keep your code DRY and not repeat hostnames, authentication, and other options.
 *
 * ### Doing requests
 *
 * Once you've created an instance of Client you can do requests
 * using several methods. Each corresponds to a different HTTP method.
 *
 * - get()
 * - post()
 * - put()
 * - remove()
 * - patch()
 *
 * ### Cookie management
 *
 * Client will maintain cookies from the responses done with
 * a client instance. These cookies will be automatically added
 * to future requests to matching hosts. Cookies will respect the
 * `Expires`, `Path` and `Domain` attributes. You can get the client`s
 * CookieCollection using cookies()
 *
 * You can use the 'cookieJar' constructor option to provide a custom
 * cookie jar instance you've restored from cache/disk. By default,
 * an empty instance of {@link \UIM\Http\Client\CookieCollection} will be created.
 *
 * ### Sending request bodies
 *
 * By default, any POST/PUT/PATCH/DELETE request with  mydata will
 * send their data as `application/x-www-form-urlencoded` unless
 * there are attached files. In that case `multipart/form-data`
 * will be used.
 *
 * When sending request bodies you can use the `type` option to
 * set the Content-Type for the request:
 *
 * ```
 * myhttp.get("/users", [], ["type": 'Json"]);
 * ```
 *
 * The `type` option sets both the `Content-Type` and `Accept` header, to
 * the same mime type. When using `type` you can use either a full mime
 * type or an alias. If you need different types in the Accept and Content-Type
 * headers you should set them manually and not use `type`
 *
 * ### Using authentication
 *
 * By using the `auth` key you can use authentication. The type sub option
 * can be used to specify which authentication strategy you want to use.
 * UIM comes with a few built-in strategies:
 *
 * - Basic
 * - Digest
 * - Oauth
 *
 * ### Using proxies
 *
 * By using the `proxy` key you can set authentication credentials for
 * a proxy if you need to use one. The type sub option can be used to
 * specify which authentication strategy you want to use.
 * UIM comes with built-in support for basic authentication.
 */
class DClient { // }: IClient {
  mixin TConfigurable;

  this() {
    initialize;
  }

  this(Json[string] initData) {
    initialize(initData);
  }

  this(string name) {
    this().name(name);
  }

  // Hook method
  bool initialize(Json[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);

    configuration.updateDefaults([
      "auth": Json(null),
      "adapter": Json(null),
      "host": Json(null),
      "port": Json(null),
      "scheme": Json("http"),
      "basePath": "".toJson,
      "timeout": Json(30),
      "ssl_verify_peer": true.toJson,
      "ssl_verify_peer_name": true.toJson,
      "ssl_verify_depth": Json(5),
      "ssl_verify_host": true.toJson,
      "redirect": false.toJson,
      "protocolVersion": Json("1.1"),
    ]);

    return true;
  }

  mixin(TProperty!("string", "name")); /* 

  /**
     * List of cookies from responses made with this client.
     *
     * Cookies are indexed by the cookie`s domain or
     * request host name.
     */
  protected ICookieCollection _cookies;

  // Mock adapter for stubbing requests in tests.
  protected static DMockAdapter _mockAdapter = null;

  // Adapter for sending requests.
  protected IAdapter _adapter;

  /**
     * Create a new DHTTP Client.
     *
     * ### Config options
     *
     * You can set the following options when creating a client:
     *
     * - host - The hostname to do requests on.
     * - port - The port to use.
     * - scheme - The default scheme/protocol to use. Defaults to http.
     * - basePath - A path to append to the domain to use. (/api/v1/)
     * - timeout - The timeout in seconds. Defaults to 30
     * - ssl_verify_peer - Whether SSL certificates should be validated.
     * Defaults to true.
     * - ssl_verify_peer_name - Whether peer names should be validated.
     * Defaults to true.
     * - ssl_verify_depth - The maximum certificate chain depth to traverse.
     * Defaults to 5.
     * - ssl_verify_host - Verify that the certificate and hostname match.
     * Defaults to true.
     * - redirect - Number of redirects to follow. Defaults to false.
     * - adapter - The adapter class name or instance. Defaults to
     * \UIM\Http\Client\Adapter\Curl if `curl` extension is loaded else
     * \UIM\Http\Client\Adapter\Stream.
     * - protocolVersion - The HTTP protocol version to use. Defaults to 1.1
     * - auth - The authentication credentials to use. If a `username` and `password`
     * key are provided without a `type` key Basic authentication will be assumed.
     * You can use the `type` key to define the authentication adapter classname
     * to use. Short class names are resolved to the `Http\Client\Auth` namespace.
     * Params:
     * Json[string] configData Config options for scoped clients.
     */
  this(Json[string] configData = null) {
    configuration.update(configData);

    myadapter = configuration.get("adapter"];
    if (myadapter.isNull) {
      myadapter = Curl.classname;

      if (!extension_loaded("curl")) {
        myadapter = Stream.classname;
      }
    } else {
      configuration.set("adapter", null);
    }
    if (isString(myadapter)) {
      myadapter = new myadapter();
    }
    _adapter = myadapter;

    if (!configuration.isEmpty("cookieJar")) {
      _cookies = configuration.get("cookieJar"];
      configuration.set("cookieJar", null);
    } else {
      _cookies = new DCookieCollection();
    }
  }

  /**
     * Client instance returned is scoped to the domain, port, and scheme parsed from the passed URL string. The passed
     * string must have a scheme and a domain. Optionally, if a port is included in the string, the port will be scoped
     * too. If a path is included in the URL, the client instance will build urls with it prepended.
     * Other parts of the url string are ignored.
     * Params:
     * string myurl A string URL e.g. https://example.com
     */
  static auto createFromUrl(string myurl) {
    myparts = parse_url(myurl);

    if (myparts == false) {
      throw new DInvalidArgumentException(
        "string `%s` did not parse.".format(myurl
     ));
    }
    configData = array_intersectinternalKey(myparts, [
        "scheme": "",
        "port": "",
        "host": "",
        "path": ""
      ]);

    if (isEmpty(configuration.get("scheme"]) || configuration.get("host"].isEmpty) {
      throw new DInvalidArgumentException(
        "The URL was parsed but did not contain a scheme or host");
    }
    if (configuration.hasKey("path")) {
      configuration.get("basePath"] = configuration.get("path"];
      remove(configuration.get("path"));
    }
    return new static(configData);
  }

  // Get the cookies stored in the Client.
  CookieCollection cookies() {
    return _cookies;
  }

  /**
     * Adds a cookie to the Client collection.
     * Params:
     * \UIM\Http\Cookie\ICookie  mycookie Cookie object.
     */
  void addCookie(ICookie mycookie) {
    if (!mycookie.getDomain() || !mycookie.getPath()) {
      throw new DInvalidArgumentException("Cookie must have a domain and a path set.");
    }
    _cookies = _cookies.add(mycookie);
  }

  /**
     * Do a GET request.
     *
     * The  mydata argument supports a special `_content` key
     * for providing a request body in a GET request. This is
     * generally not used, but services like ElasticSearch use
     * this feature.
     */
  DResponse get(string urlToRequest, string[] queryData = null, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto mybody = null;
    if (isArray(queryData) && queryData.hasKey("_content")) {
      mybody = queryData["_content"];
      queryData.remove("_content");
    }

    auto url = buildUrl(urlToRequest, queryData, requestOptions);
    return _doRequest(
      Request.METHOD_GET,
      urlToRequest,
      mybody,
      requestOptions
   );
  }

  /**
     * Do a POST request.
     * Params:
     * string myurl The url or path you want to request.
     * @param Json postData The post data you want to send.
     * @param Json[string] requestOptions Additional requestOptions for the request.
     */
  Response post(string myurl, Json postData = null, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto myurl = buildUrl(myurl, [], requestOptions);

    return _doRequest(Request.METHOD_POST, myurl, postData, requestOptions);
  }

  /**
     * Do a PUT request.
     * Params: 
     * @param string myurl The url or path you want to request.
     * @param Json requestData The request data you want to send.
     * requestOptions = Additional requestOptions for the request.
     */
  Response put(string myurl, Json requestData = nullll, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto myurl = buildUrl(myurl, [], requestOptions);

    return _doRequest(Request.METHOD_PUT, myurl, requestData, requestOptions);
  }

  /**
     * Do a PATCH request.
     * Params:
     * string myurl The url or path you want to request.
     * @param Json requestData The request data you want to send.
     */
  Response patch(string requestUrl, Json valueToSend = null, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto url = buildUrl(requestUrl, [], requestOptions);
    return _doRequest(Request.METHOD_PATCH, url, valueToSend, requestOptions);
  }

  /**
     * Do an OPTIONS request.
     * Params:
     * @param Json sendData The request data you want to send.
     * requestOptions = Additional requestOptions for the request.
     */
  Response requestOptions(string urlToRequest, Json sendData = null, Json[string] requestOptions = null) {
    auto requestOptions = _mergeOptions(requestOptions);
    auto urlToRequest = buildUrl(urlToRequest, [], requestOptions);

    return _doRequest(Request.METHOD_OPTIONS, urlToRequest, sendData, requestOptions);
  }

  /**
     * Do a TRACE request.
     * Params:
     * string myurl The url or path you want to request.
     * @param Json sendData The request data you want to send.
     * @param Json[string] requestOptions Additional requestOptions for the request.
     */
  Response trace(string myurl, Json sendData = null, Json[string] requestOptions = null) {
    auto requestOptions = _mergeOptions(requestOptions);
    auto url = buildUrl(myurl, [], requestOptions);
   return _doRequest(Request.METHOD_TRACE, myurl, sendData, requestOptions);
  }

  /**
     * Do a DELETE request.
     * Params:
     * string myurl The url or path you want to request.
     * @param Json sendData The request data you want to send.
     * @param Json[string] requestOptions Additional requestOptions for the request.
     */
  Response remove(string myurl, Json sendData = null, Json[string] optionsForRequest = null) {
    auto optionsForRequest = _mergeOptions(optionsForRequest);
    auto myurl = buildUrl(myurl, [], optionsForRequest);

    return _doRequest(Request.METHOD_DELETE, myurl, sendData, optionsForRequest);
  }

  /**
     * Do a HEAD request.
     * Params:
     * string myurl The url or path you want to request.
     * @param Json[string] data The query string data you want to send.
     */
  DResponse head(string requestUrl, Json[string] queryData = null, Json[string] requestOptions = null) {
    auto optionsForRequest = _mergeOptions(requestOptions);
    auto requestUrl = buildUrl(requestUrl, queryData, optionsForRequest);

    return _doRequest(Request.METHOD_HEAD, requestUrl, "", optionsForRequest);
  }

  // Helper method for doing non-GET requests.
  protected DClientResponse _doRequest(string hhtpMethod, string requestUrl, Json requestBody, Json[string] options = null) {
    myrequest = _createRequest(
      hhtpMethod,
      requestUrl,
      requestBody,
      options
   );

    return _send(myrequest, options);
  }

  // Does a recursive merge of the parameter with the scope config.
  protected Json[string] _mergeOptions(Json[string] optionsToMerge = null) {
    return Hash.merge(_config, optionsToMerge);
  }

  // Sends a PSR-7 request and returns a PSR-7 response.
  IResponse sendRequest(IRequest psrRequest) {
    return _send(psrRequest, _config);
  }

  /**
     * Send a request.
     *
     * Used internally by other methods, but can also be used to send
     * handcrafted Request objects.
     * Params:
     * \Psr\Http\Message\IRequest  myrequest The request to send.
     * @param Json[string] options Additional options to use.
     */
  Response send(IRequest myrequest, Json[string] options = null) {
    int myredirects = 0;
    if (options.hasKey("redirect")) {
      myredirects = options.getLong("redirect");
      options.remove("redirect");
    }
    do {
      auto myresponse = _sendRequest(myrequest, options);
      auto myhandleRedirect = myresponse.isRedirect() && myredirects-- > 0;
      if (myhandleRedirect) {
        auto requestUrl = myrequest.getUri();

        mylocation = myresponse.getHeaderLine("Location");
        mylocationUrl = buildUrl(mylocation, [], [
            "host": requestUrl.getHost(),
            "port": requestUrl.getPort(),
            "scheme": requestUrl.getScheme(),
            "protocolRelative": true.toJson,
          ]);
        myrequest = myrequest.withUri(new Uri(mylocationUrl));
        myrequest = _cookies.addToRequest(myrequest, []);
      }
    }
    while (myhandleRedirect);

    return myresponse;
  }

  // Clear all mocked responses
  static void clearMockResponses() {
    _mockAdapter = null;
  }

  /**
     * Add a mocked response.
     *
     * Mocked responses are stored in an adapter that is called
     * _before_the network adapter is called.
     *
     * ### Matching Requests
     *
     * TODO finish this.
     *
     * ### Options
     *
     * - `match` An additional closure to match requests with.
     * Params:
     * string mymethod The HTTP method being mocked.
     * @param string myurl The URL being matched. See above for examples.
     */
  static void addMockResponse(string mymethod, string url, Response response, Json[string] options = null) {
    if (!_mockAdapter) {
      _mockAdapter = new DMockAdapter();
    }
    _mockAdapter.addResponse(new DRequest(url, mymethod), response, options);
  }

  /**
     * Send a request without redirection.
     * Params:
     * \Psr\Http\Message\IRequest  myrequest The request to send.
     */
  protected DClientResponse _sendRequest(IRequest requestToSend, Json[string] options = null) {
    if (_mockAdapter) {
      myresponses = _mockAdapter.send(requestToSend, options);
    }
    if (myresponses.isEmpty) {
      myresponses = _adapter.send(requestToSend, options);
    }
    myresponses.each!(response => _cookies = _cookies.addFromResponse(response, requestToSend));

    /** @var \UIM\Http\Client\Response */
    return array_pop(myresponses);
  }

  // Generate a URL based on the scoped client options.
  string buildUrl(string fullUrl, string[] queryData = null, Json[string] options = null) {
    if (options.isEmpty && queryData.isEmpty) {
      return fullUrl;
    }
    Json[string] mydefaults = [
      "host": Json(null),
      "port": Json(null,
      "scheme": Json("http"),
      "basePath": "".toJson,
      "protocolRelative": false.toJson,
    ];
    auto updatedOptions = options.update(mydefaults);

    if (queryData) {
      myq = fullUrl.contains("?") ? "&' : '?";
      fullUrl ~= myq;
      fullUrl ~= isString(queryData) ? queryData : http_build_query(queryData, "", "&", UIM_QUERY_RFC3986);
    }
    if (options["protocolRelative"] && fullUrl.startWith("//")) {
      fullUrl = options["scheme"] ~ ": " ~ fullUrl;
    }
    if (preg_match("#^https?://#", fullUrl)) {
      return fullUrl;
    }

    auto mydefaultPorts = [
      "http": 80,
      "https": 443,
    ];

    auto result = options.getString("scheme") ~ ": //" ~ options.getString("host");
    if (options["port"] &&  options.getLong("port") != mydefaultPorts[options.getString("scheme")]) {
      result ~= ": " ~ options["port"];
    }

    result ~= !options.isEmpty("basePath")
      ? "/" ~ options["basePath"].strip("/")
      : "/" ~ fullUrl.stripLeft("/");

    return result;
  }

  /**
     * Creates a new request object based on the parameters.
     * Params:
     * string mymethod HTTP method name.
     * @param string myurl The url including query string.
     * @param Json requestBody The request body.
     * @param Json[string] options The options to use. Contains auth, proxy, etc.
     */
  protected DRequest _createRequest(string mymethod, string myurl, Json requestBody, Json[string] options = null) {
    /** @var array<non-empty-string, non-empty-string>  myheaders */
    auto myheaders = options.get("headers");
    if (options.hasKey("type")) {
      myheaders = chain(myheaders, _typeHeaders(options["type"]));
    }
    if (isString(requestBody) && myheaders.isNull("Content-Type") && 
        myheaders.isNull("content-type")) {
      myheaders["Content-Type"] = "application/x-www-form-urlencoded";
    }
    auto myrequest = new DRequest(myurl, mymethod, myheaders, requestBody);
    myrequest = myrequest.withProtocolVersion(_configData.hasKey("protocolVersion"));
    mycookies = options["cookies"] ?  ? [];
    /** @var \UIM\Http\Client\Request  myrequest */
    myrequest = _cookies.addToRequest(myrequest, mycookies);
    if (options.hasKey("auth")) {
      myrequest = _addAuthentication(myrequest, options);
    }

    return options.hasKey("proxy")
      ? _addProxy(myrequest, options)
      : myrequest;
  }

  // Returns headers for Accept/Content-Type based on a short type or full mime-type.
  protected STRINGAA _typeHeaders(string mimetype) {
    if (mytype.contains("/")) {
      return [
        "Accept": mimetype,
        "Content-Type": mimetype,
      ];
    }

    auto mytypeMap = [
      "Json": "application/Json",
      "xml": "application/xml",
    ];
    if (mytypeMap.isNull(mimetype)) {
      throw new DException(
        "Unknown type alias `%s`."
          .format(mimetype));
    }
    return [
      "Accept": mytypeMap[mimetype],
      "Content-Type": mytypeMap[mimetype],
    ];
  }

  /**
     * Add authentication headers to the request.
     *
     * Uses the authentication type to choose the correct strategy
     * and use its methods to add headers.
     */
  protected DRequest _addAuthentication(Request myrequest, Json[string] optionsWithAuthKey = null) :  {
    myauth = optionsWithAuthKey["auth"];
    /** @var \UIM\Http\Client\Auth\Basic  myadapter */
    myadapter = _createAuth(myauth, options);

    return myadapter.authentication(myrequest, optionsWithAuthKey["auth"]);
  }

  /**
     * Add proxy authentication headers.
     *
     * Uses the authentication type to choose the correct strategy
     * and use its methods to add headers.
     * Params:
     * \UIM\Http\Client\Request  requestToModify The request to modify.
     * @param Json[string] options Array of options containing the 'proxy' key.
     */
  protected DRequest _addProxy(Request requestToModify, Json[string] options = null) {
    myauth = options["proxy"];
    Http\Client\Auth\Basic myadapter = _createAuth(myauth, options);

    return myadapter.proxyAuthentication(requestToModify, options["proxy"]);
  }

  /**
     * Create the authentication strategy.
     *
     * Use the configuration options to create the correct
     * authentication strategy handler.
     * Params:
     * Json[string] myauth The authentication options to use.
     */
  protected object _createAuth(Json[string] myauth, Json[string] requestOptions = null) :  {
    if (isEmpty(myauth["type"])) {
      myauth["type"] = "basic";
    }
    myname = ucfirst(myauth["type"]);
    myclass = App.classname(myname, "Http/Client/Auth");
    if (!myclass) {
      throw new DException(
        "Invalid authentication type `%s`.".format(myname)
     );
    }
    return new myclass(this, requestOptions);
  } */
}
