/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.clients.client;

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
 * - removeKey()
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

    configuration
      .setDefault("auth", Json(null))
      .setDefault("adapter", Json(null))
      .setDefault("host", Json(null))
      .setDefault("port", Json(null))
      .setDefault("scheme", Json("http"))
      .setDefault("basePath", "")
      .setDefault("timeout", Json(30))
      .setDefault("ssl_verify_peer", true)
      .setDefault("ssl_verify_peer_name", true)
      .setDefault("ssl_verify_depth", Json(5))
      .setDefault("ssl_verify_host", true)
      .setDefault("redirect", false)
      .setDefault("protocolVersion", Json("1.1"));

    return true;
  }

  mixin(TProperty!("string", "name"));

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
  this(Json[string] initData = null) {
    configuration.set(initData);

    auto myadapter = configuration.get("adapter");
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
      _cookies = configuration.get("cookieJar");
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
    configData = intersectinternalKey(myparts, [
        "scheme": "",
        "port": "",
        "host": "",
        "path": ""
      ]);
    if (configuration.isEmpty("scheme") || configuration.isEmpty("host")) {
      throw new DInvalidArgumentException(
        "The URL was parsed but did not contain a scheme or host");
    }
    if (configuration.hasKey("path")) {
      configuration.set("basePath", configuration.get("path"));
      removeKey(
        configuration.get("path"));
    }
    // return new static(configData);
    return null;
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
    if (!mycookie.domain() || !mycookie.path()) {
      throw new DInvalidArgumentException("Cookie must have a domain and a path set.");
    }
    _cookies = _cookies.add(mycookie);
  }

  /**
     * Do a GET request.
     *
     * The  mydata argument supports a special `_content` key for providing a request body in a GET request. 
     * This is generally not used, but services like ElasticSearch use this feature.
     */
  DResponse get(string requestUrl, string[] queryData = null, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto requestBody = null;
    if (queryData.isArray && queryData.hasKey("_content")) {
      requestBody = queryData["_content"];
      queryData.removeKey("_content");
    }

    auto url = buildUrl(requestUrl, queryData, requestOptions);
    return _doRequest(
      Request.METHOD_GET, url, requestBody, requestOptions
    );
  }

  // Do a POST request.
  IResponse post(string requestUrl, Json postData = null, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto url = buildUrl(
      requestUrl, [], options);
    return _doRequest(Request.METHOD_POST, url, postData, requestOptions);
  }

  // Do a PUT request.
  IResponse put(string requestUrl, Json requestData = null, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto url = buildUrl(
      requestUrl, [], options);
    return _doRequest(Request.METHOD_PUT, url, requestData, requestOptions);
  }

  // Do a PATCH request.
  IResponse patch(string requestUrl, Json valueToSend = null, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto url = buildUrl(
      requestUrl, [], requestOptions);
    return _doRequest(
      Request.METHOD_PATCH, url, valueToSend, requestOptions);
  }

  // Do an OPTIONS request.
  IResponse requestOptions(string requestUrl, Json sendData = null, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto url = buildUrl(
      urlTorequestUrlRequest, [], requestOptions);
    return _doRequest(
      Request.METHOD_OPTIONS, url, sendData, requestOptions);
  }

  // Do a TRACE request.
  IResponse trace(string requestUrl, Json sendData = null, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto url = buildUrl(
      requestUrl, [], requestOptions);
    return _doRequest(
      Request.METHOD_TRACE, url, sendData, requestOptions);
  }

  // Do a DELETE request.
  IResponse removeKey(string requestUrl, Json sendData = null, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto url = buildUrl(
      requestUrl, [], requestOptions);
    return _doRequest(
      Request.METHOD_DELETE, url, sendData, requestOptions);
  }

  // Do a HEAD request.
  DResponse head(string requestUrl, Json[string] queryData = null, Json[string] options = null) {
    auto requestOptions = _mergeOptions(options);
    auto requestUrl = buildUrl(
      requestUrl, queryData, requestOptions);
    return _doRequest(
      Request.METHOD_HEAD, requestUrl, "", requestOptions);
  }

  // Helper method for doing non-GET requests.
  protected DClientResponse _doRequest(string httpMethod, string requestUrl, Json requestBody, Json[string] options = null) {
    auto newRequest = _createRequest(
      hhtpMethod,
      requestUrl,
      requestBody,
      options
    );
    return _send(newRequest, options);
  }

  // Does a recursive merge of the parameter with the scope config.
  protected Json[string] _mergeOptions(Json[string] optionsToMerge = null) {
    return _config.dup.merge(optionsToMerge);
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
     */
  IResponse send(IRequest request, Json[string] options = null) {
    int myredirects = 0;
    if (options.hasKey("redirect")) {
      myredirects = options.shift("redirect").getLong;
    }
    do {
      auto myresponse = _sendRequest(request, options);
      auto myhandleRedirect = myresponse.isRedirect() && myredirects-- > 0;
      if (myhandleRedirect) {
        auto requestUrl = request.getUri();
        auto mylocation = myresponse.getHeaderLine(
          "Location");
        mylocationUrl = buildUrl(mylocation, [
          ], [
            "host": requestUrl.getHost(),
            "port": requestUrl.getPort(),
            "scheme": requestUrl.getScheme(),
            "protocolRelative": true,
          ]);
        request = request.withUri(new Uri(mylocationUrl));
        request = _cookies.addToRequest(request, [
          ]);
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
     */
  static void addMockResponse(string httpMethod, string url, IResponse response, Json[string] options = null) {
    if (!_mockAdapter) {
      _mockAdapter = new DMockAdapter();
    }
    _mockAdapter.addResponse(new DRequest(url, httpMethod), response, options);
  }

  // Send a request without redirection.
  protected DClientResponse _sendRequest(
    IRequest requestToSend, Json[string] options = null) {
    DClientResponse response;
    if (_mockAdapter) {
      response = _mockAdapter.send(requestToSend, options);
    }
    if (response.isEmpty) {
      response = _adapter.send(requestToSend, options);
    }
    response.each!(response => _cookies = _cookies.addFromResponse(response, requestToSend));
    return response.pop();
  }

  // Generate a URL based on the scoped client options.
  string buildUrl(string fullUrl, string[] queryData = null, Json[string] options = null) {
    if (options.isEmpty && queryData.isEmpty) {
      return fullUrl;
    }
    options
      .merge("host", Json(null))
      .merge("port", Json(null))
      .merge("scheme", "http")
      .merge("basePath", "")
      .merge("protocolRelative", false);

    if (queryData) {
      fullUrl ~= fullUrl.contains("?") ? "&" : "?";
      fullUrl ~= isString(queryData) ? queryData : http_build_query(
        queryData, "", "&", UIM_QUERY_RFC3986);
    }
    if (options.hasKey("protocolRelative") && fullUrl.startWith(
        "//")) {
      fullUrl = options.getString(
        "scheme") ~ ": " ~ fullUrl;
    }
    if (preg_match("#^https?://#", fullUrl)) {
      return fullUrl;
    }

    auto mydefaultPorts = [
      "http": 80,
      "https": 443,
    ];
    auto result = options.getString(
      "scheme") ~ ": //" ~ options.getString(
      "host");
    if (options.hasKey("port") && options.getLong(
        "port") != mydefaultPorts[options.getString(
          "scheme")]) {
      result ~= ": " ~ options.getString("port");
    }

    result ~= options.hasKey("basePath")
      ? "/" ~ options.getString("basePath")
      .strip("/") : "/" ~ fullUrl.stripLeft("/");

    return result;
  }

  // Creates a new request object based on the parameters.
  protected DRequest _createRequest(string httpMethod, string url, Json requestBody, Json[string] options = null) {
    auto headers = options.getArray("headers");
    if (options.hasKey("type")) {
      headers = chain(headers, _typeHeaders(
          options.get("type")));
    }
    if (requestBody.isString && headers.isNull("Content-Type") && headers
      .isNull("content-type")) {
      headers.set("Content-Type", "application/x-www-form-urlencoded");
    }
    auto newRequest = new DRequest(url, httpMethod, headers, requestBody);
    newRequest = newRequest.withProtocolVersion(_configData.hasKey("protocolVersion"));
    auto mycookies = options.getArray("cookies"); 
    newRequest = _cookies.addToRequest(newRequest, mycookies);
    if (
      options.hasKey("auth")) {
      newRequest = _addAuthentication(newRequest, options);
    }

    return options.hasKey("proxy")
      ? _addProxy(newRequest, options) : newRequest;
  }

  // Returns headers for Accept/Content-Type based on a short type or full mime-type.
  protected STRINGAA _typeHeaders(
    string mimetype) {
    if (mytype.contains("/")) {
      return [
        "Accept": mimetype,
        "Content-Type": mimetype,
      ];
    }

    auto typeMap = [
      "Json": "application/Json",
      "xml": "application/xml",
    ];

    if (typeMap.isNull(mimetype)) {
      throw new UIMException(
        "Unknown type alias `%s`."
          .format(mimetype));
    }

    return [
      "Accept": typeMap[mimetype],
      "Content-Type": typeMap[mimetype],
    ];
  }

  /**
     * Add authentication headers to the request.
     *
     * Uses the authentication type to choose the correct strategy
     * and use its methods to add headers.
     */
  protected IRequest _addAuthentication(Request request, Json[string] optionsWithAuthKey = null) {
    /*
    // TODO auto myauth = optionsWithAuthKey["auth"];
    // var \UIM\Http\Client\Auth\Basic  myadapter  
    auto myadapter = _createAuth(myauth, options);

    return myadapter.authentication(request, optionsWithAuthKey["auth"]); */
    return null;
  }

  /**
     * Add proxy authentication headers.
     *
     * Uses the authentication type to choose the correct strategy
     * and use its methods to add headers.
     */
  protected DRequest _addProxy(Request requestToModify, Json[string] options = null) {
    auto myauth = options.get("proxy");
    auto adapter = _createAuth(myauth, options);
    return adapter.proxyAuthentication(requestToModify, options
        .get("proxy"));
  }

  /**
     * Create the authentication strategy.
     *
     * Use the configuration options to create the correct
     * authentication strategy handler.
     */
  protected auto _createAuth(Json[string] myauth, Json[string] requestOptions = null) {
    if (isEmpty(myauth["type"])) {
      myauth["type"] = "basic";
    }
    
    auto myname = myauth.getString("type").capitalize;
    auto myclass = App.classname(myname, "Http/Client/Auth");
    if (!myclass) {
      throw new UIMException(
        "Invalid authentication type `%s`.".format(myname)
      );
    }
    return new myclass(this, requestOptions);
  }
}
