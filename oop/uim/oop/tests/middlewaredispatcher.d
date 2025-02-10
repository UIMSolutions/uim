/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
  // The application that is being dispatched.
  protected IHttpApplication _app;

  /* this(IHttpApplication testApp) {
        _app = testApp;
    }
    
    // Resolve the provided URL into a string.
    string resolveUrl(string[] url) {
        // If we need to resolve a Route URL but there are no routes, load routes.
        if (url.isArray && count(Router.getRouteCollection().routes()) == 0) {
            return _resolveRoute(url);
        }
        return Router.url(url);
    } */

  // Convert a URL array into a string URL via routing.
  protected string resolveRoute(string[] urlToResolve) {
    // Simulate application bootstrap and route loading.
    // We need both to ensure plugins are loaded.
    _app.bootstrap();
    // TODO 
    /* if (cast(IPluginApplication)_app) {
            _app.pluginBootstrap();
        } 
                
        auto builder = Router.createRouteBuilder("/");
        if (cast(IRoutingApplication)_app) {
            _app.routes(builder);
        }
        if (cast(IPluginApplication)_app) {
            _app.pluginRoutes(builder);
        }
        */

    string result;
    // TODO = Router.url(urlToResolve);
    // TODO Router.resetRoutes();

    return result;
  }

  // Create a PSR7 request from the request spec.
  // TODO
  /* 
    protected DServerRequest _createRequest(Json[string] requestSpec) {
        if (requestSpec.hasKey("input")) {
            requestSpec.set("post", null);
            requestSpec.set("environment.uimUIM_INPUT", requestSpec["input"]);
        }
        environment = array_merge(
            chain(_SERVER, ["REQUEST_URI": requestSpec.get("url")]),
            requestSpec["environment"]
       );
        if (environment["UIM_SELF"].contains("Dunit")) {
            environment.set("UIM_SELF", "/");
        }
        request = ServerRequestFactory.fromGlobals(
            environment,
            requestSpec.get("query"),
            requestSpec.get("post"),
            requestSpec.get("cookies"),
            requestSpec.get("files")
       );

        return request
            .withAttribute("session", requestSpec["session"])
            .withAttribute("flash", new DFlashMessage(requestSpec["session"]));
    } */

  // Run a request and get the response.
  /* IResponse execute(Json[string] requestSpec) {
        auto newServer = new DServer(_app);

        return newServer.run(_createRequest(requestSpec));
    } */
}
