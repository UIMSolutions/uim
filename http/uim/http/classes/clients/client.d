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
 * - delete()
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
 * myhttp.get("/users", [], ["type": 'IData"]);
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

  this(IData[string] initData) {
    initialize(initData);
  }

  this(string name) {
    this().name(name);
  }

  // Hook method
  bool initialize(IData[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);

    configuration.updateDefaults([
      "auth": NullData,
      "adapter": NullData,
      "host": NullData,
      "port": NullData,
      "scheme": StringData("http"),
      "basePath": StringData(""),
      "timeout": IntegerData(30),
      "ssl_verify_peer": BooleanData(true),
      "ssl_verify_peer_name": BooleanData(true),
      "ssl_verify_depth": IntegerData(5),
      "ssl_verify_host": BooleanData(true),
      "redirect": BooleanData(false),
      "protocolVersion": StringData("1.1"),
    ]);

    return true;
  }

  mixin(TProperty!("string", "name")); /* 

  /**
     * List of cookies from responses made with this client.
     *
     * Cookies are indexed by the cookie`s domain or
     * request host name.
     * /
  protected ICookieCollection my_cookies;

  // Mock adapter for stubbing requests in tests.
  protected static DMockAdapter my_mockAdapter = null;

  // Adapter for sending requests.
  protected IAdapter my_adapter;

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
     *  Defaults to true.
     * - ssl_verify_peer_name - Whether peer names should be validated.
     *  Defaults to true.
     * - ssl_verify_depth - The maximum certificate chain depth to traverse.
     *  Defaults to 5.
     * - ssl_verify_host - Verify that the certificate and hostname match.
     *  Defaults to true.
     * - redirect - Number of redirects to follow. Defaults to false.
     * - adapter - The adapter class name or instance. Defaults to
     *  \UIM\Http\Client\Adapter\Curl if `curl` extension is loaded else
     *  \UIM\Http\Client\Adapter\Stream.
     * - protocolVersion - The HTTP protocol version to use. Defaults to 1.1
     * - auth - The authentication credentials to use. If a `username` and `password`
     *  key are provided without a `type` key Basic authentication will be assumed.
     *  You can use the `type` key to define the authentication adapter classname
     *  to use. Short class names are resolved to the `Http\Client\Auth` namespace.
     * Params:
     * IData[string] configData Config options for scoped clients.
     * /
  this(IData[string] configData = null) {
    configuration.update(configData);

    myadapter = configuration.get("adapter"];
    if (myadapter is null) {
      myadapter = Curl.classname;

      if (!extension_loaded("curl")) {
        myadapter = Stream.classname;
      }
    } else {
      configuration.update("adapter", null);
    }
    if (isString(myadapter)) {
      myadapter = new myadapter();
    }
    _adapter = myadapter;

    if (!empty(configuration.get("cookieJar"])) {
      _cookies = configuration.get("cookieJar"];
      configuration.update("cookieJar", null);
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
     * /
  static auto createFromUrl(string myurl) {
    myparts = parse_url(myurl);

    if (myparts == false) {
      throw new DInvalidArgumentException(
        "string `%s` did not parse.".format(myurl
      ));
    }
    configData = array_intersect_key(myparts, [
        "scheme": "",
        "port": "",
        "host": "",
        "path": ""
      ]);

    if (isEmpty(configData("scheme"]) || configData("host"].isEmpty) {
      throw new DInvalidArgumentException(
        "The URL was parsed but did not contain a scheme or host");
    }
    if (isSet(configData("path"])) {
      configData("basePath"] = configData("path"];
      unset(configData("path"]);
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
     * @return this
     * @throws \InvalidArgumentException
     * /
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
     * Params:
     * string myurl The url or path you want to request.
     * @param string[] mydata The query data you want to send.
     * @param IData[string] options Additional options for the request.
     * /
  Response get(string myurl, string[] mydata = [], IData[string] options = null) {
    options = _mergeOptions(options);
    mybody = null;
    if (isArray(mydata) && isSet(mydata["_content"])) {
      mybody = mydata["_content"];
      unset(mydata["_content"]);
    }
    myurl = this.buildUrl(myurl, mydata, options);

    return _doRequest(
      Request.METHOD_GET,
      myurl,
      mybody,
      options
    );
  }

  /**
     * Do a POST request.
     * Params:
     * string myurl The url or path you want to request.
     * @param IData mydata The post data you want to send.
     * @param IData[string] options Additional options for the request.
     * /
  Response post(string myurl, IData mydata = [], IData[string] options = null) {
    options = _mergeOptions(options);
    myurl = this.buildUrl(myurl, [], options);

    return _doRequest(Request.METHOD_POST, myurl, mydata, options);
  }

  /**
     * Do a PUT request.
     * Params: 
     * @param string myurl The url or path you want to request.
     * @param IData requestData The request data you want to send.
     * options = Additional options for the request.
     * /
  Response put(string myurl, IData requestData = [], IData[string] options = null) {
    options = _mergeOptions(options);
    myurl = this.buildUrl(myurl, [], options);

    return _doRequest(Request.METHOD_PUT, myurl, requestData, options);
  }

  /**
     * Do a PATCH request.
     * Params:
     * string myurl The url or path you want to request.
     * @param IData requestData The request data you want to send.
     * @param IData[string] options Additional options for the request.
     * /
  Response patch(string myurl, IData requestData = [], IData[string] options = null) {
    options = _mergeOptions(options);
    myurl = this.buildUrl(myurl, [], options);

    return _doRequest(Request.METHOD_PATCH, myurl, requestData, options);
  }

  /**
     * Do an OPTIONS request.
     * Params:
     * @param string myurl The url or path you want to request.
     * @param IData sendData The request data you want to send.
     * options = Additional options for the request.
     * /
  Response options(string myurl, IData sendData = [], IData[string] options = null) {
    options = _mergeOptions(options);
    myurl = this.buildUrl(myurl, [], options);

    return _doRequest(Request.METHOD_OPTIONS, myurl, sendData, options);
  }

  /**
     * Do a TRACE request.
     * Params:
     * string myurl The url or path you want to request.
     * @param IData sendData The request data you want to send.
     * @param IData[string] options Additional options for the request.
     * /
  Response trace(string myurl, IData sendData = [], IData[string] options = null) {
    options = _mergeOptions(options);
    myurl = this.buildUrl(myurl, [], options);

    return _doRequest(Request.METHOD_TRACE, myurl, sendData, options);
  }

  /**
     * Do a DELETE request.
     * Params:
     * string myurl The url or path you want to request.
     * @param IData sendData The request data you want to send.
     * @param IData[string] options Additional options for the request.
     * /
  Response delete(string myurl, IData sendData = [], IData[string] optionsForRequest = null) {
    auto optionsForRequest = _mergeOptions(optionsForRequest);
    auto myurl = this.buildUrl(myurl, [], optionsForRequest);

    return _doRequest(Request.METHOD_DELETE, myurl, sendData, optionsForRequest);
  }

  /**
     * Do a HEAD request.
     * Params:
     * string myurl The url or path you want to request.
     * @param array data The query string data you want to send.
     * @param IData[string] options Additional options for the request.
     * /
  Response head(string myurl, array data = [], IData[string] optionsForRequest = null) {
    auto optionsForRequest = _mergeOptions(optionsForRequest);
    auto myurl = this.buildUrl(myurl, mydata, optionsForRequest);

    return _doRequest(Request.METHOD_HEAD, myurl, "", optionsForRequest);
  }

  /**
     * Helper method for doing non-GET requests.
     * Params:
     * string mymethod HTTP method.
     * @param string myurl URL to request.
     * @param IData mydata The request body.
     * @param IData[string] options The options to use. Contains auth, proxy, etc.
     * /
  protected DClientResponse _doRequest(string mymethod, string myurl, IData mydata, IData[string] options = null) {
    myrequest = _createRequest(
      mymethod,
      myurl,
      mydata,
      options
    );

    return _send(myrequest, options);
  }

  // Does a recursive merge of the parameter with the scope config.
  // TODO protected array _mergeOptions(IData[string] optionsToMerge = null) {
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
     * @param IData[string] options Additional options to use.
     * /
  Response send(IRequest myrequest, IData[string] options = null) {
    auto myredirects = 0;
    if (isSet(options["redirect"])) {
      myredirects = (int) options["redirect"];
      unset(options["redirect"]);
    }
    do {
      myresponse = _sendRequest(myrequest, options);

      myhandleRedirect = myresponse.isRedirect() && myredirects-- > 0;
      if (myhandleRedirect) {
        auto requestUrl = myrequest.getUri();

        mylocation = myresponse.getHeaderLine("Location");
        mylocationUrl = this.buildUrl(mylocation, [], [
            "host": requestUrl.getHost(),
            "port": requestUrl.getPort(),
            "scheme": requestUrl.getScheme(),
            "protocolRelative": BooleanData(true),
          ]);
        myrequest = myrequest.withUri(new Uri(mylocationUrl));
        myrequest = _cookies.addToRequest(myrequest, []);
      }
    }
    while (myhandleRedirect);

    return myresponse;
  }

  /**
     * Clear all mocked responses
     * /
  static void clearMockResponses() {
    my_mockAdapter = null;
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
     * @param \UIM\Http\Client\Response  myresponse The response that matches the request.
     * @param IData[string] options See above.
     * /
  static void addMockResponse(string mymethod, string myurl, Response myresponse, IData[string] options = null) {
    if (!my_mockAdapter) {
      my_mockAdapter = new DMockAdapter();
    }
    myrequest = new DRequest(myurl, mymethod);
    my_mockAdapter.addResponse(myrequest, myresponse, options);
  }

  /**
     * Send a request without redirection.
     * Params:
     * \Psr\Http\Message\IRequest  myrequest The request to send.
     * @param IData[string] options Additional options to use.
     * /
  protected DClientResponse _sendRequest(IRequest myrequest, IData[string] options = null) {
    if (my_mockAdapter) {
      myresponses = my_mockAdapter.send(myrequest, options);
    }
    if (isEmpty(myresponses)) {
      myresponses = _adapter.send(myrequest, options);
    }
    myresponses.each!(response => _cookies = _cookies.addFromResponse(response, myrequest));

    /** @var \UIM\Http\Client\Response * /
    return array_pop(myresponses);
  }

  /**
     * Generate a URL based on the scoped client options.
     * Params:
     * string myurl Either a full URL or just the path.
     * @param string[] myquery The query data for the URL.
     * @param IData[string] options The config options stored with Client.config()
     * /
  string buildUrl(string myurl, string[] myquery = [], IData[string] options = null) {
    if (isEmpty(options) && empty(myquery)) {
      return myurl;
    }
    IData[string] mydefaults = [
      "host": null,
      "port": IData(null,
      "scheme": StringData("http"),
      "basePath": StringData(""),
      "protocolRelative": BooleanData(false),
    ];
    options = options.update(mydefaults);

    if (myquery) {
      myq = myurl.has("?") ? "&' : '?";
      myurl ~= myq;
      myurl ~= isString(myquery) ? myquery : http_build_query(myquery, "", "&", UIM_QUERY_RFC3986);
    }
    if (options["protocolRelative"] && myurl.startWith("//")) {
      myurl = options["scheme"] ~ ":" ~ myurl;
    }
    if (preg_match("#^https?://#", myurl)) {
      return myurl;
    }

    auto mydefaultPorts = [
      "http": 80,
      "https": 443,
    ];

    auto result = options["scheme"] ~ "://" ~ options["host"];
    if (options["port"] && (int) options["port"] != mydefaultPorts[options["scheme"]]) {
      result ~= ":" ~ options["port"];
    }
    if (!empty(options["basePath"])) {
      result ~= "/" ~ strip(options["basePath"], "/");
    }
    result ~= "/" ~ stripLeft(myurl, "/");

    return result;
  }

  /**
     * Creates a new request object based on the parameters.
     * Params:
     * string mymethod HTTP method name.
     * @param string myurl The url including query string.
     * @param IData mydata The request body.
     * @param IData[string] options The options to use. Contains auth, proxy, etc.
     * /
  protected DRequest _createRequest(string mymethod, string myurl, IData mydata, IData[string] options = null) {
    /** @var array<non-empty-string, non-empty-string>  myheaders * /
    myheaders = (array)(options["headers"] ?  ? []);
    if (isSet(options["type"])) {
      myheaders = chain(myheaders, _typeHeaders(options["type"]));
    }
    if (isString(mydata) && !isSet(myheaders["Content-Type"]) && !isSet(
        myheaders["content-type"])) {
      myheaders["Content-Type"] = "application/x-www-form-urlencoded";
    }
    myrequest = new DRequest(myurl, mymethod, myheaders, mydata);
    myrequest = myrequest.withProtocolVersion(_configData.isSet("protocolVersion"));
    mycookies = options["cookies"] ?  ? [];
    /** @var \UIM\Http\Client\Request  myrequest * /
    myrequest = _cookies.addToRequest(myrequest, mycookies);
    if (isSet(options["auth"])) {
      myrequest = _addAuthentication(myrequest, options);
    }
    if (isSet(options["proxy"])) {
      myrequest = _addProxy(myrequest, options);
    }
    return myrequest;
  }

  /**
     * Returns headers for Accept/Content-Type based on a short type
     * or full mime-type.
     *
     * @Dstan-param non-empty-string mytype
     * @param string mytype short type alias or full mimetype.
     * returns Headers to set on the request.
     * @throws \UIM\Core\Exception\UimException When an unknown type alias is used.
     * @psalm-return array<non-empty-string, non-empty-string>
     * /
  protected STRINGAA _typeHeaders(string mytype) {
    if (mytype.has("/")) {
      return [
        "Accept": mytype,
        "Content-Type": mytype,
      ];
    }
    mytypeMap = [
      "IData": "application/IData",
      "xml": "application/xml",
    ];
    if (!isSet(mytypeMap[mytype])) {
      throw new UimException(
        "Unknown type alias `%s`."
          .format(mytype));
    }
    return [
      "Accept": mytypeMap[mytype],
      "Content-Type": mytypeMap[mytype],
    ];
  }

  /**
     * Add authentication headers to the request.
     *
     * Uses the authentication type to choose the correct strategy
     * and use its methods to add headers.
     * Params:
     * \UIM\Http\Client\Request  myrequest The request to modify.
     * @param IData[string] options Array of options containing the 'auth' key.
     * /
  protected DRequest _addAuthentication(Request myrequest, IData[string] options = null) :  {
    myauth = options["auth"];
    /** @var \UIM\Http\Client\Auth\Basic  myadapter * /
    myadapter = _createAuth(myauth, options);

    return myadapter.authentication(myrequest, options["auth"]);
  }

  /**
     * Add proxy authentication headers.
     *
     * Uses the authentication type to choose the correct strategy
     * and use its methods to add headers.
     * Params:
     * \UIM\Http\Client\Request  requestToModify The request to modify.
     * @param IData[string] options Array of options containing the 'proxy' key.
     * /
  protected DRequest _addProxy(Request requestToModify, IData[string] options = null) {
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
     * array  myauth The authentication options to use.
     * /
  protected object _createAuth(array myauth, IData[string] requestOptions = null) :  {
    if (isEmpty(myauth["type"])) {
      myauth["type"] = "basic";
    }
    myname = ucfirst(myauth["type"]);
    myclass = App.className(myname, "Http/Client/Auth");
    if (!myclass) {
      throw new UimException(
        "Invalid authentication type `%s`.".format(myname)
      );
    }
    return new myclass(this, requestOptions);
  } */
}
