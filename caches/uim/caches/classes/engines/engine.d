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
        this().name(newName);
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
        *  handy for deleting a complete group from cache.
        * - `prefix` Prefix appended to all entries. Good for when you need to share a keyspace
        *  with either another cache config or another application.
        * - `warnOnWriteFailures` Some engines, such as ApcuEngine, may raise warnings on
        *  write failures.
        */

        if (configuration.hasKey("groups")) {
            configuration.getStringArray("groups").sort;
            // TODO _groupPrefix = str_repeat("%s_", configuration.getStringArray("groups").length);
        }
        /* if (!configuration.isNumeric("duration")) {
            // TODO configuration.set("duration", configuration.get("duration").toTime - time());
        } */

        configuration.updateDefaults([
            "duration": Json(3600),
            "groups": Json.emptyArray,
            "prefix": Json("uim_"),
            "warnOnWriteFailures": true.toJson,
        ]);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // Group prefixes to be prepended to every key in this cache engine
    mixin(TPropery!("string", "groupName"));

    // #region items
        // Obtains multiple cache items by their unique keys.
        void items(Json[string] itemData, long timeToLive = 0) {
            merge(itemData, timeToLive);
        }

        Json[string] items(string[] keys) {
            Json[string] results;
            keys
                .filter!(key => !key.isEmpty)
                .each!(key => results[key] = get(key));

            return results;
        }

        // Persists a set of key: value pairs in the cache, with an optional TTL.
        bool items(Json[string] items, long timeToLive = 0) {
            // TODO ensureValidType(myvalues, CHECK_KEY);

            Json restoreDuration = Json(null); 
            if (timeToLive != 0) {
                restoreDuration = configuration.hasKey("duration");
                configuration.set("duration", timeToLive);
            }
            try {
                return items.byKeyValue
                    .all!(kv => update(aKey, myvalue));
            } finally {
                if (restoreDuration.isNull) {
                    configuration.set("duration", restoreDuration);
                }
            }
            return false;
        }
    // #region items

    // Fetches the value for a given key from the cache.
    Json[] get(string[] keys, Json defaultValue = Json(null)) {
        return keys.map!(key => get(key, defaultValue)).array;
    }
    abstract Json get(string key, Json defaultValue = Json(null));

    // Persists data in the cache, uniquely referenced by the given key with an optional expiration TTL time.
    bool update(Json[string] items, long timeToLive = 0) {
        return items.byKeyValue
            .all!(kv => update(aKey, myvalue));
    }
    abstract bool update(string key, Json value, long timeToLive = 0);

    // Increment a number under the key and return incremented value
    abstract long increment(string key, int incValue = 1); 

    // Decrement a number under the key and return decremented value
    abstract long decrement(string key, int decValue = 1);

    // Merge an item (key, value) to the cache if it does not already exist.
    bool merge(string key, Json value) {
        auto cachedValue = get(key);
        return cachedValue.isNull
            ? set(key, value) : false;
    }

    // #region remove
        // Delete all keys from the cache
        bool clear() {
            return removeItems(keys);
        }

        // Deletes multiple cache items as a list
        bool removeItems(string[] keys) {
            return keys.all!(key => removeItem(key));
        }

        // Delete a key from the cache
        abstract bool removeItem(string key); 
    // #endregion remove


    /**
     * Clears all values belonging to a group. Is up to the implementing engine
     * to decide whether actually delete the keys or just simulate it to achieve the same result.
     */
    abstract bool clearGroup(string groupName); 

    /**
     * Does whatever initialization for each group is required and returns the `group value` for each of them, 
     * this is the token representing each group in the cache key
     */
    string[] groups() {
        return configuration.getStringArray("groups");
    }

    /**
     * Generates a key for cache backend usage.
     *
     * If the requested key is valid, the group prefix value and engine prefix are applied.
     * Whitespace in keys will be replaced.
     */
    protected string internalKey(string key) {
        string prefix = _groupPrefix
            ? groups().join("_") //TODO md5(groups().join("_"))
             : "";

        // TODO auto changedKey = key.replaceAll.regex(r"/[\s]+/", "_");
        return configuration.getString("prefix") ~ prefix; //  ~ changedKey;
    }

    /**
     * Cache Engines may trigger warnings if they encounter failures during operation,
     * if option warnOnWriteFailures is set to true.
     */
    protected void warning(string warningMessage) {
        if (!configuration.getBool("warnOnWriteFailures")) {
            return;
        }
        // TODO triggerWarning(warningMessage);
    }

    // Convert the various expressions of a TTL value into duration in seconds
    protected long duration(long timeToLive = 0) {
        return timeToLive == 0
            ? configuration.getLong("duration") : timeToLive;
    }
}
