module uim.uim.routings.middlewares.routing;

import uim.routings;

@safe:

/**
 * Applies routing rules to the request and creates the controller
 * instance if possible.
 */
class DRoutingMiddleware : IRoutingMiddleware {
    // Key used to store the route collection in the cache engine
    const string ROUTE_COLLECTION_CACHE_KEY = "routeCollection";

    // The application that will have its routing hook invoked.
    protected IRoutingApplication app;

    /**
     
     * Params:
     * \UIM\Routing\IRoutingApplication app The application instance that routes are defined on.
     */
    this(IRoutingApplication app) {
        this.app = app;
    }
    
    /**
     * Trigger the application"s and plugin"s routes() hook.
     */
    protected void loadRoutes() {
        builder = Router.createRouteBuilder("/");
        _app.routes(builder);
        if (cast(IPluginApplication)this.app) {
            _app.pluginRoutes(builder);
        }
    }
    
    /**
     * Apply routing and update the request.
     *
     * Any route/path specific middleware will be wrapped around next and then the new middleware stack will be
     * invoked.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request.
     * @param \Psr\Http\Server\IRequestHandler handler The request handler.
     */
    IResponse process(IServerRequest serverRequest, IRequestHandler handler) {
        this.loadRoutes();
        try {
            assert(cast(DServerRequest)serverRequest);
            Router.setRequest(serverRequest);
            params = (array)serverRequest.getAttribute("params", []);
            middleware = null;
            if (isEmpty(params["controller"])) {
                params = Router.parseRequest(serverRequest) + params;
                if (isSet(params["_middleware"])) {
                    middleware = params["_middleware"];
                }
                route = params["_route"];
                unset(params["_middleware"], params["_route"]);

                myserverRequest = serverRequest.withAttribute("route", route);
                myserverRequest = serverRequest.withAttribute("params", params);

                assert(cast(DServerRequest)myserverRequest);
                Router.setRequest(myserverRequest);
            }
        } catch (DRedirectException  anException) {
            return new DRedirectResponse(
                 anException.getMessage(),
                 anException.code(),
                 anException.getHeaders()
           );
        }
        matching = Router.getRouteCollection().getMiddleware(middleware);
        if (!matching) {
            return handler.handle(request);
        }
        container = cast(IContainerApplication)this.app
            ? _app.getContainer()
            : null;
        middleware = new DMiddlewareQueue(matching, container);
        runner = new DRunner();

        return runner.run(middleware, request, handler);
    }
}
