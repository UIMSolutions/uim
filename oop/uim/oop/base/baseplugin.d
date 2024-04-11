module uim.oop.base.baseplugin;

import uim.oop;

@safe:

/**
 * Base Plugin Class
 *
 * Every plugin should extend from this class or implement the interfaces and
 * include a plugin class in its src root folder.
 */
class DPlugin : IPlugin {
  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
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
    protected string classNamePath = null;

    // The config path for this plugin.
    protected string configDataPath = null;

    // The templates path for this plugin.
    protected string atemplatePath = null;

    // The name of this plugin
    protected string _name = null;

    /**
     * Constructor
     * Params:
     * IData[string] options Options
     * /
    this(IData[string] options = null) {
        foreach (aKey; VALID_HOOKS) {
            if (isSet(options[aKey])) {
                this.{"{aKey}Enabled"} = (bool)options[aKey];
            }
        }
        ["name", "path", "classPath", "configPath", "templatePath"]
            .each!(path => if (isSet(options[path])) {
                this.{path} = options[path];
            });

        this.initialize();
    }
    
    bool initialize(IData[string] initData = null) {
    }
 
    @property string name() {
        if (_name is null) {
            return _name;
        }
        
        string[] someParts = split("\\", class);
        array_pop(someParts);
        _name = someParts.join("/");

        return _name;
    }
 
    string getPath() {
        if (!_path is null) {
            return _path;
        }
        
        ReflectionClass reflection = new DReflectionClass(this);        
        string somePath = dirname(to!string(reflection.getFileName()));

        // Trim off src
        if (somePath.endsWith("src")) {
            somePath = substr(somePath, 0, -3);
        }
        this.path = rtrim(somePath, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;

        return this.path;
    }
 
    string getConfigPath() {
        if (this.configPath !isNull) {
            return this.configPath;
        }
        somePath = this.getPath();

        return somePath ~ "config" ~ DIRECTORY_SEPARATOR;
    }
 
    string getClassPath() {
        if (this.classPath !isNull) {
            return this.classPath;
        }
        somePath = this.getPath();

        return somePath ~ "src" ~ DIRECTORY_SEPARATOR;
    }
 
    string getTemplatePath() {
        if (this.templatePath !isNull) {
            return this.templatePath;
        }
        somePath = this.getPath();

        return this.templatePath = somePath ~ "templates" ~ DIRECTORY_SEPARATOR;
    }
 
    void enable(string aHook) {
        this.checkHook(aHook);
        this.{"{aHook}Enabled"} = true;
    }
 
    void disable(string aHook) {
        this.checkHook(aHook);
        this.{"{aHook}Enabled"} = false;
    }
 
    bool isEnabled(string aHook) {
        this.checkHook(aHook);

        return this.{"{aHook}Enabled"} == true;
    }
    
    /**
     * Check if a hook name is valid
     * Params:
     * string aHook The hook name to check
     * @throws \InvalidArgumentException on invalid hooks
     * /
    protected void checkHook(string aHook) {
        if (!in_array(aHook, VALID_HOOKS, true)) {
            throw new DInvalidArgumentException(
                "`%s` is not a valid hook name. Must be one of `%s.`"
                .format(aHook, join(", ", VALID_HOOKS))
            );
        }
    }
 
    void routes(RouteBuilder routes) {
        somePath = this.getConfigPath() ~ "routes.d";
        if (isFile(somePath)) {
            result = require somePath;
            if (cast(DClosure)result) {
                result(routes);
            }
        }
    }
 
    void bootstrap(IPluginApplication app) {
        string bootstrapPath = this.getConfigPath() ~ "bootstrap.d";
        if (isFile(bootstrapPath)) {
            require bootstrapPath;
        }
    }
 
    CommandCollection console(CommandCollection commands) {
        return commands.addMany(commands.discoverPlugin(_name));
    }
 
    MiddlewareQueue middleware(MiddlewareQueue middlewareQueue) {
        return middlewareQueue;
    }
    
    // Register container services for this plugin.
    void services(IContainer containerWithServices) {
    } */
}
