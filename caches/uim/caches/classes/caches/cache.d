module uim.caches.classes.caches.cache;

import uim.caches;

@safe:

/**
 * Cache provides a consistent interface to Caching in your application. It allows you
 * to use several different Cache engines, without coupling your application to a specific
 * implementation. It also allows you to change out cache storage or configuration without effecting
 * the rest of your application.
 *
 * ### Configuring Cache engines
 *
 * You can configure Cache engines in your application`s `Config/cache.d` file.
 * A sample configuration would be:
 *
 * ```
 * Cache.config("shared", [
 *   'className": UIM\Cache\Engine\ApcuEngine.classname,
 *   'prefix": '_app_'
 * ]);
 * ```
 *
 * This would configure an APCu cache engine to the `shared' alias. You could then read and write
 * to that cache alias by using it for the `configName` parameter in the various Cache methods.
 *
 * In general all Cache operations are supported by all cache engines.
 * However, Cache.increment() and Cache.decrement() are not supported by File caching.
 *
 * There are 7 built-in caching engines:
 *
 * - `ApcuEngine` - Uses the APCu object cache, one of the fastest caching engines.
 * - `ArrayEngine` - Uses only memory to store all data, not actually a persistent engine.
 *   Can be useful in test or CLI environment.
 * - `FileEngine` - Uses simple files to store content. Poor performance, but good for
 *   storing large objects, or things that are not IO sensitive. Well suited to development
 *   as it is an easy cache to inspect and manually flush.
 * - `MemcacheEngine` - Uses the PECL.Memcache extension and Memory for storage.
 *   Fast reads/writes, and benefits from memcache being distributed.
 * - `RedisEngine` - Uses redis and D-redis extension to store cache data.
 * - `XcacheEngine` - Uses the Xcache extension, an alternative to APCu.
 *
 * See Cache engine documentation for expected configuration keys.
 *
 * @see config/app.d for configuration settings
 */
class DCache : ICache {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string newName) {
        this();
        this.name(newName);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        // An array mapping URL schemes to fully qualified caching engine class names.
        _dsnClassMap = [
            "array": ArrayCacheEngine.className,
            "apcu": ApcuCacheEngine.className,
            "file": FileCacheEngine.className,
            "memcached": MemoryCacheEngine.className,
            "null": NullCacheEngine.className,
            "redis": RedisCacheEngine.className,
        ];

