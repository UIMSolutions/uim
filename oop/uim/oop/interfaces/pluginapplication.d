/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.interfaces.pluginapplication; 

import uim.oop;

@safe:

/**
 * Interface for Applications that leverage plugins & events.
 *
 * Events can be bound to the application event manager during
 * the application`s bootstrap and plugin bootstrap.
 */
interface IPluginApplication /* : IEventDispatcher */ { // TODO
    /**
     * Add a plugin to the loaded plugin set.
     *
     * If the named plugin does not exist, or does not define a Plugin class, an
     * instance of `UIM\Core\BasePlugin` will be used. This generated class will have
     * all plugin hooks enabled.
     */
    void addPlugin(string pluginName, Json Data = null);
    // TODO void addPlugin(IPlugin plugin, Json Data = null);

    // Run bootstrap logic for loaded plugins.
    void pluginBootstrap();

    // Run routes hooks for loaded plugins
    // TODO RouteBuilder pluginRoutes(RouteBuilder routes);

    // Run middleware hooks for plugins
    // TODO MiddlewareQueue pluginMiddleware(MiddlewareQueue middlewareQueue);

    // Run console hooks for plugins
    // TODO CommandCollection pluginConsole(CommandCollection someCommands);
}
