module uim.oop.tests.middlewaredispatcher;

import uim.oop;

@safe:

/**
 * Dispatches a request capturing the response for integration
 * testing purposes into the UIM\Http stack.
 *
 * @internal
 */
class DMiddlewareDispatcher {
    /* 
    // The application that is being dispatched.
    protected IHttpApplication _app;

    this(IHttpApplication testApp) {
        _app = testApp;
    }
    
    // Resolve the provided URL into a string.
    string resolveUrl(string[] urlToResolve) {
        // If we need to resolve a Route URL but there are no routes, load routes.
        if (isArray(urlToResolve) && count(Router.getRouteCollection().routes()) == 0) {
            return _resolveRoute(urlToResolve);
        }
        return Router.url(urlToResolve);
    }
    
    /**
     * Convert a URL array into a string URL via routing.
     * Params:
     * Json[string] urlToResolve The url to resolve
     * / 
    protected string resolveRoute(string[] urlToResolve) {
        // Simulate application bootstrap and route loading.
        // We need both to ensure plugins are loaded.
        this.app.bootstrap();
        if (cast(IPluginApplication)this.app) {
            this.app.pluginBootstrap();
        }
        builder = Router.createRouteBuilder("/");

        if (cast(IRoutingApplication)this.app) {
            this.app.routes(builder);
        }
        if (cast(IPluginApplication)this.app) {
            this.app.pluginRoutes(builder);
        }
         result = Router.url(urlToResolve);
        Router.resetRoutes();

        return result;
    }
    
    // Create a PSR7 request from the request spec.
    protected IServerRequest _createRequest(Json[string] spec) {
        if (spec.isSet("input")) {
            spec["post"] = null;
            spec["environment"]["uimUIM_INPUT"] = spec["input"];
        }
        environment = array_merge(
            chain(_SERVER, ["REQUEST_URI": spec["url"]]),
            spec["environment"]
        );
        if (environment["UIM_SELF"].has("Dunit")) {
            environment["UIM_SELF"] = "/";
        }
        request = ServerRequestFactory.fromGlobals(
            environment,
            spec["query"],
            spec["post"],
            spec["cookies"],
            spec["files"]
        );

        return request
            .withAttribute("session", spec["session"])
            .withAttribute("flash", new DFlashMessage(spec["session"]));
    }
    
    // Run a request and get the response.
    IResponse execute(Json[string] requestSpec) {
        auto newServer = new DServer(_app);

        return newServer.run(_createRequest(requestSpec));
    } */
}
