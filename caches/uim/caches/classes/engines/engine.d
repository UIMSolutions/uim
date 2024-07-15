module uim.caches.classes.engines.engine;

import uim.caches;

@safe:

// Storage engine for UIM caching
class DCacheEngine : UIMObject, ICache, ICacheEngine {
    mixin(CacheEngineThis!(""));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

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

    // Group prefixes to be prepended to every key in this cache engine
    mixin(TProperty!("string", "groupName"));

    // #region items
    // Obtains multiple cache items by their unique keys.
    void items(Json[string] newItems, long timeToLive = 0) {
        clear();
        update(newItems.dup, timeToLive);
    }

    Json[string] items(string[] keysToUse = null) {
        if (keysToUse.isEmpty) {
            return items(keys);
        }

        Json[string] results;
        keysToUse
            .each!((key) {
                if (auto item = read(key)) {
                    results.set(key, item);
                }
            });

        return results;
    }

    string[] keys() {
        return null;
    }

    // Persists a set of key: value pairs in the cache, with an optional TTL.
    /*        bool items(Json[string] items, long timeToLive = 0) {
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
        } */
    // #region items

    // #region read
    // Fetches the value for a given key from the cache.
    Json[] read(string[] keys, Json defaultValue = Json(null)) {
        return keys.map!(key => read(key, defaultValue)).array;
    }

    Json read(string key, Json defaultValue = Json(null)) {
        return Json(null);
    }

    // #endregion read

    // #region update
    // Persists data in the cache, uniquely referenced by the given key with an optional expiration timeToLive time.
    bool update(Json[string] items, long timeToLive = 0) {
        return items.byKeyValue
            .all!(kv => update(kv.key, kv.value, timeToLive));
    }

    bool update(string key, Json value, long timeToLive = 0) {
        return false;
    }
    // #endregion update

    // Increment a number under the key and return incremented value
    long increment(string key, int incValue = 1) {
        return 0;
    }
    // Decrement a number under the key and return decremented value
    long decrement(string key, int decValue = 1) {
        return 0;
    }

    // Merge an item (key, value) to the cache if it does not already exist.
    bool merge(string key, Json value, long timeToLive = 0) {
        return read(key).isNull
            ? update(key, value, timeToLive) : false;
    }

    // #region remove
    // Delete all keys from the cache
    bool clear() {
        return remove(keys);
    }

    // Deletes multiple cache items as a list
    bool remove(string[] keys) {
        return keys.all!(key => remove(key));
    }

    // Delete a key from the cache
    bool remove(string key) {
        return false;
    }
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
        string prefix = groupName
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
        if (!configuration.getBoolean("warnOnWriteFailures")) {
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
