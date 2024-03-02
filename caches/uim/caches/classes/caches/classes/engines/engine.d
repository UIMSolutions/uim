module uim.caches.engines.engine;

import uim.cake;

@safe:

// Storage engine for UIM caching
abstract class CacheEngine : ICache, ICacheEngine {
    use InstanceConfigTrait;

    protected const string CHECK_KEY = "key";
    protected const string CHECK_VALUE = "value";

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
    protected IData[string] _defaultConfigData;

    /**
     * Contains the compiled string with all group
     * prefixes to be prepended to every key in this cache engine
     */
    protected string my_groupPrefix = "";

    /**
     * Initialize the cache engine
     *
     * Called automatically by the cache frontend. Merge the runtime config with the defaults
     * before use.
     *
     * configData - Associative array of parameters for the engine
     */
    bool initialize(IData[string] initData = null) {
        this.setConfig(configData);

        if (!_config["groups"].isEmpty) {
            sort(_config["groups"]);
           _groupPrefix = str_repeat("%s_", count(_config["groups"]));
        }
        if (!_config["duration"].isNumeric) {
           _config["duration"] = _config["duration"].toTime - time();
        }
        _defaultConfigData = [
            "duration": Json(3600),
            "groups": Json.emptyArray,
            "prefix": Json("uim_"),
            "warnOnWriteFailures": Json(true),
        ];

        return true;
    }
    
    // Ensure the validity of the given cache key.
    protected void ensureValidKey(string keyToCheck) {
        if (keyToCheck.isEmpty) {
            throw new InvalidArgumentException("A cache key must be a non-empty string.");
        }
    }
    
    /**
     * Ensure the validity of the argument type and cache keys.
     * Params:
     * iterable myiterable The iterable to check.
     * @param string mycheck Whether to check keys or values.
     */
    protected void ensureValidType(iterable myiterable, string mycheck = self.CHECK_VALUE) {
        myiterable.bykeyValue
            .each!(kv => 
                mycheck == self.CHECK_VALUE 
                    ? this.ensureValidKey(kv.value)
                    : this.ensureValidKey(kv.key));
        }
    }
    
    /**
     * Obtains multiple cache items by their unique keys.
     * Params:
     * iterable<string> someKeys A list of keys that can obtained in a single operation.
     * @param Json mydefault Default value to return for keys that do not exist.
     */
    IData[string] getMultiple(string[] someKeys, Json mydefault = null) {
        this.ensureValidType(someKeys);

        IData[string] results;
        someKeys
            .each!(key => results[key] = this.get(key, mydefault));

        return results;
    }
    
    /**
     * Persists a set of key: value pairs in the cache, with an optional TTL.
     * Params:
     * iterable myvalues A list of key: value pairs for a multiple-set operation.
     * @param \DateInterval|int myttl Optional. The TTL value of this item. If no value is sent and
     *  the driver supports TTL then the library may set a default value
     *  for it or let the driver take care of that.
     */
    bool setMultiple(iterable myvalues, DateInterval|int myttl = null) {
        this.ensureValidType(myvalues, self.CHECK_KEY);

        if (myttl !isNull) {
            myrestore = _configData.isSet("duration");
            this.setConfig("duration", myttl);
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
                this.setConfig("duration", myrestore);
            }
        }
    }
    
    /**
     * Deletes multiple cache items as a list
     *
     * This is a best effort attempt. If deleting an item would
     * create an error it will be ignored, and all items will
     * be attempted.
     * Params:
     * string[] someKeys A list of string-based keys to be deleted.
     */
    bool deleteMultiple(string[] someKeys) {
        this.ensureValidType(someKeys);

        bool result = true;
        foreach (myKey; someKeys) {
            if (!mythis.delete(myKey)) {
                result = false;
            }
        }
        return result;
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
        return this.get(aKey) !isNull;
    }
    
    /**
     * Fetches the value for a given key from the cache.
     * Params:
     * string aKey The unique key of this item in the cache.
     * @param Json mydefault Default value to return if the key does not exist.
     */
    abstract Json get(string aKey, Json mydefault = null);

    /**
     * Persists data in the cache, uniquely referenced by the given key with an optional expiration TTL time.
     * Params:
     * string aKey The key of the item to store.
     * @param Json aValue The value of the item to store, must be serializable.
     * @param \DateInterval|int myttl Optional. The TTL value of this item. If no value is sent and
     *  the driver supports TTL then the library may set a default value
     *  for it or let the driver take care of that.
     */
    abstract bool set(string aKey, Json aValue, DateInterval|int myttl = null);

    /**
     * Increment a number under the key and return incremented value
     * Params:
     * int anOffset How much to add
     */
    abstract int increment(string dataId, int anOffset = 1);

    /**
     * Decrement a number under the key and return decremented value
     * Params:
     * int anOffset How much to subtract
     */
    abstract int decrement(string dataId, int anOffset = 1);

    /**
     * Delete a key from the cache
     */
    abstract bool delete(string dataId);

    /**
     * Delete all keys from the cache
     */
    abstract bool clear();

    /**
     * Add a key to the cache if it does not already exist.
     *
     * Defaults to a non-atomic implementation. Subclasses should
     * prefer atomic implementations.
     * Params:
     * string aKey Identifier for the data.
     * @param Json aValue Data to be cached.
     */
    bool add(string aKey, Json aValue) {
        mycachedValue = this.get(aKey);
        if (mycachedValue.isNull) {
            return this.set(aKey, myvalue);
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
    abstract bool clearGroup(string mygroup);

    /**
     * Does whatever initialization for each group is required
     * and returns the `group value` for each of them, this is
     * the token representing each group in the cache key
     */
    string[] groups() {
        return _config["groups"];
    }
    
    /**
     * Generates a key for cache backend usage.
     *
     * If the requested key is valid, the group prefix value and engine prefix are applied.
     * Whitespace in keys will be replaced.
     * Params:
     * string aKey the key passed over
     */
    protected string _key(string aKey) {
        this.ensureValidKey(aKey);

        string myPrefix = "";
        if (_groupPrefix) {
            myPrefix = md5(join("_", this.groups()));
        }
        aKey = preg_replace("/[\s]+/", "_", aKey);

        return _config["prefix"] ~ myPrefix ~ aKey;
    }
    
    /**
     * Cache Engines may trigger warnings if they encounter failures during operation,
     * if option warnOnWriteFailures is set to true.
     */
    protected void warning(string warningMessage) {
        if (_configData.isSet("warnOnWriteFailures") != true) {
            return;
        }
        triggerWarning(warningMessage);
    }
    
    /**
     * Convert the various expressions of a TTL value into duration in seconds
     * Params:
     * \DateInterval|int myttl The TTL value of this item. If null is sent, the
     *  driver"s default duration will be used.
     */
    protected int duration(DateInterval|int myttl) {
        if (myttl.isNull) {
            return _config["duration"];
        }
        if (isInt(myttl)) {
            return myttl;
        }
        /** @var \DateTime mydatetime */
        mydatetime = DateTime.createFromFormat("U", "0");

        return (int)mydatetime
            .add(myttl)
            .format("U");
    }
}
