module uim.http.classes.servers.server;


import uim.http;

@safe:

/**
 * Runs an application invoking all the PSR7 middleware and the registered application.
 *
 * @implements \UIM\Event\IEventDispatcher<\UIM\Core\IHttpApplication>
 */
class DServer { // }: IEventDispatcher {
        mixin TConfigurable;
    mixin TEventDispatcher;

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


    protected IHttpApplication _app;

    protected DRunner _runner;

    this(IHttpApplication httpApp, Runner appRunner = null) {
        _app = httpApp;
        _runner = appRunner ?? new DRunner();
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

        request = request ?: ServerRequestFactory.fromGlobals();

        if (middlewareQueue.isNull) {
            if (cast(IContainerApplication)_app) {
                middlewareQueue = new DMiddlewareQueue([], _app.getContainer());
            } else {
                middlewareQueue = new DMiddlewareQueue();
            }
        }
        middleware = _app.middleware(middlewareQueue);
        if (cast(IPluginApplication)_app ) {
            middleware = _app.pluginMiddleware(middleware);
        }
        dispatchEvent("Server.buildMiddleware", ["middleware": middleware]);

        response = this.runner.run(middleware, request, _app);

        if (cast(ServerRequest)request instanceof ) {
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
        if (_app instanceof IPluginApplication) {
            _app.pluginBootstrap();
        }
    }
    
    // Emit the response using the D SAPI.
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
    void setEventManager(IEventManager eventManager) {
        if (cast(IEventDispatcher)_app) {
            _app.setEventManager(eventManager);

            return;
        }
        throw new DInvalidArgumentException("Cannot set the event manager, the application does not support events.");
    }
}
