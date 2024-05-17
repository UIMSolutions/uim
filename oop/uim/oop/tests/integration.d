module uim.oop.tests.integration;

import uim.oop;

@safe:

/**
 * A template intended to make integration tests of your controllers easier.
 *
 * This test class provides a number of helper methods and features
 * that make dispatching requests and checking their responses simpler.
 * It favours full integration tests over mock objects as you can test
 * more of your code easily and avoid some of the maintenance pitfalls
 * that mock objects create.
 */
mixin template TIntegrationTest() {
    mixin TCookieCrypt;
    mixin TContainerStub;

    // The data used to build the next request.
    protected Json[string] _request = null;

    /**
     * The response for the most recent request.
     *
     * @var \Psr\Http\Message\IResponse|null
     * /
    protected IResponse _response = null;

    /**
     * The exception being thrown if the case.
     * /
    protected Throwable _exception = null;

    /**
     * Session data to use in the next request.
     * /
    protected Json[string] _session = null;

    /**
     * Cookie data to use in the next request.
     * /
    protected Json[string] _cookie = null;

    /**
     * The controller used in the last request.
     * /
    protected IController _controller = null;

    // The last rendered view
    protected string _viewName = null;

    /**
     * The last rendered layout
     * /
    protected string _layoutName = null;

    /**
     * The session instance from the last request
     * /
    protected ISession _requestSession = null;

    /**
     * Boolean flag for whether the request should have
     * a SecurityComponent token added.
     * /
    protected bool _securityToken = false;

    /**
     * Boolean flag for whether the request should have
     * a CSRF token added.
     * /
    protected bool _csrfToken = false;

    /**
     * Boolean flag for whether the request should re-store
     * flash messages
     * /
    protected bool _retainFlashMessages = false;

    /**
     * Stored flash messages before render
     * /
    protected Json[string] _flashMessages = null;

    /**
     * @var string
     * /
    protected string _cookieEncryptionKey = null;

    /**
     * List of fields that are excluded from field validation.
     * /
    protected string[] _unlockedFields = null;

    /**
     * The name that will be used when retrieving the csrf token.
     * /
    protected string _csrfKeyName = "csrfToken";

    /**
     * Clears the state used for requests.
     *
     * @after
     * /
    auto cleanup() {
       _request = null;
       _session = null;
       _cookie = null;
       _response = null;
       _exception = null;
       _controller = null;
       _viewName = null;
       _layoutName = null;
       _requestSession = null;
       _securityToken = false;
       _csrfToken = false;
       _retainFlashMessages = false;
       _flashMessages = null;
    }
    
    /**
     * Calling this method will enable a SecurityComponent
     * compatible token to be added to request data. This
     * lets you easily test actions protected by SecurityComponent.
     * /
    void enableSecurityToken() {
       _securityToken = true;
    }
    
    /**
     * Set list of fields that are excluded from field validation.
     * Params:
     * string[] unlockedFields List of fields that are excluded from field validation.
     * /
    void setUnlockedFields(Json[string] unlockedFields = []) {
       _unlockedFields = unlockedFields;
    }
    
    /**
     * Calling this method will add a CSRF token to the request.
     *
     * Both the POST data and cookie will be populated when this option
     * is enabled. The default parameter names will be used.
     * Params:
     * string acookieName The name of the csrf token cookie.
     * /
    void enableCsrfToken(string acookieName = "csrfToken") {
       _csrfToken = true;
       _csrfKeyName = cookieName;
    }
    
    /**
     * Calling this method will re-store flash messages into the test session
     * after being removed by the FlashHelper
     * /
    void enableRetainFlashMessages() {
       _retainFlashMessages = true;
    }
    
    /**
     * Configures the data for the *next* request.
     *
     * This data is cleared in the tearDown() method.
     *
     * You can call this method multiple times to append into
     * the current state. Sub-keys will be merged with existing
     * state.
     * Params:
     * Json[string] data The request data to use.
     * /
    void configRequest(Json[string] data) {
       _request = array_merge_recursive(someData, _request);
    }
    
    /**
     * Sets HTTP headers for the *next* request to be identified as Json request.
     * /
    void requestAsJson() {
        this.configRequest([
            "headers": [
                "Accept": "application/Json",
                "Content-Type": "application/Json",
            ],
        ]);
    }
    
    /**
     * Sets session data.
     *
     * This method lets you configure the session data
     * you want to be used for requests that follow. The session
     * state is reset in each tearDown().
     *
     * You can call this method multiple times to append into
     * the current state.
     * Params:
     * Json[string] data The session data to use.
     * /
    void session(Json[string] data) {
       _session = someData + _session;
    }
    
    /**
     * Sets a request cookie for future requests.
     *
     * This method lets you configure the session data
     * you want to be used for requests that follow. The session
     * state is reset in each tearDown().
     *
     * You can call this method multiple times to append into
     * the current state.
     * Params:
     * string aName The cookie name to use.
     * @param string avalue The value of the cookie.
     * /
    void cookie(string aName, string avalue) {
       _cookie[name] = aValue;
    }
    
    /**
     * Returns the encryption key to be used.
     * /
    protected string _getCookieEncryptionKey() {
        return _cookieEncryptionKey ?? Security.getSalt();
    }
    
    /**
     * Sets a encrypted request cookie for future requests.
     *
     * The difference from cookie() is this encrypts the cookie
     * value like the CookieComponent.
     * Params:
     * string aName The cookie name to use.
     * @param string[] avalue The value of the cookie.
     * @param string|false encrypt Encryption mode to use.
     * @param string aKey Encryption key used. Defaults
     *  to Security.salt.
     * /
    void cookieEncrypted(
        string aName,
        string[] avalue,
        string|false encrypt = "aes",
        string aKey = null
    ) {
       _cookieEncryptionKey = aKey;
       _cookie[name] = _encrypt(aValue, encrypt);
    }
    
    /**
     * Performs a GET request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the
     * response.
     * Params:
     * string[] aurl The URL to request.
     * /
    void get(string[] aurl) {
       _sendRequest(url, "GET");
    }
    
    /**
     * Performs a POST request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the
     * response.
     * Params:
     * string[] aurl The URL to request.
     * @param string[] adata The data for the request.
     * /
    void post(string[] aurl, string[] adata = []) {
       _sendRequest(url, "POST", someData);
    }
    
    /**
     * Performs a PATCH request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the response.
     * Params:
     * string[] aurl The URL to request.
     * @param string[] adata The data for the request.
     * /
    void patch(string[] aurl, string[] adata = []) {
       _sendRequest(url, "PATCH", someData);
    }
    
    /**
     * Performs a PUT request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the response.
     * Params:
     * string[] aurl The URL to request.
     * @param string[] adata The data for the request.
     * /
    void put(string[] aurl, string[] adata = []) {
       _sendRequest(url, "PUT", someData);
    }
    
    /**
     * Performs a DELETE request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the response.
     * Params:
     * string[] aurl The URL to request.
     * /
    void remove(string[] aurl) {
       _sendRequest(url, "DELETE");
    }
    
    /**
     * Performs a HEAD request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the response.
     * Params:
     * string[] aurl The URL to request.
     * /
    void head(string[] aurl) {
       _sendRequest(url, "HEAD");
    }
    
    /**
     * Performs an OPTIONS request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the response.
     * Params:
     * string[] aurl The URL to request.
     * /
    void options(string[] aurl) {
       _sendRequest(url, "OPTIONS");
    }
    
    /**
     * Creates and send the request into a Dispatcher instance.
     *
     * Receives and stores the response for future inspection.
     * Params:
     * string[] aurl The URL
     * @param string httpMethod The HTTP method
     * @param string[] adata The request data.
     * @throws \Unit\Exception|\Throwable
     * /
    protected void _sendRequest(string[] aurl, string httpMethod, string[] adata = []) {
        dispatcher = _makeDispatcher();
        url = dispatcher.resolveUrl(url);

        try {
            request = _buildRequest(url, method, someData);
            response = dispatcher.execute(request);
           _requestSession = request["session"];
            if (_retainFlashMessages && _flashMessages) {
               _requestSession.write("Flash", _flashMessages);
            }
           _response = response;
        } catch (UnitException | DatabaseException  anException) {
            throw  anException;
        } catch (Throwable  anException) {
           _exception = anException;
            // Simulate the global exception handler being invoked.
           _handleError(anException);
        }
    }
    
    /**
     * Get the correct dispatcher instance.
     * /
    protected DMiddlewareDispatcher _makeDispatcher() {
        EventManager.instance().on("Controller.initialize", this.controllerSpy(...));
        app = this.createApp();
        assert(cast(IHttpApplication)app);

        return new DMiddlewareDispatcher(app);
    }
    
    /**
     * Adds additional event spies to the controller/view event manager.
     * Params:
     * \UIM\Event\IEvent event A dispatcher event.
     * @param \UIM\Controller\Controller|null controller Controller instance.
     * /
    void controllerSpy(IEvent event, ?Controller controller = null) {
        if (!controller) {
            controller = event.getSubject();
            assert(cast(DController)controller);
        }
       _controller = controller;
        events = controller.getEventManager();
        flashCapture = void (IEvent event) {
            if (!_retainFlashMessages) {
                return;
            }
            controller = event.getSubject();
           _flashMessages = Hash.merge(
               _flashMessages,
                controller.getRequest().getSession().read("Flash")
            );
        };
        events.on("Controller.beforeRedirect", ["priority": -100], flashCapture);
        events.on("Controller.beforeRender", ["priority": -100], flashCapture);
        events.on("View.beforeRender", void (event, viewFile) {
            if (!_viewName) {
               _viewName = viewFile;
            }
        });
        events.on("View.beforeLayout", void (event, viewFile) {
           _layoutName = viewFile;
        });
    }
    
    /**
     * Attempts to render an error response for a given exception.
     *
     * This method will attempt to use the configured exception renderer.
     * If that class does not exist, the built-in renderer will be used.
     * Params:
     * \Throwable exceptionToHandle Exception to handle.
     * /
    protected void _handleError(Throwable exceptionToHandle) {
         className = configuration.get("Error.exceptionRenderer");
        if (className.isEmpty || !class_exists(className)) {
             className = WebExceptionRenderer.classname;
        }

        WebExceptionRenderer anInstance = new className(exceptionToHandle);
       _response = anInstance.render();
    }
    
    /**
     * Creates a request object with the configured options and parameters.
     * Params:
     * string aurl The URL
     * @param string httpMethod The HTTP method
     * @param string[] adata The request data.
     * /
    protected Json[string] _buildRequest(string aurl, string httpMethod, string[] adata = []) {
        sessionConfig = (array)configuration.get("Session") ~ [
            "defaults": "D",
        ];
        session = Session.create(sessionConfig);
        [url, aQuery, hostInfo] = _url(url);
        tokenUrl = url;

        if (aQuery) {
            tokenUrl ~= "?" ~ aQuery;
        }
        parse_str(aQuery, aQueryData);

        env = [
            "REQUEST_METHOD": method,
            "QUERY_STRING": aQuery,
            "REQUEST_URI": url,
        ];
        if (!hostInfo.isEmpty("https"))) {
            env["HTTPS"] = "on";
        }
        if (isSet(hostInfo["host"])) {
            env["HTTP_HOST"] = hostInfo["host"];
        }
        if (isSet(_request["headers"])) {
            foreach (_request["headers"] as myKey: v) {
                name = myKey.replace("-", "_").upper;
                if (!in_array(name, ["CONTENT_LENGTH", "CONTENT_TYPE"], true)) {
                    name = "HTTP_" ~ name;
                }
                env[name] = v;
            }
            _request.remove("headers");
        }
        props = [
            "url": url,
            "session": session,
            "query": aQueryData,
            "files": Json.emptyArray,
            "environment": env,
        ];

        if (isString(someData)) {
            props["input"] = someData;
        } else if (
            someData.isArray &&
            isSet(props["environment"]["CONTENT_TYPE"]) &&
            props["environment"]["CONTENT_TYPE"] == "application/x-www-form-urlencoded"
        ) {
            props["input"] = http_build_query(someData);
        } else {
            someData = _addTokens(tokenUrl, someData);
            props["post"] = _castToString(someData);
        }
        props["cookies"] = _cookie;
        session.write(_session);

        return Hash.merge(props, _request);
    }
    
    /**
     * Add the CSRF and Security Component tokens if necessary.
     * Params:
     * string aurl The URL the form is being submitted on.
     * @param Json[string] data The request body data.
     * /
    protected Json[string] _addTokens(string aurl, Json[string] data) {
        if (_securityToken == true) {
            fields = array_diff_key(someData, array_flip(_unlockedFields));

            someKeys = array_map(function (field) {
                return preg_replace("/(\.\d+)+/", "", field);
            }, Hash.flatten(fields).keys);

            auto formProtector = new DFormProtector(["unlockedFields": _unlockedFields]);
            someKeys.each!(field => formProtector.addField(field));
            tokenData = formProtector.buildTokenData(url, "cli");

            someData["_Token"] = tokenData;
            someData["_Token"]["debug"] = "FormProtector debug data would be added here";
        }
        if (_csrfToken == true) {
            auto middleware = new DCsrfProtectionMiddleware();
            if (!isSet(_cookie[_csrfKeyName]) && !isSet(_session[_csrfKeyName])) {
                token = middleware.createToken();
            } else if (isSet(_cookie[_csrfKeyName])) {
                token = _cookie[_csrfKeyName];
            } else {
                token = _session[_csrfKeyName];
            }
            // Add the token to both the session and cookie to cover
            // both types of CSRF tokens. We generate the token with the cookie
            // middleware as cookie tokens will be accepted by session csrf, but not
            // the inverse.
           _session[_csrfKeyName] = token;
           _cookie[_csrfKeyName] = token;
            if (!someData.isSet("_csrfToken")) {
                someData["_csrfToken"] = token;
            }
        }
        return someData;
    }
    
    /**
     * Recursively casts all data to string as that is how data would be POSTed in
     * the real world
     * Params:
     * Json[string] data POST data
     * /
    protected Json[string] _castToString(Json[string] data) {
        someData.byKeyValue
            .each!((kv) {
            if (isScalar(kv.value)) {
                someData[kv.key] = kv.value == false ? "0" : to!string(kv.value);

                continue;
            }
            
            if (isArray(kv.value)) {
                auto looksLikeFile = isSet(kv.value["error"], kv.value["tmp_name"], kv.value["size"]);
                if (looksLikeFile) {
                    continue;
                }
                someData[kv.key] = _castToString(kv.value);
            }
        });
        return someData;
    }
    
    /**
     * Creates a valid request url and parameter array more like Request._url()
     * Params:
     * string aurl The URL
     * /
    protected Json[string] _url(string aurl) {
        anUri = new Uri(url);
        somePath = anUri.getPath();
        aQuery = anUri.getQuery();

        hostData = null;
        if (anUri.getHost()) {
            hostData["host"] = anUri.getHost();
        }
        if (anUri.getScheme()) {
            hostData["https"] = anUri.getScheme() == "https";
        }
        return [somePath, aQuery, hostData];
    }
    
    /**
     * Get the response body as string
     * /
    protected string _getBodyAsString() {
        if (!_response) {
            this.fail("No response set, cannot assert content.");
        }
        return to!string(_response.getBody());
    }
    
    /**
     * Fetches a view variable by name.
     *
     * If the view variable does not exist, null will be returned.
     * Params:
     * string aName The view variable to get.
     * /
    Json viewVariable(string aName) {
        return _controller?.viewBuilder().getVar(name);
    }
    
    // Asserts that the response status code is in the 2xx range.
    void assertResponseOk(string failureMessage= null) {
        auto verboseMessage = this.extractVerboseMessage(failureMessage);
        this.assertThat(null, new DStatusOk(_response), verboseMessage);
    }
    
    // Asserts that the response status code is in the 2xx/3xx range.
    void assertResponseSuccess(string failureMessage = null) {
        auto verboseMessage = this.extractVerboseMessage(failureMessage);
        this.assertThat(null, new DStatusSuccess(_response), verboseMessage);
    }
    
    // Asserts that the response status code is in the 4xx range.
    void assertResponseError(string failureMessage = null) {
        this.assertThat(null, new DStatusError(_response), failureMessage);
    }
    
    // Asserts that the response status code is in the 5xx range.
    void assertResponseFailure(string failureMessage= null) {
        this.assertThat(null, new DStatusFailure(_response), failureMessage);
    }
    
    /**
     * Asserts a specific response status code.
     * Params:
     * int code Status code to assert.
     * @param string amessage Custom message for failure.
     * /
    void assertResponseCode(int statusCode, string failureMessage = null) {
        this.assertThat(statusCode, new DStatusCode(_response), failureMessage);
    }
    
    /**
     * Asserts that the Location header is correct. Comparison is made against a full URL.
     * Params:
     * string[] url The URL you expected the client to go to. This
     *  can either be a string URL or an array compatible with Router.url(). Use null to
     *  simply check for the existence of this header.
     * @param string amessage The failure message that will be appended to the generated message.
     * /
    void assertRedirect(string[] url = null, string failureMessage= null)) {
        if (!_response) {
            this.fail("No response set, cannot assert header.");
        }
        
        auto verboseMessage = this.extractVerboseMessage(failureMessage);
        this.assertThat(null, new DHeaderSet(_response, "Location"), verboseMessage);

        if (url) {
            this.assertThat(
                Router.url(url, true),
                new DHeaderEquals(_response, "Location"),
                verboseMessage
            );
        }
    }
    
    /**
     * Asserts that the Location header is correct. Comparison is made against exactly the URL provided.
     * Params:
     * string[] url The URL you expected the client to go to. This
     *  can either be a string URL or an array compatible with Router.url(). Use null to
     *  simply check for the existence of this header.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertRedirectEquals(string[] url = null, string failureMessage = null) {
        if (!_response) {
            this.fail("No response set, cannot assert header.");
        }
        
        auto verboseMessage = this.extractVerboseMessage(failureMessage);
        this.assertThat(null, new DHeaderSet(_response, "Location"), verboseMessage);

        if (url) {
            this.assertThat(Router.url(url), new DHeaderEquals(_response, "Location"), verboseMessage);
        }
    }
    
    /**
     * Asserts that the Location header contains a substring
     * Params:
     * string aurl The URL you expected the client to go to.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertRedirectContains(string aurl, string message = null) {
        if (!_response) {
            this.fail("No response set, cannot assert header.");
        }
        
        auto verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(null, new DHeaderSet(_response, "Location"), verboseMessage);
        this.assertThat(url, new DHeaderContains(_response, "Location"), verboseMessage);
    }
    
    /**
     * Asserts that the Location header does not contain a substring
     * Params:
     * string aurl The URL you expected the client to go to.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertRedirectNotContains(string aurl, string amessage = null) {
        if (!_response) {
            this.fail("No response set, cannot assert header.");
        }
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(null, new DHeaderSet(_response, "Location"), verboseMessage);
        this.assertThat(url, new DHeaderNotContains(_response, "Location"), verboseMessage);
    }
    
    // Asserts that the Location header is not set.
    void assertNoRedirect(string failureMessage = null) {
        verboseMessage = this.extractVerboseMessage(failureMessage);
        this.assertThat(null, new DHeaderNotSet(_response, "Location"), verboseMessage);
    }
    
    /**
     * Asserts response headers
     * Params:
     * string aheader The header to check
     * @param string acontent The content to check for.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertHeader(string aheader, string acontent, string amessage = null) {
        if (!_response) {
            this.fail("No response set, cannot assert header.");
        }
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(null, new DHeaderSet(_response,  aHeader), verboseMessage);
        this.assertThat(content, new DHeaderEquals(_response,  aHeader), verboseMessage);
    }
    
    /**
     * Asserts response header contains a string
     * Params:
     * string aheader The header to check
     * @param string acontent The content to check for.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertHeaderContains(string aheader, string acontent, string amessage = null) {
        if (!_response) {
            this.fail("No response set, cannot assert header.");
        }
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(null, new DHeaderSet(_response,  aHeader), verboseMessage);
        this.assertThat(content, new DHeaderContains(_response,  aHeader), verboseMessage);
    }
    
    /**
     * Asserts response header does not contain a string
     * Params:
     * string aheader The header to check
     * @param string acontent The content to check for.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertHeaderNotContains(string aheader, string acontent, string amessage = null) {
        if (!_response) {
            this.fail("No response set, cannot assert header.");
        }
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(null, new DHeaderSet(_response,  aHeader), verboseMessage);
        this.assertThat(content, new DHeaderNotContains(_response,  aHeader), verboseMessage);
    }
    
    /**
     * Asserts content type
     * Params:
     * string atype The content-type to check for.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertContentType(string atype, string amessage = null) {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(type, new DContentType(_response), verboseMessage);
    }
    
    /**
     * Asserts content in the response body equals.
     * Params:
     * Json content The content to check for.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertResponseEquals(Json content, string amessage= null) {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(content, new BodyEquals(_response), verboseMessage);
    }
    
    /**
     * Asserts content in the response body not equals.
     * Params:
     * Json content The content to check for.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertResponseNotEquals(Json content, string amessage = null) {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(content, new BodyNotEquals(_response), verboseMessage);
    }
    
    /**
     * Asserts content exists in the response body.
     * Params:
     * string acontent The content to check for.
     * @param string amessage The failure message that will be appended to the generated message.
     * @param bool  anIgnoreCase A flag to check whether we should ignore case or not.
     */
    void assertResponseContains(string acontent, string amessage = "", bool  anIgnoreCase = false) {
        if (!_response) {
            this.fail("No response set, cannot assert content.");
        }
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(content, new BodyContains(_response,  anIgnoreCase), verboseMessage);
    }
    
    /**
     * Asserts content does not exist in the response body.
     * Params:
     * string acontent The content to check for.
     * @param string amessage The failure message that will be appended to the generated message.
     * @param bool  anIgnoreCase A flag to check whether we should ignore case or not.
     */
    void assertResponseNotContains(string acontent, string amessage = "", bool  anIgnoreCase = false) {
        if (!_response) {
            this.fail("No response set, cannot assert content.");
        }
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(content, new BodyNotContains(_response,  anIgnoreCase), verboseMessage);
    }
    
    /**
     * Asserts that the response body matches a given regular expression.
     * Params:
     * string apattern The pattern to compare against.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertResponseRegExp(string apattern, string amessage = null) {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(somePattern, new BodyRegExp(_response), verboseMessage);
    }
    
    /**
     * Asserts that the response body does not match a given regular expression.
     * Params:
     * string apattern The pattern to compare against.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertResponseNotRegExp(string apattern, string amessage = null) {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(somePattern, new BodyNotRegExp(_response), verboseMessage);
    }
    
    /**
     * Assert response content is not empty.
     * Params:
     * string amessage The failure message that will be appended to the generated message.
     */
    void assertResponseNotEmpty(string failureMessage = "") {
        this.assertThat(null, new BodyNotEmpty(_response), failureMessage);
    }
    
    /**
     * Assert response content is empty.
     * Params:
     * string amessage The failure message that will be appended to the generated message.
     */
    void assertResponseEmpty(string amessage = null) {
        this.assertThat(null, new BodyEmpty(_response), message);
    }
    
    /**
     * Asserts that the search string was in the template name.
     * Params:
     * string acontent The content to check for.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertTemplate(string acontent, string amessage = null) {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(content, new DTemplateFileEquals(_viewName), verboseMessage);
    }
    
    /**
     * Asserts that the search string was in the layout name.
     * Params:
     * string acontent The content to check for.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertLayout(string acontent, string amessage = null) {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(content, new DLayoutFileEquals(_layoutName), verboseMessage);
    }
    
    /**
     * Asserts session contents
     * Params:
     * Json expected The expected contents.
     * @param string aPath The session data path. Uses Hash.get() compatible notation
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertSession(Json expected, string aPath, string message = "") {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(expected, new DSessionEquals(somePath), verboseMessage);
    }
    
    /**
     * Asserts session key exists.
     * Params:
     * string aPath The session data path. Uses Hash.get() compatible notation.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertSessionHasKey(string aPath, string amessage = "") {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(somePath, new DSessionHasKey(somePath), verboseMessage);
    }
    
    /**
     * Asserts a session key does not exist.
     * Params:
     * string aPath The session data path. Uses Hash.get() compatible notation.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertSessionNotHasKey(string aPath, string amessage = null) {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(somePath, this.logicalNot(new DSessionHasKey(somePath)), verboseMessage);
    }
    
    /**
     * Asserts a flash message was set
     * Params:
     * string aexpected Expected message
     * @param string aKey Flash key
     * @param string amessage Assertion failure message
     */
    void assertFlashMessage(string aexpected, string aKey = "flash", string amessage = null) {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(expected, new DFlashParamEquals(_requestSession, aKey, "message"), verboseMessage);
    }
    
    /**
     * Asserts a flash message was set at a certain index
     * Params:
     * int at Flash index
     * @param string aexpected Expected message
     * @param string aKey Flash key
     * @param string amessage Assertion failure message
     */
    void assertFlashMessageAt(int at, string aexpected, string aKey = "flash", string amessage = "") {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(
            expected,
            new DFlashParamEquals(_requestSession, aKey, "message", at),
            verboseMessage
        );
    }
    
    /**
     * Asserts a flash element was set
     * Params:
     * string aexpected Expected element name
     * @param string aKey Flash key
     * @param string amessage Assertion failure message
     */
    void assertFlashElement(string aexpected, string aKey = "flash", string amessage = "") {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(
            expected,
            new DFlashParamEquals(_requestSession, aKey, "element"),
            verboseMessage
        );
    }
    
    /**
     * Asserts a flash element was set at a certain index
     * Params:
     * int at Flash index
     * @param string aexpected Expected element name
     * @param string aKey Flash key
     * @param string amessage Assertion failure message
     */
    void assertFlashElementAt(int at, string aexpected, string aKey = "flash", string amessage = "") {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(
            expected,
            new DFlashParamEquals(_requestSession, aKey, "element", at),
            verboseMessage
        );
    }
    
    /**
     * Asserts cookie values
     * Params:
     * Json expected The expected contents.
     * @param string aName The cookie name.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertCookie(Json expected, string aName, string amessage = "") {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(name, new DCookieSet(_response), verboseMessage);
        this.assertThat(expected, new DCookieEquals(_response, name), verboseMessage);
    }
    
    /**
     * Asserts that a cookie is set.
     *
     * Useful when you"re working with cookies that have obfuscated values
     * but the cookie being set is important.
     * Params:
     * string aName The cookie name.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertCookieIsSet(string aName, string amessage = "") {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(name, new DCookieSet(_response), verboseMessage);
    }
    
    /**
     * Asserts a cookie has not been set in the response
     * Params:
     * string acookie The cookie name to check
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertCookieNotSet(string acookie, string amessage = null) {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(cookie, new DCookieNotSet(_response), verboseMessage);
    }
    
    /**
     * Disable the error handler middleware.
     *
     * By using this function, exceptions are no longer caught by the ErrorHandlerMiddleware
     * and are instead re-thrown by the TestExceptionRenderer. This can be helpful
     * when trying to diagnose/debug unexpected failures in test cases.
     */
    void disableErrorHandlerMiddleware() {
        Configuration.update("Error.exceptionRenderer", TestExceptionRenderer.classname);
    }
    
    /**
     * Asserts cookie values which are encrypted by the
     * CookieComponent.
     *
     * The difference from assertCookie() is this decrypts the cookie
     * value like the CookieComponent for this assertion.
     * Params:
     * Json expected The expected contents.
     * @param string aName The cookie name.
     * @param string aencrypt Encryption mode to use.
     * @param string aKey Encryption key used. Defaults
     *  to Security.salt.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertCookieEncrypted(
        Json expected,
        string aName,
        string aencrypt = "aes",
        string aKey = null,
        string amessage = null
    ) {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(name, new DCookieSet(_response), verboseMessage);

       _cookieEncryptionKey = aKey;
        this.assertThat(
            expected,
            new DCookieEncryptedEquals(_response, name, encrypt, _getCookieEncryptionKey())
        );
    }
    
    /**
     * Asserts that a file with the given name was sent in the response
     * Params:
     * string aexpected The absolute file path that should be sent in the response.
     * @param string amessage The failure message that will be appended to the generated message.
     */
    void assertFileResponse(string aexpected, string amessage = "") {
        verboseMessage = this.extractVerboseMessage(message);
        this.assertThat(null, new DFileSent(_response), verboseMessage);
        this.assertThat(expected, new DFileSentAs(_response), verboseMessage);

        if (!_response) {
            return;
        }
       _response.getBody().close();
    }
    
    /**
     * Inspect controller to extract possible causes of the failed assertion
     * Params:
     * string amessage Original message to use as a base
     * /
    protected string extractVerboseMessage(string message) {
        if (cast(DException)_exception) {
            message ~= this.extractExceptionMessage(_exception);
        }
        if (_controller.isNull) {
            return message;
        }
        error = _controller.viewBuilder().getVar("error");
        if (cast(DException)error) {
            message ~= this.extractExceptionMessage(this.viewVariable("error"));
        }
        return message;
    }
    
    // Extract verbose message for existing exception
    protected string extractExceptionMessage(Exception exceptionToExtract) {
        Exception[] exceptions = [exceptionToExtract];
        previous = exceptionToExtract.getPrevious();
        while (previous !isNull) {
            exceptions ~= previous;
            previous = previous.getPrevious();
        }
        string result = D_EOL;
        foreach (exceptions as  anI: error) {

            if (anI == 0) {
                result ~= "Possibly related to `%s`: "%s"".format(error.classname, error.getMessage());
                result ~= D_EOL;
            } else {
                result ~= "Caused by `%s`: "%s"".format(error.classname, error.getMessage());
                result ~= D_EOL;
            }
            result ~= error.getTraceAsString();
            result ~= D_EOL;
        }
        return result;
    }
    
    protected TestSession getSession() {
        return new DTestSession(_SESSION);
    } */
}
