module uim.caches.classes.engines.redis;

import uim.caches;

@safe:
// Redis storage engine for cache.
class DRedisCacheEngine : DCacheEngine {
    mixin(CacheEngineThis!("Redis")); 

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        /**
        * The default config used unless overridden by runtime configuration
        *
        * - `database` database number to use for connection.
        * - `duration` Specify how long items in this cache configuration last.
        * - `groups` List of groups or 'tags' associated to every key stored in this config.
        *   handy for deleting a complete group from cache.
        * - `password` Redis server password.
        * - `persistent` Connect to the Redis server with a persistent connection
        * - `port` port number to the Redis server.
        * - `prefix` Prefix appended to all entries. Good for when you need to share a keyspace
        *   with either another cache config or another application.
        * - `scanCount` Number of keys to ask for each scan (default: 10)
        * - `server` URL or IP to the Redis server host.
        * - `timeout` timeout in seconds (float).
        * - `unix_socket` Path to the unix socket file (default: false)
        *
        */

        // TODO
        /* if (!extension_loaded("redis")) {
            throw new UimException("The `redis` extension must be enabled to use RedisEngine.");
        } */
        
        if (auto host = initData.get("host", null)) {
            initData["server"] = host;
        } 

        configuration.updateDefaults([
            "database": IntegerData(0),
            "duration": IntegerData(3600),
            "groups": ArrayData,
            "password": BooleanData(false),
            "persistent": BooleanData(true),
            "port": IntegerData(6379),
            "prefix": StringData("uim_"),
            "host": null,
            "server": StringData("127.0.0.1"),
            "timeout": IntegerData(0),
            "unix_socket": BooleanData(false),
            "scanCount": IntegerData(10)
        ]);

