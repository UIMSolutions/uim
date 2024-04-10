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
     * @param array|null cookies _COOKIE superglobal
     * @param array|null files _FILES superglobal
     * /
    static ServerRequest fromGlobals(
        ?array server = null,
        ?array aQuery = null,
        ?array parsedBody = null,
        ?array cookies = null,
        ?array files = null
    ) {
        server = normalizeServer(server ?? _SERVER);
        ["uri": anUri, "base": base, "webroot": webroot] = UriFactory.marshalUriAndBaseFromSapi(server);

        sessionConfig = (array)Configure.read("Session") ~ [
            'defaults": 'php",
            'cookiePath": webroot,
        ];
        session = Session.create(sessionConfig);

        request = new DServerRequest([
            'environment": server,
            'uri": anUri,
            'cookies": cookies ?? _COOKIE,
            'query": aQuery ?? _GET,
            'webroot": webroot,
            'base": base,
            `session": session,
            'input": server["CAKEPHP_INPUT"] ?? null,
        ]);

        request = marshalBodyAndRequestMethod(parsedBody ?? _POST, request);
        // This is required as `ServerRequest.scheme()` ignores the value of
        // `HTTP_X_FORWARDED_PROTO` unless `trustProxy` is enabled, while the
        // `Uri` instance intially created always takes values of `HTTP_X_FORWARDED_PROTO`
        // into account.
        anUri = request.getUri().withScheme(request.scheme());
        request = request.withUri(anUri, true);

        return marshalFiles(files ?? _FILES, request);
    }
    
    /**
     * Sets the REQUEST_METHOD environment variable based on the simulated _method
     * HTTP override value. The 'ORIGINAL_REQUEST_METHOD' is also preserved, if you
     * want the read the non-simulated HTTP method the client used.
     *
     * Request body of content type "application/x-www-form-urlencoded" is parsed
     * into array for PUT/PATCH/DELETE requests.
     * Params:
     * array parsedBody Parsed body.
     * @param \UIM\Http\ServerRequest serverRequest Request instance.
     * /
    protected static ServerRequest marshalBodyAndRequestMethod(array parsedBody, ServerRequest serverRequest) {
        method = request.getMethod();
        override = false;

        if (
            in_array(method, ["PUT", "DELETE", "PATCH"], true) &&
            (string)request.contentType().startWith("application/x-www-form-urlencoded")
        ) {
            someData = (string)request.getBody();
            parse_str(someData, parsedBody);
        }
        if (request.hasHeader("X-Http-Method-Override")) {
            parsedBody["_method"] = request.getHeaderLine("X-Http-Method-Override");
            override = true;
        }
        request = request.withenviroment("ORIGINAL_REQUEST_METHOD", method);
        if (isSet(parsedBody["_method"])) {
            request = request.withenviroment("REQUEST_METHOD", parsedBody["_method"]);
            unset(parsedBody["_method"]);
            override = true;
        }
        if (
            override &&
            !in_array(request.getMethod(), ["PUT", "POST", "DELETE", "PATCH"], true)
        ) {
            parsedBody = null;
        }
        return request.withParsedBody(parsedBody);
    }
    
    /**
     * Process uploaded files and move things onto the parsed body.
     * Params:
     * array files Files array for normalization and merging in parsed body.
     * @param \UIM\Http\ServerRequest serverRequest Request instance.
     * /
    protected static ServerRequest marshalFiles(array files, ServerRequest serverRequest) {
        files = normalizeUploadedFiles(files);
        request = request.withUploadedFiles(files);

        parsedBody = request.getParsedBody();
        if (!isArray(parsedBody)) {
            return request;
        }
        parsedBody = Hash.merge(parsedBody, files);

        return request.withParsedBody(parsedBody);
    }
    
    /**
     * Create a new server request.
     *
     * Note that server-params are taken precisely as given - no parsing/processing
     * of the given values is performed, and, in particular, no attempt is made to
     * determine the HTTP method or URI, which must be provided explicitly.
     * Params:
     * string amethod The HTTP method associated with the request.
     * @param \Psr\Http\Message\IUri|string auri The URI associated with the request. If
     *    the value is a string, the factory MUST create a IUri
     *    instance based on it.
     * @param array serverParams Array of SAPI parameters with which to seed
     *    the generated request instance.
     * /
    IServerRequest createServerRequest(string amethod, anUri, array serverParams = []) {
        serverParams["REQUEST_METHOD"] = method;
        options = ["environment": serverParams];

        if (isString(anUri)) {
            anUri = (new UriFactory()).createUri(anUri);
        }
        options["uri"] = anUri;

        return new DServerRequest(options);
    } */
}
