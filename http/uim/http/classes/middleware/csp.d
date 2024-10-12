/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
class DCspMiddleware : DMiddleware { // }: IHttpMiddleware {
    mixin(MiddlewareThis!("Csp"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .setDefault("scriptNonce", false)
            .setDefault("styleNonce", false);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // CSP Builder
    protected ICSPBuilder csp;

    this(/* ICSPBuilder| */Json[string] cspObject, Json[string] configData = null) {
        if (!class_hasKey(CSPBuilder.classname)) {
            throw new UIMException("You must install paragonie/csp-builder to use CspMiddleware");
        }
        configuration.set(configData);

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
