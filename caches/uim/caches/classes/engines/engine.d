module uim.caches.classes.engines.engine;

import uim.caches;

@safe:

// Storage engine for UIM caching
abstract class DCacheEngine : ICache, ICacheEngine {
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

        /**
        * The default cache configuration is overridden in most cache adapters. These are
        * the keys that are common to all adapters. If overridden, this property is not used.
        *
        * - `duration` Specify how long items in this cache configuration last.
        * - `groups` List of groups or "tags" associated to every key stored in this config.
        *   handy for deleting a complete group from cache.
        * - `prefix` Prefix appended to all entries. Good for when you need to share a keyspace
        *   with either another cache config or another application.
        * - `warnOnWriteFailures` Some engines, such as ApcuEngine, may raise warnings on
        *   write failures.
        */
        
        /* if (configuration.hasKey("groups")) {
            configuration.get("groups"].sort;
            _groupPrefix = str_repeat("%s_", configuration.get("groups"].count);
        }
        if (!configuration.isNumeric("duration")) {
            configuration.get("duration") = configuration.get("duration").toTime - time();
        }*/
        
        configuration.updateDefaults([
            "duration": Json(3600),
            "groups": Json.emptyArray,
            "prefix": Json("uim_"),
            "warnOnWriteFailures": Json(true),
        ]); 

        return true;
    }

    mixin(TProperty!("string", "name"));

    /**
     * Contains the compiled string with all group
     * prefixes to be prepended to every key in this cache engine
     */
    protected string _groupPrefix = "";

    // Obtains multiple cache items by their unique keys.
    Json[string] cacheItems(string[] someKeys, Json defaultValue = Json(null)) {
        Json[string] results;
        someKeys
            .filter!(key => !key.isEmpty)
            .each!(key => results[key] = get(key, defaultValue));

        return results;
    }

    /**
     * Persists a set of key: value pairs in the cache, with an optional TTL.
     * Params:
     * range myvalues A list of key: value pairs for a multiple-set operation.
     * @param \DateInterval|int myttl Optional. The TTL value of this item. If no value is sent and
     *  the driver supports TTL then the library may set a default value
     *  for it or let the driver take care of that.
     * /
    bool cacheItems(Json[string] items, long timeToLive = 0) {
        this.ensureValidType(myvalues, self.CHECK_KEY);

        if (timeToLive != 0) {
            myrestore = configurationData.isSet("duration");
            configuration.update("duration", timeToLive);
        }
        try {
            foreach (aKey: myvalue; myvalues) {
                mysuccess = this.set(aKey, myvalue);
                if (mysuccess == false) {
                    return false;
                }
            }
            return true;
        } finally {
            if (isSet(myrestore)) {
                configuration.update("duration", myrestore);
            }
        }
    } */

    /**
     * Deletes multiple cache items as a list
     *
     * This is a best effort attempt. If deleting an item would
     * create an error it will be ignored, and all items will
     * be attempted.
     * Params:
     * string[] someKeys A list of string-based keys to be deleted.
     */
    bool removeItems(string[] someKeys) {
        return someKeys.all!(key => removeItem(key));
    }

    bool removeItem(string key) {
        if (!key.isEmpty) {
            return remove(key);
        }
    }

    /**
     * Determines whether an item is present in the cache.
     *
     * NOTE: It is recommended that has() is only to be used for cache warming type purposes
     * and not to be used within your live applications operations for get/set, as this method
     * is subject to a race condition where your has() will return true and immediately after,
     * another script can remove it making the state of your app out of date.
     * Params:
     * string aKey The cache item key.
     */
    bool has(string aKey) {
        return false;
    }

    // Fetches the value for a given key from the cache.
    Json get(string itemKey, Json defaultValue = Json(null)) {
        return Json(null);
    }

    // Persists data in the cache, uniquely referenced by the given key with an optional expiration TTL time.
    // TODO abstract bool set(string itemKey, Json valueToStore, long timeToLive = 0);

    // Increment a number under the key and return incremented value
    int increment(string itemKey, int incValue = 1) {
        return 0;
    }

    // Decrement a number under the key and return decremented value
    int decrement(string itemKey, int decValue = 1) {
        return 0;
    }

    // Delete a key from the cache
    bool remove(string itemKey) {
        return false;
    }

    // Delete all keys from the cache
    bool clear() {
        return false;
    }
    /**
     * Add a key to the cache if it does not already exist.
     *
     * Defaults to a non-atomic implementation. Subclasses should
     * prefer atomic implementations.
     * /
    bool add(string itemKey, Json dataToCache) {
        auto cachedValue = get(itemKey);
        if (cachedValue is null) {
            return _set(itemKey, dataToCache);
        }
        return false;
    }

    /**
     * Clears all values belonging to a group. Is up to the implementing engine
     * to decide whether actually delete the keys or just simulate it to achieve
     * the same result.
     * Params:
     * string mygroup name of the group to be cleared
     */
    bool clearGroup(string mygroup) {
        return false;
    }

    /**
     * Does whatever initialization for each group is required
     * and returns the `group value` for each of them, this is
     * the token representing each group in the cache key
     */
    string[] groups() {
        return null; // return configuration.get("groups"];
    }

    /**
     * Generates a key for cache backend usage.
     *
     * If the requested key is valid, the group prefix value and engine prefix are applied.
     * Whitespace in keys will be replaced.
     * Params:
     * string aKey the key passed over
     * /
    protected string _key(string aKey) {
        this.ensureValidKey(aKey);

        string myPrefix = "";
        if (_groupPrefix) {
            myPrefix = md5(join("_", this.groups()));
        }

        // auto newKey = preg_replace("/[\s]+/", "_", aKey);
        return configuration.get("prefix") ~ myPrefix ~ aKey;
    }

    /**
     * Cache Engines may trigger warnings if they encounter failures during operation,
     * if option warnOnWriteFailures is set to true.
     * /
    protected void warning(string warningMessage) {
        if (configurationData.isSet("warnOnWriteFailures") != true) {
            return;
        }
        triggerWarning(warningMessage);
    } */ 

    // Convert the various expressions of a TTL value into duration in seconds
    protected int duration(long timeToLive = 0) {
        if (timeToLive == 0) {
            return configuration.toLong("duration");
        }

        return timeToLive; 
    }
}
