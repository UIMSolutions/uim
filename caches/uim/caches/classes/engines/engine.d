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

    /**
     * Contains the compiled string with all group
     * prefixes to be prepended to every key in this cache engine
     */
    protected string _groupPrefix = "";

    // Obtains multiple cache items by their unique keys.
    Json[string] cacheItems(string[] keys, Json defaultValue = Json(null)) {
        Json[string] results;
        keys
            .filter!(key => !key.isEmpty)
            .each!(key => results[key] = get(key, defaultValue));

        return results;
    }

    // Persists a set of key: value pairs in the cache, with an optional TTL.
    bool cacheItems(Json[string] items, long timeToLive = 0) {
        // TODO ensureValidType(myvalues, CHECK_KEY);

        Json restoreDuration = Json(null); 
        if (timeToLive != 0) {
            restoreDuration = configuration.hasKey("duration");
            configuration.set("duration", timeToLive);
        }
/*         try {
            return myvalues.byKeyValue.all!(kv => set(aKey, myvalue));
        } finally {
            if (!restoreDuration.isNull) {
                configuration.set("duration", restoreDuration);
            }
        }
 */        return false;
    }

    // Deletes multiple cache items as a list
    bool removeKeys(string[] keys...) {
        return removeKeys(keys.dup);
    }

    bool removeKeys(string[] keys) {
        return keys.all!(key => remove(key));
    }

    bool remove(string key) {
        if (!key.isEmpty) {
            // TODO remove(key);
            return true;
        }
        return false;
    }

    /**
     * Determines whether an item is present in the cache.
     *
     * NOTE: It is recommended that has() is only to be used for cache warming type purposes
     * and not to be used within your live applications operations for get/set, as this method
     * is subject to a race condition where your has() will return true and immediately after,
     * another script can remove it making the state of your app out of date.
     */
    bool has(string itemKey) {
        return false;
    }

    // Fetches the value for a given key from the cache.
    Json get(string itemKey, Json defaultValue = Json(null)) {
        return Json(null);
    }

    // Persists data in the cache, uniquely referenced by the given key with an optional expiration TTL time.
    abstract bool set(string itemKey, Json valueToStore, long timeToLive = 0);

    // Increment a number under the key and return incremented value
    long increment(string itemKey, int incValue = 1) {
        return 0;
    }

    // Decrement a number under the key and return decremented value
    long decrement(string itemKey, int decValue = 1) {
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
     */
    bool add(string itemKey, Json dataToCache) {
        auto cachedValue = get(itemKey);
        return cachedValue.isNull
            ? set(itemKey, dataToCache) : false;
    }

    /**
     * Clears all values belonging to a group. Is up to the implementing engine
     * to decide whether actually delete the keys or just simulate it to achieve the same result.
     */
    bool clearGroup(string groupName) {
        return false;
    }

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
    protected string internalKey(string itemKey) {
        string prefix = _groupPrefix
            ? groups().join("_") //TODO md5(groups().join("_"))
             : "";

        // TODO auto changedKey = itemKey.replaceAll.regex(r"/[\s]+/", "_");
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
