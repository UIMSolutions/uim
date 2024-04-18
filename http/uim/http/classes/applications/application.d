module uim.http.classes.applications.application;

import uim.http;

@safe:

/**
 * Base class for full-stack applications
 *
 * This class serves as a base class for applications that are using
 * UIM as a full stack framework. If you are only using the Http or Console libraries
 * you should implement the relevant interfaces directly.
 *
 * The application class is responsible for bootstrapping the application,
 * and ensuring that middleware is attached. It is also invoked as the last piece
 * of middleware, and delegates request/response handling to the correct controller.
 *
 * @template TSubject of \UIM\Http\BaseApplication
 * @implements \UIM\Event\IEventDispatcher<TSubject>
 * @implements \UIM\Core\IPluginApplication<TSubject>
 */
class DApplication {
    /*
    }:
    IConsoleApplication,
    IContainerApplication,
    IEventDispatcher,
    IHttpApplication,
    IPluginApplication,
    IRoutingApplication {
    /**
     * @use \UIM\Event\EventDispatcherTrait<TSubject>
     * /
    mixin TEventDispatcher();

    // Contains the path of the config directory
    protected string configDataDir;

    // Plugin Collection
    protected IPluginCollection plugins;

    /**
     * Controller factory
     *
     * @var \UIM\Http\IControllerFactory|null
     * /
    protected IControllerFactory controllerFactory = null;

    /**
     * Container
     *
     * @var \UIM\Core\IContainer|null
     * /
    protected IContainer container = null;

    /**
     * Constructor
     * Params:
     * string configDataDir The directory the bootstrap configuration is held in.
     * @param \UIM\Event\IEventManager|null eventManager Application event manager instance.
     * @param \UIM\Http\IControllerFactory|null controllerFactory Controller factory.
     * /
    this(
        string configDataDir,
        ?IEventManager eventManager = null,
        ?IControllerFactory controllerFactory = null
    ) {
        this.configDir = rtrim(configDataDir, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;
        this.plugins = Plugin.getCollection();
       _eventManager = eventManager ?: EventManager.instance();
        this.controllerFactory = controllerFactory;
    }
    
    /**
     * @param \UIM\Http\MiddlewareQueue middlewareQueue The middleware queue to set in your App Class
     * /
    abstract MiddlewareQueue middleware(MiddlewareQueue middlewareQueue);

 
    auto pluginMiddleware(MiddlewareQueue middleware): MiddlewareQueue
    {
        foreach (this.plugins.with("middleware") as plugin) {
            middleware = plugin.middleware(middleware);
        }
        return middleware;
    }
 
    void addPlugin(name, IData[string] configData = null) {
        plugin = isString(name)
            ? this.plugins.create(name, configData)
            : name;

        this.plugins.add(plugin);
    }
    
    /**
     * Add an optional plugin
     *
     * If it isn`t available, ignore it.
     * Params:
     * \UIM\Core\IPlugin|string aName The plugin name or plugin object.
     * @param IData[string] configData The configuration data for the plugin if using a string for name
     * /
    void addOptionalPlugin(IPlugin|string aName, IData[string] configData = null) {
        try {
            this.addPlugin(name, configData);
        } catch (MissingPluginException) {
            // Do not halt if the plugin is missing
        }
    }
    
    // Get the plugin collection in use.
    PluginCollection getPlugins() {
        return this.plugins;
    }
 
    void bootstrap() {
        require_once this.configDir ~ "bootstrap.d";

        // Dcs:ignore
        plugins = @include this.configDir ~ "plugins.d";
        if (isArray(plugins)) {
            this.plugins.addFromConfig(plugins);
        }
    }
 
    void pluginBootstrap() {
        this.plugins.with("bootstrap").each!(plugin => plugin.bootstrap(this));
    }
    
    /**

     * By default, this will load `config/routes.d` for ease of use and backwards compatibility.
     * Params:
     * \UIM\Routing\RouteBuilder routes A route builder to add routes into.
     * /
    void routes(RouteBuilder routes) {
        // Only load routes if the router is empty
        if (!Router.routes()) {
            result = require this.configDir ~ "routes.d";
            if (cast(DClosure)result) {
                result(routes);
            }
        }
    }
 
    auto pluginRoutes(RouteBuilder routes): RouteBuilder
    {
        foreach (this.plugins.with("routes") as plugin) {
            plugin.routes(routes);
        }
        return routes;
    }
    
    /**
     * Define the console commands for an application.
     *
     * By default, all commands in UIM, plugins and the application will be
     * loaded using conventions based names.
     * Params:
     * \UIM\Console\CommandCollection commands The CommandCollection to add commands into.
     * /
    CommandCollection console(CommandCollection commands) {
        return commands.addMany(commands.autoDiscover());
    }
 
    auto pluginConsole(CommandCollection commands): CommandCollection
    {
        foreach (this.plugins.with("console") as plugin) {
            commands = plugin.console(commands);
        }
        return commands;
    }
    
    /**
     * Get the dependency injection container for the application.
     *
     * The first time the container is fetched it will be constructed
     * and stored for future calls.
     * /
    IContainer getContainer() {
        return this.container ??= this.buildContainer();
    }
    
    /**
     * Build the service container
     *
     * Override this method if you need to use a custom container or
     * want to change how the container is built.
     * /
    protected IContainer buildContainer() {
        container = new DContainer();
        this.services(container);
        this.plugins.with("services")
            .each!(plugin => plugin.services(container));

        event = this.dispatchEvent("Application.buildContainer", ["container": container]);
        if (cast(IContainer)event.getResult()) {
            return event.getResult();
        }
        return container;
    }
    
    /**
     * Register application container services.
     * Params:
     * \UIM\Core\IContainer container The Container to update.
     * /
    void services(IContainer container) {
    }
    
    /**
     * Invoke the application.
     *
     * - Add the request to the container, enabling its injection into other services.
     * - Create the controller that will handle this request.
     * - Invoke the controller.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request
     * /
    IResponse handle(
        IServerRequest serverRequest
    ) {
        container = this.getContainer();
        container.add(ServerRequest.classname, request);
        container.add(IContainer.classname, container);

        this.controllerFactory ??= new DControllerFactory(container);

        if (Router.getRequest() != request) {
            assert(cast(DServerRequest)request);
            Router.setRequest(request);
        }
        controller = this.controllerFactory.create(request);

        return this.controllerFactory.invoke(controller);
    } */
}
