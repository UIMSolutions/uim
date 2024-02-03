module oop.uim.oop.interfaces.pluginapplication;

import uim.oop;

@safe:

/**
 * Interface for Applications that leverage plugins & events.
 *
 * Events can be bound to the application event manager during
 * the application`s bootstrap and plugin bootstrap.
 *
 * @extends \UIM\Event\IEventDispatcher<\UIM\Http\BaseApplication>
 */
interface IPluginApplication : IEventDispatcher {
    /**
     * Add a plugin to the loaded plugin set.
     *
     * If the named plugin does not exist, or does not define a Plugin class, an
     * instance of `UIM\Core\BasePlugin` will be used. This generated class will have
     * all plugin hooks enabled.
     */
    auto addPlugin(string pluginName, IData[string] configData = null);
    auto addPlugin(IPlugin plugin, IData[string] configData = null);

    // Run bootstrap logic for loaded plugins.
    void pluginBootstrap();

    // Run routes hooks for loaded plugins
    RouteBuilder pluginRoutes(RouteBuilder routes);

    // Run middleware hooks for plugins
    MiddlewareQueue pluginMiddleware(MiddlewareQueue middlewareQueue);

    // Run console hooks for plugins
    CommandCollection pluginConsole(CommandCollection someCommands);
}
