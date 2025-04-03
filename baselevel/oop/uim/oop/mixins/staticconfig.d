/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
     * Cache.setConfig("default", anInstance);
     * ```
     *
     * Configure multiple adapters at once:
     *
     * ```
     * Cache.setConfig(arrayOfConfig);
     * ```
     */
    void setConfiguration(string[] configurationName, Json[string] configData = null) {
        if (!isString(configurationName)) {
            throw new DLogicException("If config is not null, key must be a string.");
        }
        if (configuration.hasEntry(configurationName)) {
            throw new BadMethodCallException(
                "Cannot reconfigure existing key `%s`.".format(configurationName));
        }
        if (isObject(configData)) {
            configData = ["classname": configData];
        }
        if (configuration.isArray && configuration.hasEntry("url")) {
            auto parsed = parseDsn(configuration.getEntry("url"));
            configuration.removeKey("url");
            configData = parsed + configData;
        }
        if (configuration.hasEntry("engine") && configuration.isEmpty("classname")) {
            configuration.setEntry("classname", configuration.getEntry("engine"));
            configuration.removeKey("engine");
        }
        configuration.setEntry(aKey, configData);
    }

    // Reads existing configuration.
    static Json getConfig(string key) {
        return configuration.getEntry(aKey, null);
    }

    /**
     * Reads existing configuration for a specific key.
     *
     * The config value for this key must exist, it can never be null.
     * Params:
     * string aKey The name of the configuration.
     */
    static Json getConfigOrFail(string configName) {
        if (configuration.isNullEntry(configName)) {
            throw new DInvalidArgumentException(
                "Expected configuration `%s` not found.".format(configName));
        }
        return configuration.data(configName);
    }

    /**
     * Drops a constructed adapter.
     *
     * If you wish to modify an existing configuration, you should drop it,
     * change configuration and then re-add it.
     *
     * If the implementing objects supports a ` _registry` object the named configuration
     * will also be unloaded from the registry.
    */
    static bool drop(string key) {
        if (!configuration.hasEntry(key)) {
            return false;
        }
        if (!_registry.isNull) {
            _registry.unload(key);
        }
        configuration.removeKey(key);

        return true;
    }

    // Returns an array containing the named configurations
    static string[] configured() {
        return _config.keys,map!(key => to!string(aKey)).array;
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
     * dsn = "file:///?classname=\My\Cache\Engine\FileEngine";
     * configData = Cache.parseDsn(dsn);
     *
     * dsn = "File://?prefix=myapp_uim_core_&serialize=true&duration=+2 minutes&path=/tmp/persistent/";
     * configData = Cache.parseDsn(dsn);
     * ```
     *
     * For all classes, the value of `scheme` is set as the value of both the `classname`
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

        auto somePattern = ` <<<'REGEXP'
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
REGEXP`;

        preg_match(somePattern, dsn, parsed);

        if (!parsed) {
            throw new DInvalidArgumentException(
                "The DSN string `%s` could not be parsed.".format(dsn));
        }
        exists = null;
        /**
         * @var string|int myKey
         */
        // TODO
        /*
        foreach (myKey: v; parsed) {
            if (isInteger(myKey)) {
                parsed.removeKey(myKey);
            } else if (myKey.startsWith("_")) {
                exists[subString(myKey, 1)] = (!v.isEmpty);
                parsed.removeKey(myKey);
            } else if (v is null && !exists[myKey]) {
                parsed.removeKey(myKey);
            }
        } */

        string aQuery = "";
        if (parsed.hasKey("query")) {
            aQuery = parsed["query"];
            parsed.removeKey("query");
        }
        parse_str(aQuery, aQueryArgs);

        aQueryArgs.byKeyValue.each!((kv) {
            string value = value.get!string;
            if (value == "true") {
                aQueryArgs[kv.key] = true;
            } else if (value == "false") {
                aQueryArgs[kv.key] = false;
            } else if (value == "null") {
                aQueryArgs[kv.key] = null;
            }
        });

        Json[string] parsed = aQueryArgs + parsed;
        if (isEmpty(parsed["classname"])) {
            classnameMap = getDsnClassMap();

            /** @var string ascheme */
            scheme = parsed["scheme"];
            parsed.set("classname", scheme);
            if (classnameMap.hasKey(scheme)) {
                parsed.set("classname", classnameMap[scheme]);
            }
        }
        return parsed;
    }

    // Updates the DSN class map for this class.
    static void setDsnClassMap(string[string] map) {
        _dsnClassMap = map + _dsnClassMap;
    }

    // Returns the DSN class map for this class.
    static STRINGAA getDsnClassMap() {
        return _dsnClassMap;
    }
}
