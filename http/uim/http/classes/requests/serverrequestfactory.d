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
     *
     * If any argument is not supplied, the corresponding superglobal value will
     * be used.
     * Params:
     * array|null server _SERVER superglobal
     * @param array|null aQuery _GET superglobal
     * @param array|null parsedBody _POST superglobal
     * @param array|null files _FILES superglobal
     */
    static DServerRequest fromGlobals(
        Json[string] server = null,
        Json[string] aQuery = null,
        Json[string] parsedBody = null,
        Json[string] cookies = null, // _COOKIE superglobal
        Json[string] files = null
    ) {
        auto server = normalizeServer(server ?  ? _SERVER);
        ["uri": anUri, "base": base, "webroot": webroot] = UriFactory.marshalUriAndBaseFromSapi(
            server);

        auto sessionConfig =  /* (array) */ configuration.get("Session") ~ [
                "defaults": "D",
                "cookiePath": webroot,
            ];

        auto session = Session.create(sessionConfig);
        auto request = new DServerRequest([
                "environment": server,
                "uri": anUri,
                "cookies": cookies ?  ? _COOKIE,
                "query": aQuery ?  ? _GET,
                "webroot": webroot,
                "base": base,
                "session": session,
                "input": server.get("uimD_INPUT", null),
            ]);

        request = marshalBodyAndRequestMethod(parsedBody ?  ? _POST, request);
        // This is required as `ServerRequest.scheme()` ignores the value of
        // `HTTP_X_FORWARDED_PROTO` unless `trustProxy` is enabled, while the
        // `Uri` instance intially created always takes values of `HTTP_X_FORWARDED_PROTO`
        // into account.
        anUri = request.getUri().withScheme(request.scheme());
        request = request.withUri(anUri, true);

        return marshalFiles(files ?  ? _FILES, request);
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
            remove(parsedBody["_method"]);
            shouldOverride = true;
        }

        return shouldOverride &&
            !["PUT", "POST", "DELETE", "PATCH"].has(serverRequest.getMethod())
            ? serverRequest.withParsedBody(null) : serverRequest.withParsedBody(parsedBody);
    }

    /**
     * Process uploaded files and move things onto the parsed body.
     * Params:
     * Json[string] files Files array for normalization and merging in parsed body.
     * @param \UIM\Http\ServerRequest serverRequest Request instance.
     */
    protected static ServerRequest marshalFiles(Json[string] files, ServerRequest serverRequest) {
        files = normalizeUploadedFiles(files);
        serverRequest = serverRequest.withUploadedFiles(files);

        parsedBody = serverRequest.getParsedBody();
        if (!isArray(parsedBody)) {
            return serverRequest;
        }
        parsedBody = Hash.merge(parsedBody, files);

        return serverRequest.withParsedBody(parsedBody);
    }

    /**
     * Create a new server request.
     *
     * Note that server-params are taken precisely as given - no parsing/processing
     * of the given values is performed, and, in particular, no attempt is made to
     * determine the HTTP method or URI, which must be provided explicitly.
     * Params:
     * string httpMethod The HTTP method associated with the request.
     * @param \Psr\Http\Message\IUri|string auri The URI associated with the request. If
     *   the value is a string, the factory MUST create a IUri
     *   instance based on it.
     */
    IServerRequest createServerRequest(string httpMethod, /* IUri */ string uri, Json[string] serverOptions = null) {
        serverOptions["REQUEST_METHOD"] = method;
        options = ["environment": serverOptions];

        if (isString(uri)) {
            uri = (new UriFactory()).createUri(uri);
        }
        options["uri"] = uri;

        return new DServerRequest(options);
    }
}
