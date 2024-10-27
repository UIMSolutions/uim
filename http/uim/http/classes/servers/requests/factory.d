/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.servers.requests.factory;

import uim.http;

@safe:

/**
 * Factory for making ServerRequest instances.
 *
 * This adds in UIM specific behavior to populate the basePath and webroot
 * attributes. Furthermore the Uri`s path is corrected to only contain the
 * 'virtual' path for the request.
 */
class DServerRequestFactory : DFactory!DServerRequest {
  static DServerRequestFactory factory;
  /**
     * Create a request from the supplied superglobal values.
     * If any argument is not supplied, the corresponding superglobal value will be used.
     */
  DServerRequest fromGlobals(
    Json[string] server = null, // _SERVER superglobal
    Json[string] aQuery = null, // _GET superglobal
    Json[string] parsedBody = null, // _POST superglobal
    Json[string] cookies = null, // _COOKIE superglobal
    Json[string] files = null  // _FILES superglobal    

    

  ) {
    /*         auto server = normalizeServer(server ? server : _SERVER);
        ["uri": anUri, "base": base, "webroot": webroot] = UriFactory.marshalUriAndBaseFromSapi(
            server);

        auto sessionConfig = configuration.getMap("Session")
            .merge([
                    "defaults": "D",
                    "cookiePath": webroot,
                ]);

        auto session = Session.create(sessionConfig);
        auto request = new DServerRequest(
            createMap!(string, Json)
                .set("environment", server)
                .set("uri", anUri)
                /* .set("cookies", cookies ?  ? _COOKIE)
                .set("query", aQuery ?  aQuery : _GET)
                .set("webroot", webroot)
                .set("base", base)
                .set("session", session)
                .set("input", server.get("uimD_INPUT", null)) * /);

        request = marshalBodyAndRequestMethod(parsedBody ? parsedBody : _POST, request);
        // This is required as `ServerRequest.scheme()` ignores the value of
        // `HTTP_X_FORWARDED_PROTO` unless `trustProxy` is enabled, while the
        // `Uri` instance intially created always takes values of `HTTP_X_FORWARDED_PROTO`
        // into account.
        auto anUri = request.getUri().withScheme(request.scheme());
        request = request.withUri(anUri, true);

        return marshalFiles(files ? files : _FILES, request); */
    return null;
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
  protected DServerRequest marshalBodyAndRequestMethod(Json[string] parsedBody, DServerRequest serverRequest) {
    /* auto method = serverRequest.getMethod();
        auto shouldOverride = false;

        if (
            isIn(method, ["PUT", "DELETE", "PATCH"], true) &&
           /*  (string) * / serverRequest.contentType().startsWith("application/x-www-form-urlencoded")
            ) {
            auto someData = /* (string) * / serverRequest.getBody();
            parse_str(someData, parsedBody);
        }
        if (serverRequest.hasHeader("X-Http-Method-Override")) {
            parsedBody["_method"] = serverRequest.getHeaderLine("X-Http-Method-Override");
            shouldOverride = true;
        }
        serverRequest = ServerFactory.withEnviroment(serverRequest, "ORIGINAL_REQUEST_METHOD", method);
        if (parsedBody.hasKey("_method")) {
            serverRequest = serverRequest.withEnviroment("REQUEST_METHOD", parsedBody["_method"]);
            removeKey(parsedBody["_method"]);
            shouldOverride = true;
        }

        return shouldOverride &&
            !["PUT", "POST", "DELETE", "PATCH"].has(serverRequest.getMethod())
            ? ServerFactory.withParsedBody(serverRequest, null) : ServerFactory.withParsedBody(serverRequest, parsedBody); */
    return null;
  }

  // Process uploaded files and move things onto the parsed body.
  protected DServerRequest marshalFiles(Json[string] files, DServerRequest serverRequest) {
    /* auto files = normalizeUploadedFiles(files);
        auto serverRequest = serverRequest.withUploadedFiles(files);
        auto parsedBody = ServerFactory.withParsedBody(serverRequest);
        if (!isArray(parsedBody)) {
            return serverRequest;
        }
        return ServerFactory.withParsedBody(serverRequest, parsedBody.merge(files)); */
    return null;
  }

  /**
     * Create a new server request.
     *
     * Note that server-params are taken precisely as given - no parsing/processing
     * of the given values is performed, and, in particular, no attempt is made to
     * determine the HTTP method or URI, which must be provided explicitly.
     */
  DServerRequest createServerRequest(string httpMethod, string uri, Json[string] serverOptions = null) {
    // return createServerRequest(httpMethod, (new UriFactory()).createUri(uri), serverOptions);
    return null;
  }

  DServerRequest createServerRequest(string httpMethod, IUri uri, Json[string] serverOptions = null) {
    /*  serverOptions.set("REQUEST_METHOD", httpMethod);
        auto options = createMap!(string.Json)
            .set("environment", serverOptions)
            .set("uri", uri);

        return new DServerRequest(options); */
    return null;
  }

  // Replace the cookies and get a new request instance.
  DServerRequest withCookieParams(DServerRequest request, Json[string] someData) {
    /* DServerRequest newRequest = cast(DServerRequest)request.clone;
    // newRequest.cookies = cookies;

    return newRequest; */
    return null;
  }
  /**
     * Update the parsed body and get a new instance.
     * Params:
     * object|array|null someData The deserialized body data. This will
     *   typically be in an array or object.
     */
  DServerRequest withParsedBody(DServerRequest request, Json[string] someData) {
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    // newRequest.data = someData;

    return newRequest;
  }

  // Return an instance without the specified request attribute.
  DServerRequest withoutAttribute(DServerRequest request, string name) {
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    /* auto newRequest = this.clone;
    if (isIn(name, _emulatedAttributes, true)) {
      throw new DInvalidArgumentException(
        "You cannot unset 'name'. It is a required UIM attribute."
      );
    }
    removeKey(newRequest.attributes[name]); */

    return newRequest;
  }

  // Return an instance with the specified request attribute.
  DServerRequest withAttribute(DServerRequest request, string attributeName, Json aValue) {
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    /* if (isIn(attributeName, _emulatedAttributes, true)) {
      /* newRequest. {
                attributeName
            }
             = aValue; * /
    } else {
      newRequest.attributes[attributeName] = aValue;
    } */

    return newRequest;
  }

  /**
     * Update the request with a new routing parameter
     *
     * Returns an updated request object. This method returns
     * a *new* request object and does not mutate the request in-place.
     */
  DServerRequest withParam(DServerRequest request, string insertPath, Json valueToInsert) {
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    /* newRequest.params = Hash.insert(copy.params, insertPath, valueToInsert);
*/
    return newRequest;
  }

  /**
     * Return an instance with the specified HTTP protocol version.
     *
     * The version string MUST contain only the HTTP version number (e.g.,
     * "1.1", "1.0").
     */
  DServerRequest withProtocolVersion(DServerRequest request, string protocolVersion) {
    /* if (!preg_match("/^(1\.[01]|2)/", protocolVersion)) {
            throw new DInvalidArgumentException("Unsupported protocol version `%s` provided.".format(version));
        } */
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    // newRequest.protocol = protocolVersion;

    return newRequest;
  }

  /**
     * Update the request with a new environment data element.
     *
     * Returns an updated request object. This method returns
     * a *new* request object and does not mutate the request in-place.
     */
  DServerRequest withEnviroment(DServerRequest request, string key, string value) {
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    /* newRequest._environmentData.set(key, aValue);
    newRequest.clearDetectorCache(); */

    return newRequest;
  }

  // Get a modified request with the provided header.
  DServerRequest withHeader(DServerRequest request, string headerName, string[] headerValue) {
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    /* auto normalizedName = normalizeHeaderName(headerName);
    result._environmentData[normalizedName] = headerValue; */
    return newRequest;
  }

  /**
     * Get a modified request with the provided header.
     *
     * Existing header values will be retained. The provided value
     * will be appended into the existing values.
     */
  DServerRequest withAddedHeader(DServerRequest request, string headerName, Json headerValue) {
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    /* string normalizedName = this.normalizeHeaderName(headerName);
    auto existing = null;
    if (newRequest._environmentData[normalizedName]!is null) {
      existing =  /* (array) * / newRequest._environmentData[normalizedName];
    }
    existing = array_merge(existing, /* (array) * / headerValue);
    newRequest._environmentData[normalizedName] = existing; */

    return newRequest;
  }

  // Get a modified request without a provided header.
  DServerRequest withoutHeader(DServerRequest request, string name) {
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    /* auto name = this.normalizeHeaderName(name);
    removeKey(newRequest._environmentData[name]); */

    return newRequest;
  }

  // Update the request replacing the files, and creating a new instance.
  DServerRequest withUploadedFiles(DServerRequest request, Json[string] uploadedFiles) {
    // this.validateUploadedFiles(uploadedFiles, "");
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    /* newRequest.uploadedFiles = uploadedFiles; */

    return newRequest;
  }

  /**
     * Replace the cookies in the request with those contained in
     * the provided CookieCollection.
     */
  DServerRequest withCookieCollection(DServerRequest request, DCookieCollection cookies) {
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    /*     Json[string] someValues = null;
    foreach (cookie; cookies) {
      someValues.set(cookie.name, cookie.value());
    }
    newRequest.cookies = someValues; */

    return newRequest;
  }

  /**
     * Update the request replacing the files, and creating a new instance.
     */
  /*    DServerRequest withUploadedFiles(DServerRequest request, Json[string] uploadedFiles) {
    // this.validateUploadedFiles(uploadedFiles, "");
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    // newRequest.uploadedFiles = uploadedFiles;

    return newRequest;
  } */
  /**
     * Update the request removing a data element.
     *
     * Returns an updated request object. This method returns
     * a *new* request object and does not mutate the request in-place.
     */
  DServerRequest withoutData(DServerRequest request, string aName) {
    DServerRequest newRequest = cast(DServerRequest) request.clone;

    /*     if (newRequest.data.isArray) {
      newRequest.data = Hash.removeKey(newRequest.data, name);
    } */
    return newRequest;
  }

  /**
     * Return an instance with the specified uri
     *
     * *Warning* Replacing the Uri will not update the `base`, `webroot`,
     * and `url` attributes.
     */
  DServerRequest withUri(DServerRequest request, IUri anUri, bool preserveHost = false) {
    DServerRequest newRequest = cast(DServerRequest) request.clone;
    /*     newRequest.uri = anUri;

    if (preserveHost && this.hasHeader("Host")) {
      return newRequest;
    }
    host = anUri.getHost();
    if (!host) {
      return newRequest;
    }
    port = anUri.getPort();
    if (port) {
      host ~= ": " ~ port;
    }
    newRequest._environmentData["HTTP_HOST"] = host;

 */
    return newRequest;
  }
}

DServerRequestFactory ServerRequestFactory() {
  return DServerRequestFactory.factory is null
    ? DServerRequestFactory.factory = new DServerRequestFactory : DServerRequestFactory.factory;
}
