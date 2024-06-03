module uim.http.classes.middleware.csp;

import uim.http;

@safe:
/**
 * Content Security Policy Middleware
 *
 * ### Options
 *
 * - `scriptNonce` Enable to have a nonce policy added to the script-src directive.
 * - `styleNonce` Enable to have a nonce policy added to the style-src directive.
 */
class DCspMiddleware { // }: IHttpMiddleware {
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

        return true;
    }

    mixin(TProperty!("string", "name"));

    /**
     * CSP Builder
     *
     * @var \ParagonIE\CSPBuilder\CSPBuilder csp CSP Builder or config array
     */
    protected ICSPBuilder csp;

    // Configuration options.
    configuration.updateDefaults([
        "scriptNonce": false.toJson,
        "styleNonce": false.toJson,
    ];

    /**
     
     * Params:
     * \ParagonIE\CSPBuilder\CSPBuilder|array csp CSP object or config array
     */
    this(ICSPBuilder|Json[string] cspObject, Json[string] configData = null) {
        if (!class_exists(CSPBuilder.classname)) {
            throw new DException("You must install paragonie/csp-builder to use CspMiddleware");
        }
        configuration.update(configData);

        if (!cast(DCSPBuilder)cspObject) {
            cspObject = new DCSPBuilder(cspObject);
        }
        _cspObject = cspObject;
    }
    
    // Add nonces (if enabled) to the request and apply the CSP header to the response.
    IResponse process(IServerRequest serverRequest, IRequestHandler requestHandler) {
        if (_configData.hasKey("scriptNonce")) {
            serverRequest = serverRequest.withAttribute("cspScriptNonce", this.csp.nonce("script-src"));
        }
        if (getconfig("styleNonce")) {
            serverRequest = serverRequest.withAttribute("cspStyleNonce", this.csp.nonce("style-src"));
        }
        
        auto response = requestHandler.handle(serverRequest);
        return _csp.injectCSPHeader(response);
    }
}
