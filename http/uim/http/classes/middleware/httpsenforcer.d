module uim.http.classes.middleware.httpsenforcer;

import uim.http;

@safe:

// Enforces use of HTTPS (SSL) for requests.
class HttpsEnforcerMiddleware { // }: IMiddleware {
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
    protected IData[string] configData = [
        "redirect": IData(true),
        "statusCode": IData(301),
        "headers": IData.emptyArray,
        "disableOnDebug": IData(true),
        "trustedProxies": IData(null),
        "hsts": IData(null),
    ];

    /**
     * Constructor
     * Params:
     * @see \UIM\Http\Middleware\HttpsEnforcerMiddleware.configData
     * /
    this(IData[string] configData = null) {
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
        if (cast8ServerRequest)request  && isArray(configuration["trustedProxies"])) {
            request.setTrustedProxies(configuration["trustedProxies"]);
        }
        if (
            request.getUri().getScheme() == "https"
            || (configuration["disableOnDebug"]
                && Configure.read("debug"))
        ) {
            response = handler.handle(request);
            if (configuration["hsts"]) {
                response = this.addHsts(response);
            }
            return response;
        }
        if (configuration["redirect"] && request.getMethod() == "GET") {
            auto requestUri = request.getUri().withScheme("https");
            auto requestBase = request.getAttribute("base");
            if (requestBase) {
                requestUri = requestUri.withPath(requestBase ~ requestUri.getPath());
            }
            return new RedirectResponse(
                requestUri,
                configuration["statusCode"],
                configuration["headers"]
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
        configData = configuration["hsts"];
        if (!isArray(configData)) {
            throw new UnexpectedValueException("The `hsts` config must be an array.");
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