        return true;
    }

    mixin(TProperty!("string", "name"));

    // An array mapping URL schemes to fully qualified caching engine class names.
    protected static STRINGAA _dsnClassMap;

    // #region enable
    // Flag for tracking whether caching is enabled.
    protected static bool _enabled = true;
    // Re-enable caching.
    static void enable() {
        _enabled = true;
    }
    
    // Disable caching.
    static void disable() {
        _enabled = false;
    }
    
    // Check whether caching is enabled.
    static bool enabled() {
        return _enabled;
    }
    // #endregion enable

    // Group to Config mapping
    protected static Json _groups = null;

    // Cache Registry used for creating and using cache adapters.
    protected static DCacheRegistry _registry;

    // Returns the Cache Registry instance used for creating and using cache adapters.
    static DCacheRegistry getRegistry() {
        return _registry ? _registry : new DCacheRegistry();
    }

    /**
     * Sets the Cache Registry instance used for creating and using cache adapters.
     * Also allows for injecting of a new registry instance.
     */
    static void setRegistry(DCacheRegistry cacheRegistry) {
        _registry = cacheRegistry;
    } 

    /**
     * Finds and builds the instance of the required engine class.
     * @throws \RuntimeException If loading of the engine failed.
     * /
    protected static void _buildEngine(string configName) {
        auto myRegistry = getRegistry();

        if (isEmpty(configuration.get(configName)["className"])) {
            throw new DInvalidArgumentException(
                "The `%s` cache configuration does not exist.".format(configName)
            );
        }
        
        auto configData = configuration.get(configName);
        try {
            myRegistry.load(configName, configData);
        } catch (RuntimeException mye) {
            if (!array_key_exists("fallback", configData)) {
                myRegistry.set(configName, new DNullEngine());
                trigger_error(mye.getMessage(), E_USER_WARNING);

                return;
            }
            if (configuration.get("fallback"] == false) {
                throw mye;
            }
            if (configuration.get("fallback"] == configName) {
                throw new DInvalidArgumentException(
                    "`%s` cache configuration cannot fallback to itself."
                    .format(configName
                ), 0, mye);
            }
            myfallbackEngine = pool(configuration.get("fallback"]).clone;
            assert(cast(DCacheEngine)myfallbackEngine);

            mynewConfig = configuration.update([
                    "groups": Json.emptyArray, 
                    "prefix": StringData
                ]);

            myfallbackEngine.configuration.update("groups", mynewConfig["groups"], false);
            if (mynewConfig["prefix"]) {
                myfallbackEngine.configuration.update("prefix", mynewConfig["prefix"], false);
            }
            myRegistry.set(configName, myfallbackEngine);
        }
        if (cast(DCacheEngine)configuration.get("className"]) {
            configData = configuration.get("className"].configuration.data;
        }
        if (!configuration.isEmpty("groups")) {
            (cast(DArrayData)configuration.get("groups"]).values.each!((groupName) {
                _groups[groupName] ~= configName;
                _groups[groupName] = array_unique(_groups[groupName]);
                _groups[groupName].sort;
            });
        } * /
    }
    
    // Get a SimpleCacheEngine object for the named cache pool.
    /* static ICache&ICacheEngine pool(string configName) {
        if (!_enabled) {
            return new DNullEngine();
        }
        myRegistry = getRegistry();

        if (isSet(myRegistry.{configName})) {
            return myRegistry.{configName};
        }
        _buildEngine(configName);

        return myRegistry.{configName};
    } */

    /**
     * Write data for key into cache.
     *
     * ### Usage:
     *
     * Writing to the active cache config:
     *
     * ```
     * Cache.write("cached_data", mydata);
     * ```
     *
     * Writing to a specific cache config:
     *
     * ```
     * Cache.write("cached_data", mydata, "long_term");
     * ```
     * Params:
     * @param Json dataToCache Data to be cached - anything except a resource
     * /
    static bool write(string dataId, Json dataToCache, string configName = "default") {
        if (isResource(dataToCache)) {
            return false;
        }
        auto mybackend = pool(configName);
        auto wasSuccessful = mybackend.set(dataId, dataToCache);
        if (!wasSuccessful && dataToCache != "") {
            throw new DCacheWriteException(
                "%s cache was unable to write '%s' to %s cache"
                .format(
                    configName,
                    dataId,
                    get_class(mybackend)
            ));
        }
        return wasSuccessful;
    }
    
    /**
     * Write data for many keys into cache.
     *
     * ### Usage:
     *
     * Writing to the active cache config:
     *
     * ```
     * Cache.writeMany(["cached_data_1": 'data 1", "cached_data_2": 'data 2"]);
     * ```
     *
     * Writing to a specific cache config:
     *
     * ```
     * Cache.writeMany(["cached_data_1": 'data 1", "cached_data_2": 'data 2"], "long_term");
     * ```
     * Params:
     * range mydata An array or Traversable of data to be stored in the cache
     * @param string configName Optional string configuration name to write to. Defaults to "default"
     * returns = True on success, false on failure
     */
    /* static bool writeMany(Range mydata, string configName = "default") {
        return pool(configName).setMultiple(mydata);
    } */

    /**
     * Read a key from the cache.
     *
     * ### Usage:
     *
     * Reading from the active cache configuration.
     *
     * ```
     * Cache.read("_data");
     * ```
     *
     * Reading from a specific cache configuration.
     *
     * ```
     * Cache.read("_data", "long_term");
     * ```
     * Params:
     * @param string configName optional name of the configuration to use. Defaults to "default"
     */
    /* static Json read(string dataId, string configName = "default") {
        return pool(configName).get(dataId);
    } */

    /**
     * Read multiple keys from the cache.
     *
     * ### Usage:
     *
     * Reading multiple keys from the active cache configuration.
     *
     * ```
     * Cache.readMany(["_data_1", "_data_2]);
     * ```
     *
     * Reading from a specific cache configuration.
     *
     * ```
     * Cache.readMany(["_data_1", "_data_2], "long_term");
     * ```
     * Params:
     * string[] someKeys An array or Traversable of keys to fetch from the cache
     * @param string configName optional name of the configuration to use. Defaults to "default"
     */
    /* static Range readMany(string[] keysToFetch, string configName = "default") {
        return pool(configName).cacheItems(keysToFetch);
    } */

    /**
     * Increment a number under the key and return incremented value.
     * Params:
     * @param string configName Optional string configuration name. Defaults to "default"
     */
    /* static int|false increment(string dataId, int incValue = 1, string configName = "default") {
        if (incValue < 0) {
            throw new DInvalidArgumentException("Offset cannot be less than `0`.");
        }
        return pool(configName).increment(dataId, incValue);
    } */

    // Decrement a number under the key and return decremented value.
    /* static int|false decrement(string dataId, int decValue = 1, string configName = "default") {
        if (decValue < 0) {
            throw new DInvalidArgumentException("Offset cannot be less than `0`.");
        }
        return pool(configName).decrement(dataId, decValue);
    } */

    /**
     * Delete a key from the cache.
     *
     * ### Usage:
     *
     * Deleting from the active cache configuration.
     *
     * ```
     * Cache.remove("_data");
     * ```
     *
     * Deleting from a specific cache configuration.
     *
     * ```
     * Cache.remove("_data", "long_term");
     * ```
     */
    /* static bool remove(string dataId, string configName = "default") {
        return pool(configName).remove(dataId);
    } */

    /**
     * Delete many keys from the cache.
     *
     * ### Usage:
     *
     * Deleting multiple keys from the active cache configuration.
     *
     * ```
     * Cache.deleteMany(["_data_1", "_data_2"]);
     * ```
     *
     * Deleting from a specific cache configuration.
     *
     * ```
     * Cache.deleteMany(["_data_1", "_data_2], "long_term");
     * ```
     * /
    static bool deleteMany(string[] someKeys, string configName = "default") {
        return pool(configName).removeItems(someKeys);
    }
    
    /**
     * Delete all keys from the cache.
     * Params:
     * returns True if the cache was successfully cleared, false otherwise
     * /
    static bool clear(string configName = "default") {
        return pool(configName).clear();
    }
    
    /**
     * Delete all keys from the cache from all configurations.
     *
     * Status code. For each configuration, it reports the status of the operation
     */
    /* static bool[string] clearAll() {
        auto[string] mystatus;

        self.configured().each!(configName => mystatus[configName] = self.clear(configName));

        return mystatus;
    } */

    /* Delete all keys from the cache belonging to the same group.
    static bool clearGroup(string groupName, string configName = "default") {
        return pool(configName).clearGroup(groupName);
    }
    
    /**
     * Retrieve group names to config mapping.
     *
     * ```
     * Cache.config("daily", ["duration": '1 day", "groups": ["posts"]]);
     * Cache.config("weekly", ["duration": '1 week", "groups": ["posts", "archive"]]);
     * configDatas = Cache.groupConfigs("posts");
     * ```
     *
     * configDatas will equal to `["posts": ["daily", "weekly"]]`
     * Calling this method will load all the configured engines.
     * Params:
     * string|null groupName Group name or null to retrieve all group mappings
     */
    /* static array[string] groupConfigs(string groupName = null) {
        configured()
            .each!(configName => pool(configName));

        if (groupName is null) {
            return _groups;
        }
        if (isSet(self._groups[groupName])) {
            return [groupName: self._groups[groupName]];
        }
        throw new DInvalidArgumentException("Invalid cache group `%s`.".format(groupName));
    } */

    
    /**
     * Provides the ability to easily do read-through caching.
     *
     * If the key is not set, the default callback is run to get the default value.
     * The results will then be stored into the cache config
     * at key.
     *
     * Examples:
     *
     * Using a Closure to provide data, assume `this` is a Table object:
     *
     * ```
     * results = Cache.remember("all_articles", auto () {
     *     return _find("all").toArray();
     * });
     * ```
     * Params:
     * string aKey The cache key to read/store data at.
     * @param \Closure mydefault The callback that provides data in the case when
     *  the cache key is empty.
     */
    /* static Json remember(string aKey, IClosure callbackWhenEmpty, string configName = "default") {
        auto myexisting = self.read(aKey, configName);
        if (myexisting !isNull) {
            return myexisting;
        }
        
        Json results = callbackWhenEmpty();
        self.write(aKey, results, configName);

        return results;
    } */

    /**
     * Write data for key into a cache engine if it doesn`t exist already.
     *
     * ### Usage:
     *
     * Writing to the active cache config:
     *
     * ```
     * Cache.add("cached_data", mydata);
     * ```
     *
     * Writing to a specific cache config:
     *
     * ```
     * Cache.add("cached_data", mydata, "long_term");
     * ```
     * /
    static bool add(string dataId, Json dataToCache, string configName = "default") {
        if (isResource(dataToCache)) {
            return false;
        }
        return pool(configName).add(dataId, dataToCache);
    } */
}
