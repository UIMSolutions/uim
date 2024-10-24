/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.middlewares.routing;

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
    protected IRoutingApplication _app;

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
     * Any route/path specific middleware will be wrapped around next and then the new middleware stack will be invoked.
     */
    IResponse process(IServerRequest serverRequest, IRequestHandler requestHandler) {
        this.loadRoutes();
        try {
            assert(cast(DServerRequest)serverRequest);
            Router.setRequest(serverRequest);
            auto params = /* (array) */serverRequest.getAttribute("params", []);
            auto middleware = null;
            if (params.isEmpty("controller")) {
                params = Router.parseRequest(serverRequest) + params;
                if (params.hasKey("_middleware")) {
                    middleware = params["_middleware"];
                }
                route = params["_route"];
                removeKey(params["_middleware"], params["_route"]);

                myserverRequest = serverRequest.withAttribute("route", route);
                myserverRequest = serverRequest.withAttribute("params", params);

                assert(cast(DServerRequest)myserverRequest);
                Router.setRequest(myserverRequest);
            }
        } catch (DRedirectException  anException) {
            return new DRedirectResponse(
                 anException.message(),
                 anException.code(),
                 anException.getHeaders()
           );
        }
        auto matching = Router.getRouteCollection().getMiddleware(middleware);
        if (!matching) {
            return requestHandler.handle(request);
        }
        auto container = cast(IContainerApplication)this.app
            ? _app.getContainer()
            : null;
        auto middleware = new DMiddlewareQueue(matching, container);
        auto runner = new DRunner();

        return runner.run(middleware, request, requestHandler);
    }
}
