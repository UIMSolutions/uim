/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
     */
    protected IResponse _response = null;

    /**
     * The exception being thrown if the case.
     */
    protected Throwable _exception = null;

    /**
     * Session data to use in the next request.
     */
    protected Json[string] _session = null;

    /**
     * Cookie data to use in the next request.
     */
    protected Json[string] _cookie = null;

    /**
     * The controller used in the last request.
     */
    protected IController _controller = null;

    // The last rendered view
    protected string _viewName = null;

    /**
     * The last rendered layout
     */
    protected string _layoutName = null;

    /**
     * The session instance from the last request
     */
    protected ISession _requestSession = null;

    /**
     * Boolean flag for whether the request should have
     * a SecurityComponent token added.
     */
    protected bool _securityToken = false;

    /**
     * Boolean flag for whether the request should have
     * a CSRF token added.
     */
    protected bool _csrfToken = false;

    /**
     * Boolean flag for whether the request should re-store
     * flash messages
     */
    protected bool _retainFlashMessages = false;

    /**
     * Stored flash messages before render
     */
    protected Json[string] _flashMessages = null;

    protected string _cookieEncryptionKey = null;

    // The name that will be used when retrieving the csrf token.
    protected string _csrfKeyName = "csrfToken";

    /**
     * Clears the state used for requests.
     *
     * @after
     */
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
     */
    void enableSecurityToken() {
        _securityToken = true;
    }

    // List of fields that are excluded from field validation.
    protected string[] _unlockedFields = null;

    // Set list of fields that are excluded from field validation.
    void setUnlockedFields(Json[string] unlockedFields = null) {
        _unlockedFields = unlockedFields;
    }

    /**
     * Calling this method will add a CSRF token to the request.
     *
     * Both the POST data and cookie will be populated when this option
     * is enabled. The default parameter names will be used.
     */
    void enableCsrfToken(string cookieName = "csrfToken") {
        _csrfToken = true;
        _csrfKeyName = cookieName;
    }

    /**
     * Calling this method will re-store flash messages into the test session
     * after being removed by the FlashHelper
     */
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
     */
    void configRequest(Json[string] data) {
        _request = array_merge_recursive(someData, _request);
    }

    // Sets HTTP headers for the *next* request to be identified as Json request.
    void requestAsJson() {
        this.configRequest([
            "headers": [
                "Accept": "application/Json",
                "Content-Type": "application/Json",
            
        ],]);
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
     */
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
     */
    void cookie(string name, string value) {
        _cookie[name] = value;
    }

    // Returns the encryption key to be used.
    protected string _getCookieEncryptionKey() {
        return _cookieEncryptionKey ? _cookieEncryptionKey : Security.getSalt();
    }

    /**
     * Sets a encrypted request cookie for future requests.
     *
     * The difference from cookie() is this encrypts the cookie
     * value like the CookieComponent.
     */
    void cookieEncrypted(
        string cookieName,
        string[] cookieValues,
        string encryptionMode = "aes",
        string encryptionKey = null
    ) {
        _cookieEncryptionKey = encryptionKey;
        _cookie[cookieName] = _encrypt(cookieValues, encryptionMode);
    }

    /**
     * Performs a GET request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the
     * response.
     */
    void get(string[] urlToRequest) {
        _sendRequest(urlToRequest, "GET");
    }

    /**
     * Performs a POST request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the
     * response.
     */
    void post(string[] url, string[] data = null) {
        _sendRequest(url, "POST", data);
    }

    /**
     * Performs a PATCH request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the response.
     */
    void patch(string[] url, string[] data = null) {
        _sendRequest(url, "PATCH", data);
    }

    /**
     * Performs a PUT request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the response.
     */
    void put(string[] url, string[] data = null) {
        _sendRequest(url, "PUT", someData);
    }

    /**
     * Performs a DELETE request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the response.
     */
    bool removeKey(string[] urls) {
        _sendRequest(urls, "DELETE");
        return true;
    }

    /**
     * Performs a HEAD request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the response.
     */
    void head(string[] url) {
        _sendRequest(url, "HEAD");
    }

    /**
     * Performs an OPTIONS request using the current request data.
     *
     * The response of the dispatched request will be stored as
     * a property. You can use various assert methods to check the response.
     */
    void options(string[] urls) {
        _sendRequest(urls, "OPTIONS");
    }

    /**
     * Creates and send the request into a Dispatcher instance.
     *
     * Receives and stores the response for future inspection.
     */
    protected void _sendRequest(string[] url, string httpMethod, string[] adata = null) {
        dispatcher = _makeDispatcher();
        auto resolvedUrl = dispatcher.resolveUrl(url);

        try {
            request = _buildRequest(resolvedUrl, method, someData);
            response = dispatcher.execute(request);
            _requestSession = request["session"];
            if (_retainFlashMessages && _flashMessages) {
                _requestSession.write("Flash", _flashMessages);
            }
            _response = response;
        } catch (UnitException exception) {
            throw exception;
        } catch (DatabaseException exception) {
            throw exception;
        } catch (Throwable exception) {
            _exception = anException;
            // Simulate the global exception handler being invoked.
            _handleError(anException);
        }
    }

    // Get the correct dispatcher instance.
    // TODO
    /* 
    protected DMiddlewareDispatcher _makeDispatcher() {
        EventManager.instance().on("Controller.initialize", this.controllerSpy(...));
        app = this.createApp();
        assert(cast(IHttpApplication)app);

        return new DMiddlewareDispatcher(app);
    } */

    // Adds additional event spies to the controller/view event manager.
    void controllerSpy(IEvent dispatcherEvent, IController controller = null) {
        if (!controller) {
            controller = dispatcherEvent.getSubject();
            assert(cast(DController) controller);
        }
        _controller = controller;
        auto events = controller.getEventManager();
        // TODO
        /* flashCapture = void (IEvent event) {
            if (!_retainFlashMessages) {
                return;
            }
            controller = event.getSubject();
           _flashMessages.merge(controller.getRequest().getSession().read("Flash"));
           );
        }; */
        events.on("Controller.beforeRedirect", ["priority": -100], flashCapture);
        events.on("Controller.beforeRender", ["priority": -100], flashCapture);
        // TODO events.on("View.beforeRender", void (event, viewFile) {
        /* 
            if (!_viewName) {
               _viewName = viewFile;
            }
        });
        events.on("View.beforeLayout", void (event, viewFile) {
           _layoutName = viewFile;
        }); */
    }

    /**
     * Attempts to render an error response for a given exception.
     *
     * This method will attempt to use the configured exception renderer.
     * If that class does not exist, the built-in renderer will be used.
     * Params:
     * \Throwable exceptionToHandle Exception to handle.
     */
    protected void _handleError(Throwable exceptionToHandle) {
        classname = configuration.get("Error.exceptionRenderer");
        if (classname.isEmpty || !class_hasKey(classname)) {
            classname = WebExceptionRenderer.classname;
        }

        WebExceptionRenderer anInstance = new classname(exceptionToHandle);
        _response = anInstance.render();
    }

    // Creates a request object with the configured options and parameters.
    protected Json[string] _buildRequest(string url, string httpMethod, string[] requestData = null) {
        auto sessionConfig = configuration.data("Session").setPath([
            "defaults": "D".toJson,
        ]);

        auto session = Session.create(sessionConfig);
        [url, aQuery, hostInfo] = _url(url);

        auto tokenUrl = url;

        if (aQuery) {
            tokenUrl ~= "?" ~ aQuery;
        }
        parse_str(aQuery, aQueryData);

        env = [
            "REQUEST_METHOD": method,
            "QUERY_STRING": aQuery,
            "REQUEST_URI": url,
        ];
        if (!hostInfo.isEmpty("https")) {
            env.set("HTTPS", "on");
        }
        if (hostInfo.hasKey("host")) {
            env.set("HTTP_HOST", hostInfo["host"]);
        }
        if (_request.hasKey("headers")) {
            _request["headers"].byKeyValue.each!((kv) {
                string name = kv.key.replace("-", "_").upper;
                if (!["CONTENT_LENGTH", "CONTENT_TYPE"].has(name)) {
                    name = "HTTP_" ~ name;
                }
                env[name] = kv.value;
            });
            _request.removeKey("headers");
        }

        auto props = [
            "url": url,
            "session": session,
            "query": aQueryData,
            "files": Json.emptyArray,
            "environment": env,
        ];

        if (isString(someData)) {
            props.set("input", someData);
        } else if (
            someData.isArray &&
            props.hasKey("environment.CONTENT_TYPE") &&
            props.getString("environment.CONTENT_TYPE") == "application/x-www-form-urlencoded"
            ) {
            props.set("input", http_build_query(someData));
        } else {
            someData = _addTokens(tokenUrl, someData);
            props.set("post", _castToString(someData));
        }
        props.set("cookies", _cookie);
        session.write(_session);

        return _request.dup.merge(props);
    }

    // Add the CSRF and Security Component tokens if necessary.
    protected Json[string] _addTokens(string submittedUrl, Json[string] requestBodyData) {
        Json[string] results;
        if (_securityToken == true) {
            auto fields = array_diffinternalKey(requestBodyData, array_flip(_unlockedFields));

            string[] someKeys = Hash.flatten(fields)
                .keys.map!(field => preg_replace("/(\\.\\d+)+/", "", field)).array;
            auto formProtector = new DFormProtector([
                "unlockedFields": _unlockedFields
            ]);
            someKeys.each!(field => formProtector.addFields(field));

            auto tokenData = formProtector.buildTokenData(submittedUrl, "cli");
            results.set("_Token", tokenData);
            results.set("_Token.debug", "FormProtector debug data would be added here");
        }
        if (_csrfToken == true) {
            auto middleware = new DCsrfProtectionMiddleware();
            if (!_cookie.hasKey(_csrfKeyName) && !_session.hasKey(_csrfKeyName)) {
                token = middleware.createToken();
            } else if (_cookie.hasKey(_csrfKeyName)) {
                token = _cookie.get(_csrfKeyName);
            } else {
                token = _session.get(_csrfKeyName);
            }
            // Add the token to both the session and cookie to cover
            // both types of CSRF tokens. We generate the token with the cookie
            // middleware as cookie tokens will be accepted by session csrf, but not
            // the inverse.
            _session.set(_csrfKeyName, token);
            _cookie.set(_csrfKeyName, token);
            if (!results.hasKey("_csrfToken")) {
                results.set("_csrfToken", token);
            }
        }
        return results;
    }

    // Recursively casts all data to string as that is how data would be POSTed in the real world
    protected Json[string] _castToString(Json[string] postData) {
        postData.byKeyValue
            .each!((kv) {
                if (kv.value.isScalar) {
                    someData.set(kv.key, kv.value == false ? "0" : to!string(kv.value));

                    continue;
                }

                if (kv.value.isArray) {
                    auto looksLikeFile = kv.value.hasKeys("error", "tmp_name", "size");
                    if (looksLikeFile) {
                        continue;
                    }
                    postData.set(kv.key, _castToString(kv.value));
                }
            });
        return postData;
    }

    // Creates a valid request url and parameter array more like Request._url()
    protected Json[string] _url(string url) {
        anUri = new Uri(url);
        path = anUri.path();
        aQuery = anUri.getQuery();

        hostData = null;
        if (anUri.getHost()) {
            hostData.set("host", anUri.getHost());
        }
        if (anUri.getScheme()) {
            hostData.set("https", anUri.getScheme() == "https");
        }
        return [path, aQuery, hostData];
    }

    // Get the response body as string
    protected string _getBodyAsString() {
        if (!_response) {
            fail("No response set, cannot assert content.");
        }
        return to!string(_response.getBody());
    }

    /**
     * Fetches a view variable by name.
     *
     * If the view variable does not exist, null will be returned.
     */
    Json viewVariable(string varName) {
        return _controller ? controller.viewBuilder().getVar(varName) : Json(null);
    }

    // Asserts that the response status code is in the 2xx range.
    void assertResponseOk(string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(null, new DStatusOk(_response), verboseMessage);
    }

    // Asserts that the response status code is in the 2xx/3xx range.
    void assertResponseSuccess(string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(null, new DStatusSuccess(_response), verboseMessage);
    }

    // Asserts that the response status code is in the 4xx range.
    void assertResponseError(string failureMessage = null) {
        assertThat(null, new DStatusError(_response), failureMessage);
    }

    // Asserts that the response status code is in the 5xx range.
    void assertResponseFailure(string failureMessage = null) {
        assertThat(null, new DStatusFailure(_response), failureMessage);
    }

    // Asserts a specific response status code.
    void assertResponseCode(int statusCode, string failureMessage = null) {
        assertThat(statusCode, new DStatusCode(_response), failureMessage);
    }

    // Asserts that the Location header is correct. Comparison is made against a full URL.
    void assertRedirect(string[] url = null, string failureMessage = null) {
        if (!_response) {
            fail("No response set, cannot assert header.");
        }

        auto verboseMessage = extractVerboseMessage(failureMessage);
        // TODO 
        /* 
        assertThat(null, new DHeaderSet(_response, "Location"), verboseMessage);

        if (url) {
            assertThat(
                Router.url(url, true),
                new DHeaderEquals(_response, "Location"),
                verboseMessage
           );
        } */
    }

    // Asserts that the Location header is correct. Comparison is made against exactly the URL provided.
    void assertRedirectEquals(string[] urls = null, string failureMessage = null) {
        if (!_response) {
            fail("No response set, cannot assert header.");
        }

        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(null, new DHeaderSet(_response, "Location"), verboseMessage);

        if (urls) {
            assertThat(Router.url(urls), new DHeaderEquals(_response, "Location"), verboseMessage);
        }
    }

    // Asserts that the Location header contains a substring
    void assertRedirectContains(string url, string failureMessage = null) {
        if (!_response) {
            fail("No response set, cannot assert header.");
        }

        auto verboseMessage = extractVerboseMessage(message);
        assertThat(null, new DHeaderSet(_response, "Location"), verboseMessage);
        assertThat(url, new DHeaderContains(_response, "Location"), verboseMessage);
    }

    // Asserts that the Location header does not contain a substring
    void assertRedirectNotContains(string url, string failureMessage = null) {
        if (!_response) {
            fail("No response set, cannot assert header.");
        }
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(null, new DHeaderSet(_response, "Location"), verboseMessage);
        assertThat(url, new DHeaderNotContains(_response, "Location"), verboseMessage);
    }

    // Asserts that the Location header is not set.
    void assertNoRedirect(string failureMessage = null) {
        verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(null, new DHeaderNotSet(_response, "Location"), verboseMessage);
    }

    // Asserts response headers
    void assertHeader(string headerToCheck, string content, string failureMessage = null) {
        if (!_response) {
            fail("No response set, cannot assert header.");
        }
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(null, new DHeaderSet(_response, headerToCheck), verboseMessage);
        assertThat(content, new DHeaderEquals(_response, headerToCheck), verboseMessage);
    }

    // )Asserts response header contains a string
    void assertHeaderContains(string headerToCheck, string content, string failureMessage = null) {
        if (!_response) {
            fail("No response set, cannot assert header.");
        }
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(null, new DHeaderSet(_response, headerToCheck), verboseMessage);
        assertThat(content, new DHeaderContains(_response, headerToCheck), verboseMessage);
    }

    //  Asserts response header does not contain a string
    void assertHeaderNotContains(string header, string content, string failureMessage = null) {
        if (!_response) {
            fail("No response set, cannot assert header.");
        }
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(null, new DHeaderSet(_response, header), verboseMessage);
        assertThat(content, new DHeaderNotContains(_response, header), verboseMessage);
    }

    // Asserts content type
    void assertContentType(string contentType, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(contentType, new DContentType(_response), verboseMessage);
    }

    // Asserts content in the response body equals.
    void assertResponseEquals(Json content, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(content, new BodyEquals(_response), verboseMessage);
    }

    // Asserts content in the response body not equals.
    void assertResponseNotEquals(Json content, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(content, new BodyNotEquals(_response), verboseMessage);
    }

    // Asserts content exists in the response body.
    void assertResponseContains(string content, string failureMessage = null, bool shouldIgnoreCase = false) {
        if (!_response) {
            fail("No response set, cannot assert content.");
        }
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(content, new BodyContains(_response, shouldIgnoreCase), verboseMessage);
    }

    // Asserts content does not exist in the response body.
    void assertResponseNotContains(string content, string failureMessage = null, bool shouldIgnoreCase = false) {
        if (!_response) {
            fail("No response set, cannot assert content.");
        }
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(content, new BodyNotContains(_response, shouldIgnoreCase), verboseMessage);
    }

    // Asserts that the response body matches a given regular expression.
    void assertResponseRegExp(string pattern, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(pattern, new BodyRegExp(_response), verboseMessage);
    }

    // Asserts that the response body does not match a given regular expression.
    void assertResponseNotRegExp(string pattern, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(pattern, new BodyNotRegExp(_response), verboseMessage);
    }

    // Assert response content is not empty.
    void assertResponseNotEmpty(string failureMessage = null) {
        assertThat(null, new BodyNotEmpty(_response), failureMessage);
    }

    // Assert response content is empty.
    void assertResponseEmpty(string failureMessage = null) {
        assertThat(null, new BodyEmpty(_response), failureMessage);
    }

    // Asserts that the search string was in the template name.
    void assertTemplate(string content, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(content, new DTemplateFileEquals(_viewName), verboseMessage);
    }

    // Asserts that the search string was in the layout name.
    void assertLayout(string content, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(content, new DLayoutFileEquals(_layoutName), verboseMessage);
    }

    // Asserts session contents
    void assertSession(Json expected, string path, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(expected, new DSessionEquals(path), verboseMessage);
    }

    // Asserts session key exists.
    void assertSessionHasKey(string path, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(path, new DSessionHasKey(path), verboseMessage);
    }

    // Asserts a session key does not exist.
    void assertSessionNotHasKey(string path, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(path, this.logicalNot(new DSessionHasKey(path)), verboseMessage);
    }

    // Asserts a flash message was set
    void assertFlashMessage(string aexpected, string flashKey = "flash", string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(expected, new DFlashParamEquals(_requestSession, flashKey, "message"), verboseMessage);
    }

    // Asserts a flash message was set at a certain index
    void assertFlashMessageAt(int flashIndex, string expectedMessage, string flashKey = "flash", string failureMessage = "") {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(
            expectedMessage,
            new DFlashParamEquals(_requestSession, flashKey, "message", flashIndex),
            verboseMessage
        );
    }

    // Asserts a flash element was set
    void assertFlashElement(string expectedElementName, string flashKey = "flash", string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(
            expectedElementName,
            new DFlashParamEquals(_requestSession, flashKey, "element"),
            verboseMessage
        );
    }

    // Asserts a flash element was set at a certain index
    void assertFlashElementAt(int flashIndex, string expectedElementName, string flashKey = "flash", string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(
            expectedElementName,
            new DFlashParamEquals(_requestSession, flashKey, "element", flashIndex),
            verboseMessage
        );
    }

    // Asserts cookie values
    void assertCookie(Json expectedContent, string aNacookieNameme, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(cookieName, new DCookieSet(_response), verboseMessage);
        assertThat(expectedContent, new DCookieEquals(_response, cookieName), verboseMessage);
    }

    /**
     * Asserts that a cookie is set.
     *
     * Useful when you"re working with cookies that have obfuscated values
     * but the cookie being set is important.
     */
    void assertCookieIsSet(string cookieName, string failureMessage = null) {
        verboseMessage = extractVerboseMessage(message);
        assertThat(cookieName, new DCookieSet(_response), verboseMessage);
    }

    // Asserts a cookie has not been set in the response
    void assertCookieNotSet(string cookieName, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(cookieName, new DCookieNotSet(_response), verboseMessage);
    }

    /**
     * Disable the error handler middleware.
     *
     * By using this function, exceptions are no longer caught by the ErrorHandlerMiddleware
     * and are instead re-thrown by the TestExceptionRenderer. This can be helpful
     * when trying to diagnose/debug unexpected failures in test cases.
     */
    void disableErrorHandlerMiddleware() {
        configuration.set("Error.exceptionRenderer", TestExceptionRenderer.classname);
    }

    /**
     * Asserts cookie values which are encrypted by the
     * CookieComponent.
     *
     * The difference from assertCookie() is this decrypts the cookie
     * value like the CookieComponent for this assertion.
     */
    void assertCookieEncrypted(
        Json expected,
        string cookieName,
        string encryptionMode = "aes",
        string encryptionKey = null,
        string failureMessage = null
    ) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(cookieName, new DCookieSet(_response), verboseMessage);

        _cookieEncryptionKey = encryptionKey;
        assertThat(
            expected,
            new DCookieEncryptedEquals(_response, cookieName, encrypt, _getCookieEncryptionKey())
        );
    }

    // Asserts that a file with the given name was sent in the response
    void assertFileResponse(string filePath, string failureMessage = null) {
        auto verboseMessage = extractVerboseMessage(failureMessage);
        assertThat(null, new DFileSent(_response), verboseMessage);
        assertThat(filePath, new DFileSentAs(_response), verboseMessage);

        if (!_response) {
            return;
        }
        _response.getBody().close();
    }

    // Inspect controller to extract possible causes of the failed assertion
    protected string extractVerboseMessage(string originalMessage) {
        if (cast(DException) _exception) {
            originalMessage ~= extractExceptionMessage(_exception);
        }
        if (_controller.isNull) {
            return originalMessage;
        }

        auto error = _controller.viewBuilder().getVar("error");
        if (cast(DException) error) {
            originalMessage ~= this.extractExceptionMessage(this.viewVariable("error"));
        }
        return originalMessage;
    }

    // Extract verbose message for existing exception
    protected string extractExceptionMessage(DException exceptionToExtract) {
        DException[] exceptions = [exceptionToExtract];
        auto previousException = exceptionToExtract.getPrevious();
        while (!previousException.isNull) {
            exceptions ~= previousException;
            previousException = previousException.getPrevious();
        }
        string result = D_EOL;
        foreach (index, error; exceptions) {
            result ~= index == 0
                ? "Possibly related to '%s': '%s'".format(error.classname, error.message()) ~ D_EOL
                : "Caused by '%s': '%s'".format(error.classname, error.message()) ~ D_EOL;

            result ~= error.getTraceAsString() ~ D_EOL;
        }
        return result;
    }

    protected TestSession getSession() {
        return new DTestSession(_SESSION);
    }
}
