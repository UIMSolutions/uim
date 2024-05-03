module uim.oop.base.configure;

import uim.oop;

@safe:

/**
 * Configuration class. Used for managing runtime configuration information.
 *
 * Provides features for reading and writing to the runtime configuration, as well
 * as methods for loading additional configuration files or storing runtime configuration
 * for future use.
 *
 * @link https://book.UIM.org/5/en/development/configuration.html
 * /
class DConfigure {
  	bool initialize(IData[string] initData = null) {
		return true;
	}

    // Array of values currently stored in Configure.
    protected static IData[string] _values = [
        "debug": Json(false),
    ];

    /**
     * Configured engine classes, used to load config files from resources
     *
     * @see \UIM\Core\Configure.load()
     * @var array<\UIM\Core\Configure\IConfigEngine>
     * /
    protected static IConfigEngine[] _engines;

    // Flag to track whether ini_set exists.
    protected static bool _hasIniSet = null;

    /**
     * Used to store a dynamic variable in Configure.
     *
     * Usage:
     * ```
     * Configuration.update("One.key1", "value of the Configure.One[key1]");
     * Configuration.update(["One.key1": 'value of the Configure.One[key1]"]);
     * Configuration.update("One", [
     *    'key1": 'value of the Configure.One[key1]",
     *    'key2": 'value of the Configure.One[key2]'
     * ]);
     *
     * Configuration.update([
     *    'One.key1": 'value of the Configure.One[key1]",
     *    'One.key2": 'value of the Configure.One[key2]'
     * ]);
     * ```
     * Params:
     * IData[string]|string configData The key to write, can be a dot notation value.
     * Alternatively can be an array containing key(s) and value(s).
     * @param Json aValue Value to set for the given key.
     * @link https://book.UIM.org/5/en/development/configuration.html#writing-configuration-data
     * /
    static void write(string key, Json aValue = null) {
        auto configData = [key: aValue];
        write(configData, aValue); 
    }
    static void write(string[] configData, Json aValue = null) {
        configData.byKeyValue
            .each!(nameValue => _values = Hash.insert(_values, nameValue.key, nameValue.value));

        if (configData.isSet("debug")) {
            _hasIniSet ?  ?  = function_exists("ini_set");

            if (_hasIniSet) {
                ini_set("display_errors", configData("debug"] ? "1" : "0");
            }
            if (configuration.hasKey("debug") && UIM_SAPI != "cli' && ini_get(" zend.assertions") == " - 1 ") {
                trigger_error(
                    'You should set `zend.assertions` to `1` in your D.ini for your development environment.",
                E_USER_WARNING
                );
        }
    }
}

/**
     * Used to read information stored in Configure. It`s not
     * possible to store `null` values in Configure.
     *
     * Usage:
     * ```
     * Configuration.read("Name"); will return all values for Name
     * Configuration.read("Name.key"); will return only the value of Configure.Name[key]
     * ```
     * Params:
     * string var Variable to obtain. Use '.' to access array elements.
     * @param Json defaultValue The return value when the configure does not exist
     * /
static Json read(string avar = null, IData defaultData = null) {
    if (var.isNull) {
        return _values;
    }
    return Hash.get(_values, var, defaultData);
}

// Returns true if given variable is set in Configure.
static bool check(string variableName) {
    if (variableName.isEmpty) {
        return false;
    }
    return read(variableName) !isNull;
}

/**
     * Used to get information stored in Configure. It`s not
     * possible to store `null` values in Configure.
     *
     * Acts as a wrapper around Configuration.read() and Configure.check().
     * The configure key/value pair fetched via this method is expected to exist.
     * In case it does not an exception will be thrown.
     *
     * Usage:
     * ```
     * Configure.readOrFail("Name"); will return all values for Name
     * Configure.readOrFail("Name.key"); will return only the value of Configure.Name[key]
     * ```
     * Params:
     * string avar Variable to obtain. Use '.' to access array elements.
     * /
static Json readOrFail(string avar) {
    if (!check(var)) {
        throw new UimException("Expected configuration key `%s` not found.".format(var));
    }
    return read(var);
}

/**
     * Used to delete a variable from Configure.
     *
     * Usage:
     * ```
     * Configuration.remove("Name"); will delete the entire Configure.Name
     * Configuration.remove("Name.key"); will delete only the Configure.Name[key]
     * ```
     * Params:
     * string avar the var to be deleted
     * @link https://book.UIM.org/5/en/development/configuration.html#deleting-configuration-data
     * /
static void delete(string avar) {
    _values = Hash.remove(_values, var);
}

/**
     * Used to consume information stored in Configure. It`s not
     * possible to store `null` values in Configure.
     *
     * Acts as a wrapper around Configure.consume() and Configure.check().
     * The configure key/value pair consumed via this method is expected to exist.
     * In case it does not an exception will be thrown.
     * Params:
     * string avar Variable to consume. Use '.' to access array elements.
     * /
static Json consumeOrFail(string avar) {
    if (!check(var)) {
        throw new UimException("Expected configuration key `%s` not found.".format(var));
    }
    return consume(var);
}

/**
     * Used to read and delete a variable from Configure.
     *
     * This is primarily used during bootstrapping to move configuration data
     * out of configure into the various other classes in UIM.
     * Params:
     * string avar The key to read and remove.
     * /
static Json consume(string avar) {
    if (!var.has(".")) {
        if (!isSet(_values[var])) {
            return null;
        }
        aValue = _values[var];
        _values.remove(var);

        return aValue;
    }
    aValue = Hash.get(_values, var);
    delete(var);

    return aValue;
}

/**
     * Add a new engine to Configure. Engines allow you to read configuration
     * files in various formats/storage locations. UIM comes with two built-in engines
     * PhpConfig and IniConfig. You can also implement your own engine classes in your application.
     *
     * To add a new engine to Configure:
     *
     * ```
     * Configure.config("ini", new DIniConfig());
     * ```
     * Params:
     * string aName The name of the engine being configured. This alias is used later to
     *  read values from a specific engine.
     * @param \UIM\Core\Configure\IConfigEngine engineToAppend The engine to append.
     * /
static void config(string aName, IConfigEngine engineToAppend) {
    _engines[name] = engineToAppend;
}

/**
     * Returns true if the Engine objects is configured.
     * Params:
     * string aName Engine name.
     * /
static bool isConfigured(string aName) {
    return isSet(_engines[name]);
}

// Gets the names of the configured Engine objects.
static string[] configured() {
    engines = _engines.keys;

    return array_map(function(aKey) {
        return to!string(aKey);}, engines);
    }

    /**
     * Remove a configured engine. This will unset the engine
     * and make any future attempts to use it cause an Exception.
     * Params:
     * string aName Name of the engine to drop.
     * /
    static bool drop(string aName) {
        if (!_engines.isSet(name)) {
            return false;
        }
        _engines.remove(name);

        return true;
    }

    /**
     * Loads stored configuration information from a resource. You can add
     * config file resource engines with `Configure.config()`.
     *
     * Loaded configuration information will be merged with the current
     * runtime configuration. You can load configuration files from plugins
     * by preceding the filename with the plugin name.
     *
     * `Configure.load("Users.user", "default")`
     *
     * Would load the 'user' config file using the default config engine. You can load
     * app config files by giving the name of the resource you want loaded.
     *
     * ```
     * Configure.load("setup", "default");
     * ```
     *
     * If using `default` config and no engine has been configured for it yet,
     * one will be automatically created using PhpConfig
     * Params:
     * string aKey name of configuration resource to load.
     * @param string configData Name of the configured engine to use to read the resource identified by aKey.
     * @param bool merge if config files should be merged instead of simply overridden
     * /
    static bool load(string aKey, string configData = "default", boolmerge = true) {
        engine = _getEngine(configData);
        if (!engine) {
            throw new UimException(
                "Config %s engine not found when attempting to load %s."
                    .format(configData, aKey)
            );
        }
        someValues = engine.read(aKey);

        if (merge) {
            someValues = Hash.merge(_values, someValues);
        }
        write(someValues);

        return true;
    }

    /**
     * Dump data currently in Configure into aKey. The serialization format
     * is decided by the config engine attached as configData. For example, if the
     * "default" adapter is a PhpConfig, the generated file will be a D
     * configuration file loadable by the PhpConfig.
     *
     * ### Usage
     *
     * Given that the "default" engine is an instance of PhpConfig.
     * Save all data in Configure to the file `_config.d`:
     *
     * ```
     * Configure.dump("_config", "default");
     * ```
     *
     * Save only the error handling configuration:
     *
     * ```
     * Configure.dump("error", "default", ["Error", "Exception"];
     * ```
     * Params:
     * string aKey The identifier to create in the config adapter.
     *  This could be a filename or a cache key depending on the adapter being used.
     * @param string configData The name of the configured adapter to dump data with.
     * @param string[] someKeys The name of the top-level keys you want to dump.
     *  This allows you save only some data stored in Configure.
     * /
    static bool dump(string aKey, string configData = "default", array someKeys = [
        ]) {
        auto myEngine = _getEngine(configData);
        if (!myEngine) {
            throw new UimException("There is no `%s` config engine.".format(configData));
        }
        someValues = _values;
        if (!empty(someKeys)) {
            someValues = array_intersect_key(someValues, array_flip(someKeys));
        }
        return myEngine.dump(aKey, someValues);
    }

    /**
     * Get the configured engine. Internally used by `Configure.load()` and `Configure.dump()`
     * Will create new DPhpConfig for default if not configured yet.
     * Params:
     * string configData The name of the configured adapter
     * /
    protected static IConfigEngine _getEngine(string configData) {
        if (!isSet(_engines[configData])) {
            if (configData != "default") {
                return null;
            }
            config(configData, new DPhpConfig());
        }
        return static._engines[configData];
    }

    /**
     * Used to determine the current version of UIM.
     *
     * Usage
     * ```
     * Configure.currentVersion();
     * ```
     * /
    static string currentVersion() {
        auto uimVersion = read("uim.version");
        if (!uimVersion.isNull) {
            return uimVersion;
        }
        
        auto somePath = dirname(__DIR__, 2) ~ DIRECTORY_SEPARATOR ~ "config/config.d";

        if (isFile(somePath)) {
            configData = require somePath;
            write(configData);

            return read("uim.version");
        }
        return "unknown";
    }

    /**
     * Used to write runtime configuration into Cache. Stored runtime configuration can be
     * restored using `Configure.restore()`. These methods can be used to enable configuration managers
     * frontends, or other GUI type interfaces for configuration.
     * Params:
     * string aName The storage name for the saved configuration.
     * @param string acacheConfig The cache configuration to save into. Defaults to "default"
     * @param array|null someData Either an array of data to store, or leave empty to store all values.
     * /
    static bool store(string aName, string acacheConfig = "default",  ? array data = null) {
        someData ?  ?  = _values;

        if (!class_exists(Cache.classname)) {
            throw new UimException("You must install UIM/cache to use Configure.store()");
        }
        return Cache.write(name, someData, cacheConfig);
    }

    /**
     * Restores configuration data stored in the Cache into configure. Restored
     * values will overwrite existing ones.
     * Params:
     * string aName Name of the stored config file to load.
     * @param string acacheConfig Name of the Cache configuration to read from.
     * /
    static bool restore(string aName, string acacheConfig = "default") {
        if (!class_exists(Cache.classname)) {
            throw new UimException("You must install UIM/cache to use Configure.restore()");
        }
        
        auto someValues = Cache.read(name, cacheConfig);
        if (someValues) {
            write(someValues);

            return true;
        }
        return false;
    }

    // Clear all values stored in Configure.
    static void clear() {
        _values = null;
    } * /
} 
*/