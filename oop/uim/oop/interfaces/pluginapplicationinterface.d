module uim.cake.core;

import uim.cake;

@safe:

/**
 * Interface for Applications that leverage plugins & events.
 *
 * Events can be bound to the application event manager during
 * the application`s bootstrap and plugin bootstrap.
 *
 * @template TSubject
 * @extends \UIM\Event\IEventDispatcher<\UIM\Http\BaseApplication>
 */
interface IPluginApplication : IEventDispatcher {
    /**
     * Add a plugin to the loaded plugin set.
     *
     * If the named plugin does not exist, or does not define a Plugin class, an
     * instance of `UIM\Core\BasePlugin` will be used. This generated class will have
     * all plugin hooks enabled.
     * Params:
     * \UIM\Core\IPlugin|string aName The plugin name or plugin object.
     * configData - The configuration data for the plugin if using a string for name
     */
    auto addPlugin(IPlugin|string aName, IConfigData[string] configData = null);

    // Run bootstrap logic for loaded plugins.
    void pluginBootstrap();

    /**
     * Run routes hooks for loaded plugins
     * Params:
     * \UIM\Routing\RouteBuilder routes The route builder to use.
     */
    RouteBuilder pluginRoutes(RouteBuilder routes);

    /**
     * Run middleware hooks for plugins
     * Params:
     * \UIM\Http\MiddlewareQueue middleware The MiddlewareQueue to use.
     */
    MiddlewareQueue pluginMiddleware(MiddlewareQueue aMiddleware);

    // Run console hooks for plugins
    CommandCollection pluginConsole(CommandCollection someCommands);
}
