/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.apps.classes.application;

import uim.apps;

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
class DApplication : UIMObject {
    /*
    }:
    IConsoleApplication,
    IContainerApplication,
    IEventDispatcher,
    IHttpApplication,
    IPluginApplication,
    IRoutingApplication {
     */
    // mixin TEventDispatcher;

    // Contains the path of the config directory
    /* protected string configDataDir;

    // Plugin Collection
    protected DPluginCollection _plugins;

    protected DControllerFactory _controllerFactory = null;

    // Container
    protected IContainer container = null;

    /* this(
        string configDataDir,
        IEventManager eventManager = null,
        DControllerFactory controllerFactory = null
   ) {
        _configDir = stripRight(configDataDir, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;
        _plugins = Plugin.getCollection();
       _eventManager = eventManager ? eventManager: EventManager.instance();
        _controllerFactory = controllerFactory;
    } */

    /* abstract DMiddlewareQueue middleware(DMiddlewareQueue DMiddlewareQueue);

    DMiddlewareQueue pluginMiddleware(DMiddlewareQueue middleware) {
        /* foreach (plugin; _plugins.with("middleware")) {
            middleware = plugin.middleware(middleware);
        } * /
        return middleware;
    }

    void addPlugin(string name, Json[string] configData = null) {
        auto plugin = isString(name)
            ? _plugins.create(name, configData) : name;

        _plugins.add(plugin);
    }

    /**
     * Add an optional plugin
     * If it isn`t available, ignore it.
     * /
    void addOptionalPlugin( /* IPlugin| * / string pluginName, Json[string] pluginData = null) {
        try {
            this.addPlugin(pluginName, pluginData);
        } catch (MissingPluginException) {
            // Do not halt if the plugin is missing
        }
    }

    // Get the plugin collection in use.
    DPluginCollection getPlugins() {
        return _plugins;
    }

    void bootstrap() {
        // require_once _configDir ~ "bootstrap.d";

        // Dcs:ignore
        /* plugins = @include _configDir ~ "plugins.d";
        if (plugins.isArray) {
            _plugins.addFromConfig(plugins);
        } * /
    }

    void pluginBootstrap() {
        // _plugins.with("bootstrap").each!(plugin => plugin.bootstrap(this));
    }

    // By default, this will load `config/routes.d` for ease of use and backwards compatibility.
    void routes(DRouteBuilder routes) {
        // Only load routes if the router is empty
        /* if (!Router.routes()) {
            result = require _configDir ~ "routes.d";
        } * /
    }

    DRouteBuilder pluginRoutes(DRouteBuilder routes) {
        // _plugins.with("routes").each!(plugin => plugin.routes(routes));
        return routes;
    }

    /**
     * Define the console commands for an application.
     *
     * By default, all commands in UIM, plugins and the application will be
     * loaded using conventions based names.
     * /
    DCommandCollection console(DCommandCollection commandsToAdd) {
        return commands.addMany(commandsToAdd.autoDiscover());
    }

    auto DCommandCollection pluginConsole(DCommandCollection commands) {
        // _plugins.with("console".each!(plugin => commands = plugin.console(commands));
        return commands;
    }

    /**
     * Get the dependency injection container for the application.
     *
     * The first time the container is fetched it will be constructed
     * and stored for future calls.
     * /
    IContainer getContainer() {
        if (_container.isNull) {
            _container = this.buildContainer();
        }
        return _container;
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
        /* _plugins.with("services")
            .each!(plugin => plugin.services(container)); * /

        event = dispatchEvent("Application.buildContainer", [
                "container": container
            ]);
        if (cast(IContainer) event.getResult()) {
            return event.getResult();
        }
        return container;
    }

    // Register application container services.
    void services(IContainer container) {
    }

    /**
     * Invoke the application.
     *
     * - Add the request to the container, enabling its injection into other services.
     * - Create the controller that will handle this request.
     * - Invoke the controller.
     * /
    IResponse handle(
        IServerRequest serverRequest
    ) {
        auto container = getContainer();
        container.add(IServerRequest.classname, request);
        container.add(IContainer.classname, container);

        /*  _controllerFactory ??= new DControllerFactory(container);

        if (Router.getRequest() != request) {
            assert(cast(DServerRequest)request);
            Router.setRequest(request);
        }
        controller = _controllerFactory.create(request); * /

        // return _controllerFactory.invoke(controller);
        return null;
    } */
}
