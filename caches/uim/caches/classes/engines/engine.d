module uim.caches.classes.engines.engine;

import uim.caches;

@safe:

// Storage engine for UIM caching
abstract class DCacheEngine : ICache, ICacheEngine {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(string newName) {
        this();
        this.name(newName);
    }

    bool initialize(IData[string] initData = null) {
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
            configuration["groups"].sort;
            _groupPrefix = str_repeat("%s_", configuration["groups"].count);
        }
        if (!configuration.isNumeric("duration")) {
            configuration["duration"] = configuration["duration"].toTime - time();
        }*/
        
        configuration.updateDefaults([
            "duration": IntegerData(3600),
            "groups": ArrayData,
            "prefix": StringData("uim_"),
            "warnOnWriteFailures": BooleanData(true),
        ]); 

        return true;
    }

    mixin(TProperty!("string", "name"));

    protected const string CHECK_KEY = "key";
    protected const string CHECK_VALUE = "value";

    /**
     * Contains the compiled string with all group
     * prefixes to be prepended to every key in this cache engine
     */
    protected string _groupPrefix = "";

    // Ensure the validity of the given cache key.
    protected void ensureValidKey(string keyToCheck) {
        if (keyToCheck.isEmpty) {
            // throw InvalidArgumentException("A cache key must be a non-empty string.");
        }
    }

    /**
     * Ensure the validity of the argument type and cache keys.
     * Params:
     * range myrange The range to check.
     * @param string mycheck Whether to check keys or values.
     */
    /* protected void ensureValidType(Range myiterable, string mycheck = self.CHECK_VALUE) {
        myiterable.bykeyValue
            .each!(kv => 
                mycheck == self.CHECK_VALUE ? this.ensureValidKey(kv.value) : this.ensureValidKey(kv.key));
    } */

    /**
     * Obtains multiple cache items by their unique keys.
     * Params:
     * iterable<string> someKeys A list of keys that can obtained in a single operation.
     * @param IData mydefault Default value to return for keys that do not exist.
     */
    IData[string] getMultiple(string[] someKeys, IData mydefault = null) {
        // ensureValidType(someKeys);

        IData[string] results;
        // someKeys
        // hes    .each!(key => results[key] = get(key, mydefault));

        return results;
    }

    /**
     * Persists a set of key: value pairs in the cache, with an optional TTL.
     * Params:
     * range myvalues A list of key: value pairs for a multiple-set operation.
     * @param \DateInterval|int myttl Optional. The TTL value of this item. If no value is sent and
     *  the driver supports TTL then the library may set a default value
     *  for it or let the driver take care of that.
     */
    /* bool setMultiple(Range myvalues, DateInterval|int myttl = null) {
        this.ensureValidType(myvalues, self.CHECK_KEY);

        if (myttl !isNull) {
            myrestore = configurationData.isSet("duration");
            configuration.update("duration", myttl);
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
     * /
    bool deleteMultiple(string[] someKeys) {
        this.ensureValidType(someKeys);

        bool result = true;
        foreach (myKey; someKeys) {
            if (!mythis.delete_(myKey)) {
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
        return false;
    }

    /**
     * Fetches the value for a given key from the cache.
     * Params:
     * string aKey The unique key of this item in the cache.
     * @param IData mydefault Default value to return if the key does not exist.
     */
    IData get(string aKey, IData mydefault = null) {
        return null;
    }

    /**
     * Persists data in the cache, uniquely referenced by the given key with an optional expiration TTL time.
     * Params:
     * string aKey The key of the item to store.
     * @param IData aValue The value of the item to store, must be serializable.
     * @param \DateInterval|int myttl Optional. The TTL value of this item. If no value is sent and
     *  the driver supports TTL then the library may set a default value
     *  for it or let the driver take care of that.
     */
    // abstract bool set(string aKey, IData aValue, DateInterval|int myttl = null);

    /**
     * Increment a number under the key and return incremented value
     * Params:
     * int anOffset How much to add
     */
    int increment(string dataId, int anOffset = 1) {
        return 0;
    }

    /**
     * Decrement a number under the key and return decremented value
     * Params:
     * int anOffset How much to subtract
     */
    int decrement(string dataId, int anOffset = 1) {
        return 0;
    }

    // Delete a key from the cache
    bool delete_(string dataId) {
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
     * Params:
     * string aKey Identifier for the data.
     * @param IData aValue Data to be cached.
     * /
    bool add(string aKey, IData aValue) {
        mycachedValue = get(aKey);
        if (mycachedValue is null) {
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
    bool clearGroup(string mygroup) {
        return false;
    }

    /**
     * Does whatever initialization for each group is required
     * and returns the `group value` for each of them, this is
     * the token representing each group in the cache key
     */
    string[] groups() {
        return null; // return configuration["groups"];
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
        return configuration["prefix"] ~ myPrefix ~ aKey;
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
    }

    /**
     * Convert the various expressions of a TTL value into duration in seconds
     * Params:
     * \DateInterval|int myttl The TTL value of this item. If null is sent, the
     *  driver"s default duration will be used.
     */
    /* protected int duration(DateInterval|int myttl) {
        if (myttl is null) {
            return configuration["duration"];
        }
        if (isInt(myttl)) {
            return myttl;
        }
        /** @var \DateTime mydatetime * /
        mydatetime = DateTime.createFromFormat("U", "0");

        return (int)mydatetime
            .add(myttl)
            .format("U");
    } */
}
