/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.plugins.loader;

import uim.routings;

@safe:

// Plugin is used to load and locate plugins.
class DPluginLoader {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    // The path to this plugin.
    protected string _path = null;

    // The class path for this plugin.
    protected string classnamePath = null;

    // The config path for this plugin.
    protected string configDataPath = null;

    // The templates path for this plugin.
    protected string atemplatePath = null;

    // The name of this plugin
    mixin(TProperty!("string", "name"));

    // List of valid hooks.
    const string[] VALID_HOOKS = [
        "bootstrap", "console", "middleware", "routes", "services"
    ];

    // Holds a list of all loaded plugins and their configuration
    protected static DPluginCollection _plugins = null;

    // Returns the filesystem path for a plugin
    static string path(string pluginName) {
        // TODO auto plugin = pluginCollection().get(pluginName, null);
        // return plugin.path();
        return null; 
    } 

    // Returns the filesystem path for plugin`s folder containing class files.
    static string classPath(string pluginName) { // pluginName in CamelCase format
        auto plugin = pluginCollection().get(pluginName);

        return plugin.getClassPath();
    }

    // Returns the filesystem path for plugin`s folder containing config files.
    static string configPath(string pluginName) {
        auto plugin = pluginCollection().get(pluginName);

        return plugin.configPath();
    }

    // Returns the filesystem path for plugin`s folder containing template files.
    static string templatePath(string pluginName) {
    // TODO 
        /* auto plugin = pluginCollection().get(pluginName);

        return plugin.getTemplatePath(); */
        return null; 
    }

    // Returns true if the plugin is already loaded.
    static bool isLoaded(string pluginName) {
        return pluginCollection().has(pluginName);
        return false; 
    }

    // Return names of loaded plugins.
    static string[] loaded() {
        string[] names = 
            pluginCollection()
                .map!(plugin => plugin.name)
                .array
                .sort;

        return names;
    }

    // Get the shared plugin collection.
    static DPluginCollection pluginCollection() {
        auto plugins = new DPluginCollection();
        return plugins;
    }
}
