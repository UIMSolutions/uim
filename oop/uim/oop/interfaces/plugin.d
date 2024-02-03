module oop.uim.oop.interfaces.plugin;

import uim.cake;

@safe:

// Plugin Interface
interface IPlugin {
    // List of valid hooks.
    const string[] VALID_HOOKS = ["bootstrap", "console", "middleware", "routes", "services"];

    // Get the name of this plugin.
    string name();

    // Get the filesystem path to this plugin
    string getPath();

    /**
     * Get the filesystem path to configuration for this plugin
     */
    string getConfigPath();

    /**
     * Get the filesystem path to configuration for this plugin
     */
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
     */
    void bootstrap(IPluginApplication app);

    // Add console commands for the plugin.
    CommandCollection console(CommandCollection commandsToUpdate);

    /**U
     * Add middleware for the plugin.
     * Params:
     * \UIM\Http\MiddlewareQueue middlewareQueue The middleware queue to update.
     */
    MiddlewareQueue middleware(MiddlewareQueue middlewareQueue);

    /**
     * Add routes for the plugin.
     *
     * The default implementation of this method will include the `config/routes.d` in the plugin if it exists. You
     * can override this method to replace that behavior.
     * Params:
     * \UIM\Routing\RouteBuilder routes The route builder to update.
     */
    void routes(RouteBuilder routes);

    /**
     * Register plugin services to the application`s container
     * Params:
     * \UIM\Core\IContainer container Container instance.
     */
    void services(IContainer container);

    /**
     * Disables the named hook
     * Params:
     * string ahook The hook to disable
     */
    auto disable(string hookName);

    /**
     * Enables the named hook
     * Params:
     * string ahook The hook to disable
     */
    auto enable(string hookName);

    /**
     * Check if the named hook is enabled
     * Params:
     * string ahook The hook to check
     */
    bool isEnabled(string hookName);
}
