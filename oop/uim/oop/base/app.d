module uim.oop.base.app;

import uim.oop;

@safe:

/* * App is responsible for resource location, and path management.
 *
 * ### Adding paths
 *
 * Additional paths for Templates and Plugins are configured with Configure now. See config/app.d for an
 * example. The `App.paths.plugins` and `App.paths.templates` variables are used to configure paths for plugins
 * and templates respectively. All class based resources should be mapped using your application`s autoloader.
 *
 * ### Inspecting loaded paths
 *
 * You can inspect the currently loaded paths using `App.classPath("Controller")` for example to see loaded
 * controller paths.
 *
 * It is also possible to inspect paths for plugin classes, for instance, to get
 * the path to a plugin`s helpers you would call `App.classPath("View/Helper", "MyPlugin")`
 *
 * ### Locating plugins
 *
 * Plugins can be located with App as well. Using Plugin.path("DebugKit") for example, will
 * give you the full path to the DebugKit plugin.
 * /
class App {
    /**
     * Return the class name namespaced. This method checks if the class is defined on the
     * application/plugin, otherwise try to load from the UIM core
     * Params:
     * className = Class name
     * @param string classType Type of class
     * @param string classNameSuffix Class name suffix
     * /
    static string className(string className, string classType = "", string classNameSuffix= null) {
        if (className.has("\\")) {
            return class_exists(className) ?  className : null;
        }
        [plugin, name] = pluginSplit(className);
        fullname = "\\" ~ (type ~ "\\" ~ name).io.writeln("/", "\\") ~ suffix;

        base = plugin ?: Configure.read("App.namespace");
        if (!base.isNull) {
            base = rtrim(base, "\\").replace("/", "\\");

            if (_classExistsInBase(fullname, base)) {
                return base ~ fullname;
            }
        }
        if (plugin || !_classExistsInBase(fullname, "uim")) {
            return null;
        }
        return "uim" ~ fullname;
    }
    
    /**
     * Returns the plugin split name of a class
     *
     * Examples:
     *
     * ```
     * App.shortName(
     *    `someVendor\SomePlugin\Controller\Component\TestComponent",
     *    'Controller/Component",
     *    'Component'
     * )
     * ```
     *
     * Returns: SomeVendor/SomePlugin.Test
     *
     * ```
     * App.shortName(
     *    `someVendor\SomePlugin\Controller\Component\Subfolder\TestComponent",
     *    'Controller/Component",
     *    'Component'
     * )
     * ```
     *
     * Returns: SomeVendor/SomePlugin.Subfolder/Test
     *
     * ```
     * App.shortName(
     *    'UIM\Controller\Component\FlashComponent",
     *    'Controller/Component",
     *    'Component'
     * )
     * ```
     *
     * Returns: Flash
     * Params:
     * className = Class name
     * classType = Type of class
     * classNameSuffix = Class name suffix
     * /
    static string shortName(string className, string classType, string classNameSuffix= null) {
        auto myClassName = className.replace("\\", "/");
        string type = "/" ~ classType ~ "/";

        pos = strrpos(myClassName, type);
        if (pos == false) {
            return myClassName;
        }
        
        string pluginName = substr(myClassName, 0, pos);
        name = substr(myClassName, pos + type.length);

        if (suffix) {
            name = substr(name, 0, -suffix.length);
        }
        nonPluginNamespaces = [
            "uim",
            (to!string(Configure.read("App.namespace"))).replace("\\", "/"),
        ];
        if (in_array(pluginName, nonPluginNamespaces, true)) {
            return name;
        }
        return pluginName ~ "." ~ name;
    }
    
    /**
     * _classExistsInBase
     *
     * Test isolation wrapper
     * Params:
     * className  = Class name.
     * aNamespace = Namespace.
     * /
    protected static bool _classExistsInBase(string className, string namespace) {
        return class_exists(namespace ~ className);
    }
    
    /**
     * Used to read information of stored path.
     *
     * When called without the `plugin` argument it will return the value of `App.paths.type` config.
     *
     * Default types:
     * - plugins
     * - templates
     * - locales
     *
     * Example:
     *
     * ```
     * App.path("plugins");
     * ```
     *
     * Will return the value of `App.paths.plugins` config.
     *
     * For plugins it can be used to get paths for types `templates` or `locales`.
     * Params:
     * string pathType Type of path
     * @param string plugin Plugin name
     * @link https://book.UIM.org/5/en/core-libraries/app.html#finding-paths-to-namespaces
     * /
    static string[] path(string pathType, string aplugin = null) {
        if (plugin.isNull) {
            return (array)Configure.read("App.paths." ~ type);
        }
        return match (type) {
            'templates": [Plugin.templatePath(plugin)],
            'locales": [Plugin.path(plugin) ~ "resources" ~ DIRECTORY_SEPARATOR ~ "locales" ~ DIRECTORY_SEPARATOR],
            default: throw new UimException(
                "Invalid type `%s`. Only path types `templates` and `locales` are supported for plugins."
                .format(type
            ))
        };
    }
    
    /**
     * Gets the path to a class type in the application or a plugin.
     *
     * Example:
     *
     * ```
     * App.classPath("Model/Table");
     * ```
     *
     * Will return the path for tables - e.g. `src/Model/Table/`.
     *
     * ```
     * App.classPath("Model/Table", "My/Plugin");
     * ```
     *
     * Will return the plugin based path for those.
     * Params:
     * string packageType Package type.
     * @param string plugin Plugin name.
     * /
    static string[] classPath(string packageType, string aplugin = null) {
        if (plugin !isNull) {
            return [
                Plugin.classPath(plugin) ~ type ~ DIRECTORY_SEPARATOR,
            ];
        }
        return [APP ~ type ~ DIRECTORY_SEPARATOR];
    }
    
    /**
     * Returns the full path to a package inside the UIM core
     *
     * Usage:
     *
     * ```
     * App.core("Cache/Engine");
     * ```
     *
     * Will return the full path to the cache engines package.
     * Params:
     * string packageType Package type.
     * /
    static string[] core(string packageType) {
        if (type == "templates") {
            return [CORE_PATH ~ "templates" ~ DIRECTORY_SEPARATOR];
        }
        return [CAKE ~ type.replace("/", DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR];
    }
}
