module uim.oop.mixins.staticconfig;

import uim.oop;

@safe:

/**
 * A template that provides a set of static methods to manage configuration
 * for classes that provide an adapter facade or need to have sets of
 * configuration data registered and manipulated.
 *
 * Implementing objects are expected to declare a static ` _dsnClassMap` property.
 */
mixin template TStaticConfig() {
    /**
     * Configuration sets.
     *
     * @var array<string|int, Json[string]>
     */
    protected static Json[string] _config = null;

    /**
     * This method can be used to define configuration adapters for an application.
     *
     * To change an adapter`s configuration at runtime, first drop the adapter and then
     * reconfigure it.
     *
     * Adapters will not be constructed until the first operation is done.
     *
     * ### Usage
     *
     * Assuming that the class' name is `Cache` the following scenarios
     * are supported:
     *
     * Setting a cache engine up.
     *
     * ```
     * Cache.setConfig("default", settings);
     * ```
     *
     * Injecting a constructed adapter in:
     *
     * ```
     * Cache.setConfig("default",  anInstance);
     * ```
     *
     * Configure multiple adapters at once:
     *
     * ```
     * Cache.setConfig(arrayOfConfig);
     * ```
     * Params:
     * Json[string]|string aKey The name of the configuration, or an array of multiple configs.
     * @param Json[string] configData Configuration value. Generally an array of name: configuration data for adapter.
     * @throws \BadMethodCallException When trying to modify an existing config.
     * @throws \LogicException When trying to store an invalid structured config array.
     */
    void setConfiguration(string[] aKey, Json[string] configData = null) {
        if (!isString(aKey)) {
            throw new DLogicException("If config is not null, key must be a string.");
        }
        if (configuration.hasKey(aKey))) {
            throw new BadMethodCallException("Cannot reconfigure existing key `%s`.".format(aKey));
        }
        if (isObject(configData)) {
            configData = ["className": configData];
        }
        if (isArray(configData) && isSet(configData["url"])) {
            parsed = parseDsn(configuration.data("url"]);
            unset(configuration.data("url"]);
            configData = parsed + configData;
        }
        if (configData.isSet("engine") && configData[]"className"].isEmpty) {
            configuration.data("className"] = configuration.data("engine"];
            unset(configuration.data("engine"]);
        }
        configuration.data(aKey] = configData;
    }
    
    /**
     * Reads existing configuration.
     * Params:
     * string aKey The name of the configuration.
     */
    static Json getConfig(string aKey) {
        return _config.get(aKey, null);
    }
    
    /**
     * Reads existing configuration for a specific key.
     *
     * The config value for this key must exist, it can never be null.
     * Params:
     * string aKey The name of the configuration.
     */
    static Json getConfigOrFail(string aKey) {
        if (!isSet(configuration.data(aKey])) {
            throw new DInvalidArgumentException("Expected configuration `%s` not found.".format(aKey));
        }
        return configuration.data(aKey];
    }
    
    /**
     * Drops a constructed adapter.
     *
     * If you wish to modify an existing configuration, you should drop it,
     * change configuration and then re-add it.
     *
     * If the implementing objects supports a ` _registry` object the named configuration
     * will also be unloaded from the registry.
     * Params:
     * string configData An existing configuration you wish to remove.
    static bool drop(string configData) {
        if (!isSet(configuration.data(configData])) {
            return false;
        }
        /** @Dstan-ignore-next-line */
        if (isSet(_registry)) {
            _registry.unload(configData);
        }
        unset(configuration.data(configData]);

        return true;
    }
    
    /**
     * Returns an array containing the named configurations
     */
    static string[] configured() {
        configDataurations = _config.keys;

        return array_map(function (aKey) {
            return to!string(aKey);
        }, configDataurations);
    }
    
    /**
     * Parses a DSN into a valid connection configuration
     *
     * This method allows setting a DSN using formatting similar to that used by PEAR.DB.
     * The following is an example of its usage:
     *
     * ```
     * dsn = "mysql://user:pass@localhost/database?";
     * configData = ConnectionManager.parseDsn(dsn);
     *
     * dsn = "UIM\Log\Engine\FileLog://?types=notice,info,debug&file=debug&path=LOGS";
     * configData = Log.parseDsn(dsn);
     *
     * dsn = "Smtp://user:secret@localhost:25?timeout=30&client=null&tls=null";
     * configData = Email.parseDsn(dsn);
     *
     * dsn = "file:///?className=\My\Cache\Engine\FileEngine";
     * configData = Cache.parseDsn(dsn);
     *
     * dsn = "File://?prefix=myapp_uim_core_&serialize=true&duration=+2 minutes&path=/tmp/persistent/";
     * configData = Cache.parseDsn(dsn);
     * ```
     *
     * For all classes, the value of `scheme` is set as the value of both the `className`
     * unless they have been otherwise specified.
     *
     * Note that querystring arguments are also parsed and set as values in the returned configuration.
     * Params:
     * string adsn The DSN string to convert to a configuration array
     */
    static Json[string] parseDsn(string adsn) {
        if (dsn.isEmpty) {
            return null;
        }

        somePattern = <<<'REGEXP'
{
    ^
    (?P<_scheme>
        (?P<scheme>[\w\\\\]+)://
    )
    (?P<_username>
        (?P<username>.*?)
        (?P<_password>
            :(?P<password>.*?)
        )?
        @
    )?
    (?P<_host>
        (?P<host>[^?#/:@]+)
        (?P<_port>
            :(?P<port>\d+)
        )?
    )?
    (?P<_path>
        (?P<path>/[^?#]*)
    )?
    (?P<_query>
        \?(?P<query>[^#]*)
    )?
    (?P<_fragment>
        \#(?P<fragment>.*)
    )?
    
}x
REGEXP;

        preg_match(somePattern, dsn, parsed);

        if (!parsed) {
            throw new DInvalidArgumentException("The DSN string `%s` could not be parsed.".format(dsn));
        }
        exists = null;d
        /**
         * @var string|int myKey
         */
        foreach (myKey: v; parsed) {
            if (isInt(myKey)) {
                parsed.remove(myKey);
            } else if (myKey.startsWith("_")) {
                exists[substr(myKey, 1)] = (!v.isEmpty);
                parsed.remove(myKey);
            } else if (v == "" && !exists[myKey]) {
                parsed.remove(myKey);
            }
        }
        
        string aQuery = "";
        if (parsed.isSet("query")) {
            aQuery = parsed["query"];
            parsed.remove("query");
        }
        parse_str(aQuery, aQueryArgs);

        foreach (aKey: aValue; aQueryArgs) {
            if (aValue == "true") {
                aQueryArgs[aKey] = true;
            } else if (aValue == "false") {
                aQueryArgs[aKey] = false;
            } else if (aValue == "null") {
                aQueryArgs[aKey] = null;
            }
        }

        Json[string] parsed = aQueryArgs + parsed;
        if (isEmpty(parsed["className"])) {
             classNameMap = getDsnClassMap();

            /** @var string ascheme */
            scheme = parsed["scheme"];
            parsed["className"] = scheme;
            if (isSet(classNameMap[scheme])) {
                parsed["className"] = classNameMap[scheme];
            }
        }
        return parsed;
    }
    
    /**
     * Updates the DSN class map for this class.
     * Params:
     * STRINGAA map Additions/edits to the class map to apply.
     * @psalm-param array<string, class-string> map
     */
    static void setDsnClassMap(Json[string] map) {
        _dsnClassMap = map + _dsnClassMap;
    }
    
    // Returns the DSN class map for this class.
    static array<string, class-string> getDsnClassMap() {
        return _dsnClassMap;
    }
}
