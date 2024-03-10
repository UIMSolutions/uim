module uim.oop.plugins.plugin;

import uim.oop;

@safe:

/* * Plugin is used to load and locate plugins.
 *
 * It also can retrieve plugin paths and load their bootstrap and routes files.
 */
class Plugin {
    this() {
        initialize;
    }

  	bool initialize() {
		return true;
	}

    // List of valid hooks.
    const string[] VALID_HOOKS = ["bootstrap", "console", "middleware", "routes", "services"];

    // Holds a list of all loaded plugins and their configuration
    protected static PluginCollection plugins = null;

    // Returns the filesystem path for a plugin
    /* static string path(string pluginName) {
        auto plugin = getCollection().get(pluginName, null);

        return plugin.getPath();
    } 

    // Returns the filesystem path for plugin`s folder containing class files.
    static string classPath(string pluginName) { // pluginName in CamelCase format
        auto plugin = getCollection().get(pluginName);

        return plugin.getClassPath();
    }

    // Returns the filesystem path for plugin`s folder containing config files.
    static string configPath(string pluginName) {
        auto plugin = getCollection().get(pluginName);

        return plugin.getConfigPath();
    }
    */ 

    // Returns the filesystem path for plugin`s folder containing template files.
    // TODO 
    /* 
    static string templatePath(string pluginName) {
        auto plugin = getCollection().get(pluginName);

        return plugin.getTemplatePath();
    }

    // Returns true if the plugin is already loaded.
    static bool isLoaded(string pluginName) {
        return getCollection().has(pluginName);
    }

    // Return names of loaded plugins.
    static string[] loaded() {
        string[] names = 
            getCollection()
                .map!(plugin => plugin.name)
                .array
                .sort;

        return names;
    } */
    
    /**
     * Get the shared plugin collection.
     *
     * This method should generally not be used during application
     * runtime as plugins should be set during Application startup.
     * /
    static PluginCollection getCollection() {
        plugins = new PluginCollection();
        return plugins;
    }
}
