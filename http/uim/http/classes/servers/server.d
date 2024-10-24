/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.servers.server;

import uim.http;

@safe:

/**
 * Runs an application invoking all the PSR7 middleware and the registered application.
 *
 * @implements \UIM\Event\IEventDispatcher<\UIM\Core\IHttpApplication>
 */
class DServer : UIMObject { // }: IEventDispatcher {
    mixin TEventDispatcher;

    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    // Hook method
    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false; 
        }

        return true;
    }

    protected IHttpApplication _app;

    protected DRunner _runner;

    this(IHttpApplication httpApp, Runner appRunner = null) {
        _app = httpApp;
        _runner = appRunner ? appRunner : new DRunner();
    }
    
    /**
     * Run the request/response through the Application and its middleware.
     *
     * This will invoke the following methods:
     *
     * - App.bootstrap() - Perform any bootstrapping logic for your application here.
     * - App.middleware() - Attach any application middleware here.
     * - Trigger the `server.buildMiddleware' event. You can use this to modify the
     * from event listeners.
     * - Run the middleware queue including the application.
     */
    IResponse run(
        IServerRequest serverRequest = null,
        MiddlewareQueue middlewareQueue = null
   ) {
        bootstrap();

        request = request ? request : ServerRequestFactory.fromGlobals();

        if (middlewareQueue.isNull) {
            if (cast(IContainerApplication)_app) {
                middlewareQueue = new DMiddlewareQueue([], _app.getContainer());
            } else {
                middlewareQueue = new DMiddlewareQueue();
            }
        }
        
        auto middleware = _app.middleware(middlewareQueue);
        if (cast(IPluginApplication)_app) {
            middleware = _app.pluginMiddleware(middleware);
        }
        dispatchEvent("Server.buildMiddleware", ["middleware": middleware]);

        response = this.runner.run(middleware, request, _app);

        if (cast(ServerRequest)request ) {
            request.getSession().close();
        }
        return response;
    }
    
    /**
     * Application bootstrap wrapper.
     *
     * Calls the application`s `bootstrap()` hook. After the application the
     * plugins are bootstrapped.
     */
    protected void bootstrap() {
        _app.bootstrap();
        if (cast(IPluginApplication)_app) {
            _app.pluginBootstrap();
        }
    }
    
    // Emit the response using the UIM SAPI.
    void emit(IResponse responseToEmit, ResponseEmitter emitterToUse = null) {
        if (!emitterToUse) {
            emitterToUse = new DResponseEmitter();
        }
        emitterToUse.emit(responseToEmit);
    }
    
    // Get the current application.
    IHttpApplication getApp() {
        return _app;
    }
    
    // Get the application`s event manager or the global one.
    IEventManager getEventManager() {
        return cast(IEventDispatcher)_app
            ? _app.getEventManager()
            : EventManager.instance();
    }
    
    /**
     * Set the application`s event manager.
     *
     * If the application does not support events, an exception will be raised.
     */
    void eventManager(IEventManager eventManager) {
        if (cast(IEventDispatcher)_app) {
            _app.eventManager(eventManager);
            return;
        }
        throw new DInvalidArgumentException("Cannot set the event manager, the application does not support events.");
    }
}
