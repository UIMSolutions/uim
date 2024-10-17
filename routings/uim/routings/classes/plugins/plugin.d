/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.plugins.plugin;

import uim.oop;

@safe:

/**
 * Plugin Class
 * Every plugin should extend from this class or implement the interfaces and
 * include a plugin class in its src root folder.
 */
class DPlugin : IPlugin {
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

    // Do bootstrapping or not
    protected bool bootstrapEnabled = true;

    // Console middleware
    protected bool consoleEnabled = true;

    // Enable middleware
    protected bool isMiddlewareEnabled = true;

    // Register container services
    protected bool isServiceEnabled = true;

    // Load routes or not
    protected bool routesEnabled = true;

    // The path to this plugin.
    protected string _path = null;

    // The class path for this plugin.
    protected string _classnamePath = null;

    // The config path for this plugin.
    protected string _configPath = null;

    // The templates path for this plugin.
    protected string _templatePath = null;

    // The name of this plugin
    protected string _name;
    @property void name(string newName) {
        _name = newName;
    }
    @property string name() {
        if (_name.isEmpty) {
            return _name;
        }
        
        string[] pathParts = _classnamePath.split("\\");
        // TODO someParts.pop();
        _name = pathParts.join("/");

        return _name;
    }

    this(Json[string] options = null) {
        /* foreach (aKey; VALID_HOOKS) {
            if (options.hasKey(aKey)) {
                this.{"{aKey}Enabled"} = options.getBoolean(aKey);
            }
        }
        ["name", "path", "classPath", "configPath", "templatePath"]
            .each!(path => if (options.hasKey(path)) {
                this.{path} = options.get(path];
            });

        this.initialize(); */
    }

    string path() {
        if (!_path.isNull) {
            return _path;
        }
        
        ReflectionClass reflection = new DReflectionClass(this);        
        string somePath = dirname(to!string(reflection.getFileName()));

        // Trim off src
        if (somePath.endsWith("src")) {
            somePath = subString(somePath, 0, -3);
        }
        _path = stripRight(somePath, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;

        return _path;
    }
 
    string configPath() {
        return _configPath
            ? _configPath
            : getPath() ~ "config" ~ DIRECTORY_SEPARATOR;
    }
 
    string getClassPath() {
        return _classPath
            ? _classPath
            : getPath ~ "src" ~ DIRECTORY_SEPARATOR;
    }
 
    string getTemplatePath() {
        if (this.templatePath !is null) {
            return _templatePath;
        }
        somePath = getPath();

        return _templatePath = somePath ~ "templates" ~ DIRECTORY_SEPARATOR;
    }
 
    void enable(string aHook) {
        checkHook(aHook);
        // TODO this.{"{aHook}Enabled"} = true;
    }
 
    void disable(string aHook) {
        checkHook(aHook);
        // TODO this.{"{aHook}Enabled"} = false;
    }
 
    bool isEnabled(string aHook) {
        checkHook(aHook);

        // TODO return _{"{aHook}Enabled"} == true;
        return false;
    }
    
    // Check if a hook name is valid
    protected void checkHook(string hookName) {
        if (!isIn(aHook, VALID_HOOKS, true)) {
            throw new DInvalidArgumentException(
                "`%s` is not a valid hook name. Must be one of `%s.`"
                .format(hookName, VALID_HOOKS.join(", "))
           );
        }
    }
 
    void routes(DRouteBuilder routes) {
        somePath = this.configPath() ~ "routes.d";
        if (isFile(somePath)) {
            result = /* require */ somePath;
            if (cast(DClosure)result) {
                result(routes);
            }
        }
    }
 
    void bootstrap(IPluginApplication app) {
        string bootstrapPath = this.configPath() ~ "bootstrap.d";
        if (isFile(bootstrapPath)) {
            require bootstrapPath;
        }
    }
 
    ICommandCollection console(ICommandCollection commands) {
        return commands.addMany(commands.discoverPlugin(_name));
    }
 
    DMiddlewareQueue middleware(DMiddlewareQueue middlewareQueue) {
        return middlewareQueue;
    }
    
    // Register container services for this plugin.
    void services(IContainer containerWithServices) {
    }
}
