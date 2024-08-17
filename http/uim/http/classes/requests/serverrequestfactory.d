module uim.http.classes.requests.serverrequestfactory;

import uim.http;

@safe:

/**
 * Factory for making ServerRequest instances.
 *
 * This adds in UIM specific behavior to populate the basePath and webroot
 * attributes. Furthermore the Uri`s path is corrected to only contain the
 * 'virtual' path for the request.
 */
class DServerRequestFactory { // }: ServerIRequestFactory {
    /**
     * Create a request from the supplied superglobal values.
     * If any argument is not supplied, the corresponding superglobal value will be used.
     */
    static DServerRequest fromGlobals(
        Json[string] server = null, // _SERVER superglobal
        Json[string] aQuery = null, // _GET superglobal
        Json[string] parsedBody = null, // _POST superglobal
        Json[string] cookies = null, // _COOKIE superglobal
        Json[string] files = null  // _FILES superglobal
        
    ) {
        auto server = normalizeServer(server ? server : _SERVER);
        ["uri": anUri, "base": base, "webroot": webroot] = UriFactory.marshalUriAndBaseFromSapi(
            server);

        auto sessionConfig = configuration.getMap("Session")
            .merge([
                    "defaults": "D",
                    "cookiePath": webroot,
                ]);

        auto session = Session.create(sessionConfig);
        auto request = new DServerRequest(
            createMap!(string, Json)()
                .set("environment", server)
                .set("uri", anUri)
                .set("cookies", cookies ?  ? _COOKIE)
                .set("query", aQuery ?  ? _GET)
                .set("webroot", webroot)
                .set("base", base)
                .set("session", session)
                .set("input", server.get("uimD_INPUT", null)));

        request = marshalBodyAndRequestMethod(parsedBody ? parsedBody : _POST, request);
        // This is required as `ServerRequest.scheme()` ignores the value of
        // `HTTP_X_FORWARDED_PROTO` unless `trustProxy` is enabled, while the
        // `Uri` instance intially created always takes values of `HTTP_X_FORWARDED_PROTO`
        // into account.
        auto anUri = request.getUri().withScheme(request.scheme());
        request = request.withUri(anUri, true);

        return marshalFiles(files ? files : _FILES, request);
    }

    /**
     * Sets the REQUEST_METHOD environment variable based on the simulated _method
     * HTTP override value. The 'ORIGINAL_REQUEST_METHOD' is also preserved, if you
     * want the read the non-simulated HTTP method the client used.
     *
     * Request body of content type "application/x-www-form-urlencoded" is parsed
     * into Json[string] for PUT/PATCH/DELETE requests.
     * Params:
     * Json[string] parsedBody Parsed body.
     */
    protected static ServerRequest marshalBodyAndRequestMethod(Json[string] parsedBody, ServerRequest serverRequest) {
        method = serverRequest.getMethod();
        shouldOverride = false;

        if (
            isIn(method, ["PUT", "DELETE", "PATCH"], true) &&
            (string) serverRequest.contentType().startWith("application/x-www-form-urlencoded")
            ) {
            someData = (string) serverRequest.getBody();
            parse_str(someData, parsedBody);
        }
        if (serverRequest.hasHeader("X-Http-Method-Override")) {
            parsedBody["_method"] = serverRequest.getHeaderLine("X-Http-Method-Override");
            shouldOverride = true;
        }
        serverRequest = serverRequest.withenviroment("ORIGINAL_REQUEST_METHOD", method);
        if (parsedBody.hasKey("_method")) {
            serverRequest = serverRequest.withenviroment("REQUEST_METHOD", parsedBody["_method"]);
            removeKey(parsedBody["_method"]);
            shouldOverride = true;
        }

        return shouldOverride &&
            !["PUT", "POST", "DELETE", "PATCH"].has(serverRequest.getMethod())
            ? serverRequest.withParsedBody(null) : serverRequest.withParsedBody(parsedBody);
    }

    // Process uploaded files and move things onto the parsed body.
    protected static ServerRequest marshalFiles(Json[string] files, DServerRequest serverRequest) {
        auto files = normalizeUploadedFiles(files);
        auto serverRequest = serverRequest.withUploadedFiles(files);
        auto parsedBody = serverRequest.getParsedBody();
        if (!isArray(parsedBody)) {
            return serverRequest;
        }
        return serverRequest.withParsedBody(parsedBody.merge(files));
    }

    /**
     * Create a new server request.
     *
     * Note that server-params are taken precisely as given - no parsing/processing
     * of the given values is performed, and, in particular, no attempt is made to
     * determine the HTTP method or URI, which must be provided explicitly.
     */
    IServerRequest createServerRequest(string httpMethod, string uri, Json[string] serverOptions = null) {
        return createServerRequest(httpMethod, (new UriFactory()).createUri(uri), serverOptions);
    }

    IServerRequest createServerRequest(string httpMethod, IUri uri, Json[string] serverOptions = null) {
        serverOptions.set("REQUEST_METHOD", httpMethod);
        auto options = createMap!(string. Json)
            .set("environment", serverOptions)
            .set("uri", uri);

        return new DServerRequest(options);
    }
}
