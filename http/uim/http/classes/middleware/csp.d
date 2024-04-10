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
class DCspMiddleware { // }: IMiddleware {
    mixin TConfigurable!();
    
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

        return true;
    }

    mixin(TProperty!("string", "name"));

    /**
     * CSP Builder
     *
     * @var \ParagonIE\CSPBuilder\CSPBuilder csp CSP Builder or config array
     * /
    protected ICSPBuilder csp;

    // Configuration options.
    configuration.updateDefaults([
        "scriptNonce": BooleanData(false),
        "styleNonce": BooleanData(false),
    ];

    /**
     * Constructor
     * Params:
     * \ParagonIE\CSPBuilder\CSPBuilder|array csp CSP object or config array
     * @param IData[string] configData Configuration options.
     * /
    this(ICSPBuilder|array csp, IData[string] configData = null) {
        if (!class_exists(CSPBuilder.classname)) {
            throw new UimException("You must install paragonie/csp-builder to use CspMiddleware");
        }
        this.setConfig(configData);

        if (!cast(DCSPBuilder)csp) {
            csp = new DCSPBuilder(csp);
        }
        this.csp = csp;
    }
    
    /**
     * Add nonces (if enabled) to the request and apply the CSP header to the response.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request.
     * @param \Psr\Http\Server\IRequestHandler handler The request handler.
     * /
    IResponse process(IServerRequest serverRequest, IRequestHandler handler) {
        if (_configData.isSet("scriptNonce")) {
            request = request.withAttribute("cspScriptNonce", this.csp.nonce("script-src"));
        }
        if (this.getconfig("styleNonce")) {
            request = request.withAttribute("cspStyleNonce", this.csp.nonce("style-src"));
        }
        response = handler.handle(request);

        /** @var \Psr\Http\Message\IResponse * /
        return this.csp.injectCSPHeader(response);
    } */
}
