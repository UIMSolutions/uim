module uim.http.classes.servers.server;


import uim.http;

@safe:

/**
 * Runs an application invoking all the PSR7 middleware and the registered application.
 *
 * @implements \UIM\Event\IEventDispatcher<\UIM\Core\IHttpApplication>
 */
class DServer { // }: IEventDispatcher {
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
     * @use \UIM\Event\EventDispatcherTrait<\UIM\Core\IHttpApplication>
     * /
    use EventDispatcherTrait;

    protected IHttpApplication _app;

    protected Runner _runner;

    /**
     * Constructor
     * Params:
     * \UIM\Core\IHttpApplication app The application to use.
     * @param \UIM\Http\Runner|null runner Application runner.
     * /
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
     *  from event listeners.
     * - Run the middleware queue including the application.
     * Params:
     * \Psr\Http\Message\IServerRequest|null request The request to use or null.
     * @param \UIM\Http\MiddlewareQueue|null middlewareQueue MiddlewareQueue or null.
     * /
    IResponse run(
        ?IServerRequest serverRequest = null,
        ?MiddlewareQueue middlewareQueue = null
    ) {
        this.bootstrap();

        request = request ?: ServerRequestFactory.fromGlobals();

        if (middlewareQueue.isNull) {
            if (cast(IContainerApplication)this.app) {
                middlewareQueue = new MiddlewareQueue([], this.app.getContainer());
            } else {
                middlewareQueue = new MiddlewareQueue();
            }
        }
        middleware = this.app.middleware(middlewareQueue);
        if (cast(IPluginApplication)this.app ) {
            middleware = this.app.pluginMiddleware(middleware);
        }
        this.dispatchEvent("Server.buildMiddleware", ["middleware": middleware]);

        response = this.runner.run(middleware, request, this.app);

        if (request instanceof ServerRequest) {
            request.getSession().close();
        }
        return response;
    }
    
    /**
     * Application bootstrap wrapper.
     *
     * Calls the application`s `bootstrap()` hook. After the application the
     * plugins are bootstrapped.
     * /
    protected void bootstrap() {
        this.app.bootstrap();
        if (this.app instanceof IPluginApplication) {
            this.app.pluginBootstrap();
        }
    }
    
    /**
     * Emit the response using the PHP SAPI.
     * Params:
     * \Psr\Http\Message\IResponse response The response to emit
     * @param \UIM\Http\ResponseEmitter|null emitter The emitter to use.
     *  When null, a SAPI Stream Emitter will be used.
     * /
    void emit(IResponse response, ?ResponseEmitter emitter = null) {
        if (!emitter) {
            emitter = new DResponseEmitter();
        }
        emitter.emit(response);
    }
    
    /**
     * Get the current application.
     * /
    IHttpApplication getApp() {
        return this.app;
    }
    
    // Get the application`s event manager or the global one.
    IEventManager getEventManager() {
        if (cast(IEventDispatcher)this.app) {
            return this.app.getEventManager();
        }
        return EventManager.instance();
    }
    
    /**
     * Set the application`s event manager.
     *
     * If the application does not support events, an exception will be raised.
     * Params:
     * \UIM\Event\IEventManager eventManager The event manager to set.
     * /
    void setEventManager(IEventManager eventManager) {
        if (this.app instanceof IEventDispatcher) {
            this.app.setEventManager(eventManager);

            return;
        }
        throw new DInvalidArgumentException("Cannot set the event manager, the application does not support events.");
    } */
}