        return true;
        // TODO return _connect();
    }

    // Redis wrapper.
    /*
    protected Redis _redis;
    
    // Connects to a Redis server
    protected bool _connect() {
        try {
           _redis = new DRedis();
            if (!configuration["unix_socket"].isEmpty) {
                result = _redis.connect(configuration["unix_socket"]);
            } elseif (configuration["persistent"].isEmpty) {
                result = _redis.connect(
                   configuration["server"],
                    configuration["port"].toInt,
                    configuration["timeout"].toInt
                );
            } else {
                persistentId = configuration["port"] ~ configuration["timeout"] ~ configuration["database"];
                result = _redis.pconnect(
                   configuration["server"],
                    configuration["port"].toInt,
                    configuration["timeout"].toInt,
                    persistentId
                );
            }
        } catch (RedisException  anException) {
            if (class_exists(Log.classname)) {
                Log.error("RedisEngine could not connect. Got error: " ~  anException.getMessage());
            }
            return false;
        }
        if (result && configuration["password"]) {
            result = _redis.auth(configuration["password"]);
        }
        if (result) {
            result = _redis.select((int)configuration["database"]);
        }
        return result;
    }
    
    /**
     * Write data for key into cache.
     * Params:
     * string aKey Identifier for the data
     * @param IData aValue Data to be cached
     * @param \DateInterval|int  aTtl Optional. The TTL value of this item. If no value is sent and
     *  the driver supports TTL then the library may set a default value
     *  for it or let the driver take care of that.
     * /
    bool set(string aKey, IData aValue, DateInterval|int  aTtl = null) {
        auto myKey = _key(aKey);
        autoaValue = this.serialize(aValue);

        auto myDuration = this.duration(aTtl);
        if (myDuration == 0) {
            return _redis.set(myKey, aValue);
        }
        return _redis.setEx(myKey, myDuration, aValue);
    }
    
    /**
     * Read a key from the cache
     * Params:
     * string aKey Identifier for the data
     * @param IData defaultValue Default value to return if the key does not exist.
     * /
    IData get(string aKey, IData defaultValue = null) {
        aValue = _redis.get(_key(aKey));
        if (aValue == false) {
            return defaultValue;
        }
        return this.unserialize(aValue);
    }
    
    /**
     * Increments the value of an integer cached key & update the expiry time
     * Params:
     * string aKey Identifier for the data
     * @param int anOffset How much to increment
     * /
    int increment(string aKey, int anOffset = 1) {
         aDuration = configuration["duration"];
        aKey = _key(aKey);

        aValue = _redis.incrBy(aKey,  anOffset);
        if (aDuration > 0) {
           _redis.expire(aKey,  aDuration);
        }
        return aValue;
    }
    
    /**
     * Decrements the value of an integer cached key & update the expiry time
     * Params:
     * string aKey Identifier for the data
     * @param int anOffset How much to subtract
     * /
    int|false decrement(string aKey, int anOffset = 1) {
         aDuration = configuration["duration"];
        aKey = _key(aKey);

        aValue = _redis.decrBy(aKey,  anOffset);
        if (aDuration > 0) {
           _redis.expire(aKey,  aDuration);
        }
        return aValue;
    }
    
    /**
     * Delete a key from the cache
     * Params:
     * string aKey Identifier for the data
     * /
    bool delete_(string dataIdentifier) {
        auto key = _key(dataIdentifier);

        return _redis.del(key) > 0;
    }
    
    /**
     * Delete a key from the cache asynchronously
     *
     * Just unlink a key from the cache. The actual removal will happen later asynchronously.
     * /
    bool deleteAsync(string dataIdentifier) {
        auto key = _key(dataId);
        return _redis.unlink(key) > 0;
    }
    
    // Delete all keys from the cache
    bool clear() {
       _redis.setOption(Redis.OPT_SCAN, to!string(Redis.SCAN_RETRY));

        auto isAllDeleted = true;
        auto  anIterator = null;
        auto  somePattern = configuration["prefix"] ~ "*";

        while (true) {
            keys = _redis.scan(anIterator,  somePattern, (int)configuration["scanCount"]);

            if (someKeys == false) {
                break;
            }
            someKeys.each!((key) {
                 isDeleted = (_redis.del(aKey) > 0);
                 isAllDeleted =  isAllDeleted &&  isDeleted;
            });
        }
        return isAllDeleted;
    }
    
    /**
     * Delete all keys from the cache by a blocking operation
     *
     * Faster than clear() using unlink method.
     * /
    bool clearBlocking() {
       _redis.setOption(Redis.OPT_SCAN, (string)Redis.SCAN_RETRY);

        bool isAllDeleted = true;
         anIterator = null;
         somePattern = configuration["prefix"] ~ "*";

        while (true) {
            someKeys = _redis.scan(anIterator,  somePattern, (int)configuration["scanCount"]);

            if (someKeys == false) {
                break;
            }
            someKeys.each!((key) {
                bool isDeleted = (_redis.unlink(key) > 0);
                isAllDeleted =  isAllDeleted &&  isDeleted;
            });
        }
        return isAllDeleted;
    }
    
    /**
     * Write data for key into cache if it doesn`t exist already.
     * If it already exists, it fails and returns false.
     * Params:
     * string aKey Identifier for the data.
     * @param IData aValue Data to be cached.
     * /
    bool add(string aKey, IData aValue) {
         aDuration = configuration["duration"];
        aKey = _key(aKey);
        aValue = this.serialize(aValue);

        if (_redis.set(aKey, aValue, ["nx", "ex":  aDuration])) {
            return true;
        }
        return false;
    }
    
    /**
     * Returns the `group value` for each of the configured groups
     * If the group initial value was not found, then it initializes
     * the group accordingly.
     * /
    string[] groups() {
        auto result;
        foreach (configuration["groups"] as  anGroup) {
            aValue = _redis.get(configuration["prefix"] ~  anGroup);
            if (!aValue) {
                aValue = this.serialize(1);
               _redis.set(configuration["prefix"] ~  anGroup, aValue);
            }
            result ~=  anGroup ~ aValue;
        }
        return result;
    }
    
    /**
     * Increments the group value to simulate deletion of all keys under a group
     * old values will remain in storage until they expire.
     * Params:
     * string agroup name of the group to be cleared
         * /
    bool clearGroup(string agroup) {
        return (bool)_redis.incr(configuration["prefix"] ~  anGroup);
    }
    
    /**
     * Serialize value for saving to Redis.
     *
     * This is needed instead of using Redis' in built serialization feature
     * as it creates problems incrementing/decrementing intially set integer value.
     * Params:
     * IData aValue Value to serialize.
     * /
    protected string serialize(IData aValue) {
        if (isInt(aValue)) {
            return to!string(aValue;
        }
        return serialize(aValue);
    }
    
    /**
     * Unserialize string value fetched from Redis.
     * Params:
     * string avalue Value to unserialize.
     * /
    protected IData unserialize(string avalue) {
        if (preg_match("/^[-]?\d+$/", aValue)) {
            return (int)aValue;
        }
        return unserialize(aValue);
    }
    
    /**
     * Disconnects from the redis server
     * /
    auto __destruct() {
        if (isEmpty(configuration["persistent"])) {
           _redis.close();
        }
    } */
}
    mixin(CacheEngineCalls!("Redis")); 
