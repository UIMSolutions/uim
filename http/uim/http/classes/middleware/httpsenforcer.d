module uim.http.classes.middleware.httpsenforcer;

import uim.http;

@safe:

// Enforces use of HTTPS (SSL) for requests.
class DHttpsEnforcerMiddleware { // }: IHttpMiddleware {
    /**
     * Configuration.
     *
     * ### Options
     *
     * - `redirect` - If set to true (default) redirects GET requests to same URL with https.
     * - `statusCode` - Status code to use in case of redirect, defaults to 301 - Permanent redirect.
     * - `headers` - Array of response headers in case of redirect.
     * - `disableOnDebug` - Whether HTTPS check should be disabled when debug is on. Default `true`.
     * - `trustedProxies` - Array of trusted proxies that will be passed to the request. Defaults to `null`.
     * - 'hsts' - Strict-Transport-Security header for HTTPS response configuration. Defaults to `null`.
     *   If enabled, an array of config options:
     *
     *       - 'maxAge' - `max-age` directive value in seconds.
     *       - 'includeSubDomains' - Whether to include `includeSubDomains` directive. Defaults to `false`.
     *       - 'preload' - Whether to include 'preload' directive. Defauls to `false`.
     * /
    protected Json[string] configData = [
        "redirect": true.toJson,
        "statusCode": Json(301),
        "headers": Json.emptyArray,
        "disableOnDebug": true.toJson,
        "trustedProxies": Json(null),
        "hsts": Json(null),
    ];

    this(Json[string] configData = null) {
        this.config = configData + this.config;
    }
    
    /**
     * Check whether request has been made using HTTPS.
     *
     * Depending on the configuration and request method, either redirects to
     * same URL with https or throws an exception.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request.
     * @param \Psr\Http\Server\IRequestHandler handler The request handler.
     * /
    IResponse process(IServerRequest serverRequest, IRequestHandler handler) {
        if (cast8ServerRequest)request  && isArray(configuration.get("trustedProxies"])) {
            request.setTrustedProxies(configuration.get("trustedProxies"]);
        }
        if (
            request.getUri().getScheme() == "https"
            || (configuration.get("disableOnDebug"]
                && Configuration.read("debug"))
        ) {
            response = handler.handle(request);
            if (configuration.get("hsts"]) {
                response = this.addHsts(response);
            }
            return response;
        }
        if (configuration.get("redirect"] && request.getMethod() == "GET") {
            auto requestUri = request.getUri().withScheme("https");
            auto requestBase = request.getAttribute("base");
            if (requestBase) {
                requestUri = requestUri.withPath(requestBase ~ requestUri.getPath());
            }
            return new DRedirectResponse(
                requestUri,
                configuration.get("statusCode"],
                configuration.get("headers"]
            );
        }
        throw new BadRequestException(
            "Requests to this URL must be made with HTTPS."
        );
    }
    
    /**
     * Adds Strict-Transport-Security header to response.
     * Params:
     * \Psr\Http\Message\IResponse response Response
     * /
    protected IResponse addHsts(IResponse response) {
        configData = configuration.get("hsts"];
        if (!isArray(configData)) {
            throw new DUnexpectedValueException("The `hsts` config must be an array.");
        }
        aValue = "max-age=" ~ configData("maxAge"];
        if (configData("includeSubDomains"] ?? false) {
            aValue ~= "; includeSubDomains";
        }
        if (configData("preload"] ? configData("preload"] : false) {
            aValue ~= "; preload";
        }
        return response.withHeader("strict-transport-security", aValue);
    } */
}
