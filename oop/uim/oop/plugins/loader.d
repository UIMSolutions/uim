module uim.oop.plugins.loader;

import uim.oop;

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
    protected string classNamePath = null;

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
    protected static DPluginCollection plugins = null;

    // Returns the filesystem path for a plugin
    static string path(string pluginName) {
        // TODO auto plugin = getCollection().get(pluginName, null);
        // return plugin.getPath();
        return null; 
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

    // Returns the filesystem path for plugin`s folder containing template files.
    static string templatePath(string pluginName) {
    // TODO 
        /* auto plugin = getCollection().get(pluginName);

        return plugin.getTemplatePath(); */
        return null; 
    }

    // Returns true if the plugin is already loaded.
    static bool isLoaded(string pluginName) {
        // TODO return getCollection().has(pluginName);
        return false; 
    }

    // Return names of loaded plugins.
    static string[] loaded() {
        string[] names = 
            getCollection()
                .map!(plugin => plugin.name)
                .array
                .sort;

        return names;
    }

    /**
     * Get the shared plugin collection.
     *
     * This method should generally not be used during application
     * runtime as plugins should be set during Application startup.
     * /
    static PluginCollection getCollection() {
        plugins = new DPluginCollection();
        return plugins;
    } */
}
