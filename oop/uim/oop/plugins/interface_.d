module uim.oop.plugins.interface_;

import uim.oop;

@safe:

// Plugin Interface
interface IPlugin : INamed {
    // Get the filesystem path to this plugin
    string getPath();

    /* 
    // Get the filesystem path to configuration for this plugin
    string getConfigPath();

    // Get the filesystem path to configuration for this plugin
    string getClassPath();

    // Get the filesystem path to templates for this plugin
    string getTemplatePath();

    /**
     * Load all the application configuration and bootstrap logic.
     *
     * The default implementation of this method will include the `config/bootstrap.d` in the plugin if it exist. You
     * can override this method to replace that behavior.
     *
     * The host application is provided as an argument. This allows you to load additional
     * plugin dependencies, or attach events.
     * Params:
     * \UIM\Core\IPluginApplication app The host application
     * /
    void bootstrap(IPluginApplication app);

    // Add console commands for the plugin.
    // TODO CommandCollection console(CommandCollection commandsToUpdate);

    // Add middleware for the plugin.
    // TODOMiddlewareQueue middleware(MiddlewareQueue middlewareQueue);

    /**
     * Add routes for the plugin.
     *
     * The default implementation of this method will include the `config/routes.d` in the plugin if it exists. You
     * can override this method to replace that behavior.
     * /
    // TODO void routes(RouteBuilder routes);

    // Register plugin services to the application`s container
    void services(IContainer container);

    // Disables the named hook
    void disable(string hookName);

    // Enables the named hook
    void enable(string hookName);

    // Check if the named hook is enabled
    bool isEnabled(string hookName);
    */
}
