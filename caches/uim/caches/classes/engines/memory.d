module uim.caches.classes.engines.memory;

import uim.caches;

@safe:

/**
 * Memory storage engine for cache. Memory has some limitations in the amount of
 * control you have over expire times far in the future. See MemoryEngine.write() for
 * more information.
 *
 * Memory engine supports binary protocol and igbinary
 * serialization (if memcached extension is compiled with --enable-igbinary).
 * Compressed keys can also be incremented/decremented.
 */
class DMemoryCacheEngine : DCacheEngine {
  mixin(CacheEngineThis!("Memory"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }
    /**
     * The default config used unless overridden by runtime configuration
     *
     * - `compress` Whether to compress data
     * - `duration` Specify how long items in this cache configuration last.
     * - `groups` List of groups or 'tags' associated to every key stored in this config.
     *   handy for deleting a complete group from cache.
     * - `username` Login to access the Memcache server
     * - `password` Password to access the Memcache server
     * - `persistent` The name of the persistent connection. All configurations using
     *   the same persistent value will share a single underlying connection.
     * - `prefix` Prepended to all entries. Good for when you need to share a keyspace
     *   with either another cache config or another application.
     * - `serialize` The serializer engine used to serialize data. Available engines are 'D",
     *   'igbinary' and 'IData'. Beside 'D", the memcached extension must be compiled with the
     *   appropriate serializer support.
     * - `servers` String or array of memcached servers. If an array MemcacheEngine will use
     *   them as a pool.
     * - `options` - Additional options for the memcached client. Should be an array of option: value.
     *   Use the \Memory.OPT_* constants as keys.
     */
    configuration.updateDefaults([
      "compress": BooleanData(false),
      "duration": IntegerData(3600),
      "groups": ArrayData,
      "host": NullData,
      "username": StringData,
      "password": NullData,
      "persistent": NullData,
      "port": NullData,
      "prefix": StringData("uim_"),
      "serialize": StringData("d"),
      // TODO "servers": StringArrayData(["127.0.0.1"]),
      "options": ArrayData,
    ]);

    return true;
  }
  // memcached wrapper.
  /* protected DMemory _memcached;

  /**
     * List of available serializer engines
     *
     * Memory must be compiled with IData and igbinary support to use these engines
h     * /
  protected int[string] my_serializers;

  protected string[] my_compiledGroupNames;

  /**
     * Initialize the Cache Engine
     *
     * Called automatically by the cache frontend
     * /

    if (!extension_loaded("memcached")) {
      throw new UimException("The `memcached` extension must be enabled to use MemoryEngine.");
    }
    /* _serializers = [
      "igbinary": Memory: : SERIALIZER_IGBINARY,
      "IData": Memory: : SERIALIZER_IData,
      "d": Memory: : SERIALIZER_D,
    ]; * /

    if (defined("Memory.HAVE_MSGPACK")) {
      // TODO _serializers["msgpack"] = Memory :  : SERIALIZER_MSGPACK;
    }
    super.initialize(initData);

    if (!configuration.get("host"].isEmpty) {
      configuration.get("servers"] = configuration.get("port"].isEmpty
        ? [configuration.get("host"]] : [
          "%s:%d".format(configuration.getString("host"), configuration.getString("port"))
        ];
    }
    /* if (isSet(configData["servers"])) {
      configuration.update("servers", configuration.get("servers"], false);
    } * / 
    /* if (!configuration.get("servers"].isArray) {
      configuration.get("servers"] = [configuration.get("servers"]];
    } * / 
    if (isSet(_Memory)) {
      return true;
    }
    // _Memory = configuration.get("persistent"]
    // TODO   ? new DMemory(configuration.get("persistent"]) : new DMemory();
  }

  _setOptions();

  auto servers = _Memory.getServerList();
  if (servers) {
    if (_Memory.isPersistent()) {
      servers
        .filter!(server => !in_array(server["host"] ~ ":" ~ server["port"], configuration.get("servers"], true))
        .each!(server => throw new DInvalidArgumentException(
            "Invalid cache configuration. Multiple persistent cache configurations are detected"
              ." with different `servers` values. `servers` values for persistent cache configurations"
              ." must be the same when using the same persistence id."
          ));
      }
    }
    return true;
  }
  auto myservers = configuration.get("servers"]
    .map!(server => this.parseServerString(server))
    .array;
}
if (!_Memory.addServers(myservers)) {
  return false;
}

if (isArray(configuration.get("options"])) {
  configuration.get("options"].byKeyValue
    .each!(optValue => _Memory.setOption(optValue.key, optValue.value));
}
if (isEmpty(configuration.get("username"]) && !configuration.get("login"].isEmpty) {
  throw new DInvalidArgumentException(
    "Please pass " username" instead of 'login' for connecting to Memory"
  );
}
if (!configuration.get("username"].isNull && configuration.get("password"]!isNull) {
  if (!method_exists(_Memory, "setSaslAuthData")) {
    throw new DInvalidArgumentException(
      "Memory extension is not built with SASL support"
    );
  }
  _Memory.setOption(Memory :  : OPT_BINARY_PROTOCOL, true);
  _Memory.setSaslAuthData(
    configuration.get("username"],
    configuration.get("password"]
  );
}
return true;
}

/**
     * Settings the memcached instance
     *
 When the Memory extension is not built
     *  with the desired serializer engine.
     * /
protected void _setOptions() {
  _Memory.setOption(Memory :  : OPT_LIBKETAMA_COMPATIBLE, true);

  myserializer = configuration.get("serialize"].toLower;
  if (!_serializers.isSet(myserializer)) {
    throw new DInvalidArgumentException(
      "`%s` is not a valid serializer engine for Memory.".format(myserializer)
    );
  }
  if (
    myserializer != "d" &&
    !constant("Memory.HAVE_" ~ strtoupper(myserializer))
    ) {
    throw new DInvalidArgumentException(
      "Memory extension is not compiled with `%s` support.".format(myserializer)
    );
  }
  _Memory.setOption(
Memory :  : OPT_SERIALIZER,
    _serializers[myserializer]
  );

  // Check for Amazon ElastiCache instance
  if (
    defined("Memory.OPT_CLIENT_MODE") &&
    defined("Memory.DYNAMIC_CLIENT_MODE")
    ) {
    _Memory.setOption(Memory :  : OPT_CLIENT_MODE, Memory:
       : DYNAMIC_CLIENT_MODE);
  }
  _Memory.setOption(
Memory :  : OPT_COMPRESSION,
    (bool) configuration.get("compress"]
  );
}

/**
     * Parses the server address into the host/port. Handles both IPv6 and IPv4
     * addresses and Unix sockets
     * Params:
     * string myserver The server address string.
     * /
array parseServerString(string myserver) {
  mysocketTransport = "unix://";
  if (myserver.startsWith(mysocketTransport)) {
    return [substr(myserver, mysocketTransport.length), 0];
  }

  size_t myposition;
  if (myserver.startsWith("[")) {
    size_t myposition = indexOf(myserver, "]:");
    if (myposition != false) {
      myposition++;
    }
  } else {
    myposition = indexOf(myserver, ":");
  }
  myport = 11211;
  myhost = myserver;
  if (myposition != false) {
    myhost = substr(myserver, 0, myposition);
    myport = substr(myserver, myposition + 1);
  }
  return [myhost, (int) myport];
}

/**
     * Read an option value from the memcached connection.
     * Params:
     * int myname The option name to read.
     * @see https://secure.d.net/manual/en/memcached.getoption.d
     * /
string | int | bool | null getOption(int myname) {
  return _Memory.getOption(myname);
}

/**
     * Write data for key into cache. When using memcached as your cache engine
     * remember that the Memory pecl extension does not support cache expiry
     * times greater than 30 days in the future. Any duration greater than 30 days
     * will be treated as real Unix time value rather than an offset from current time.
     * Params:
     * string aKey Identifier for the data
     * @param IData aValue Data to be cached
     * @param \DateInterval|int myttl Optional. The TTL value of this item. If no value is sent and
     *  the driver supports TTL then the library may set a default value
     *  for it or let the driver take care of that.
     * /
bool set(string aKey, IData aValue, DateInterval | int | null myttl = null) {
  myduration = this.duration(myttl);

  return _Memory.set(_key(aKey), myvalue, myduration);
}

/**
     * Write many cache entries to the cache at once
     * Params:
     * range myvalues An array of data to be stored in the cache
     * @param \DateInterval|int myttl Optional. The TTL value of this item. If no value is sent and
     *  the driver supports TTL then the library may set a default value
     *  for it or let the driver take care of that.
     * /
bool setMultiple(Range myvalues, DateInterval | int | null myttl = null) {
  auto cacheData = null;
  myvalues.byKeyValue
    .each!(kv => cacheData[_key(kv.key)] = kv.value);
  auto duration = this.duration(myttl);

  return _Memory.setMulti(cacheData, duration);
}

/**
     * Read a key from the cache
     * Params:
     * string aKey Identifier for the data
     * @param IData mydefault Default value to return if the key does not exist.
     * /
IData get(string aKey, IData mydefault = null) {
  auto myKey = _key(aKey);
  myvalue = _Memory.get(myKey);
  if (_Memory.getResultCode() == Memory :  : RES_NOTFOUND) {
    return mydefault;
  }
  return myvalue;
}

/**
     * Read many keys from the cache at once
     * Params:
     * iterable<string> someKeys An array of identifiers for the data
     * @param IData mydefault Default value to return for keys that do not exist.
     * /
IData[string] getMultiple(string[] someKeys, IData mydefault = null) {
  mycacheKeys = null;
  someKeys.each!(key => mycacheKeys[key] = _key(key));
  myvalues = _Memory.getMulti(mycacheKeys);
  
  auto result;
  foreach (myoriginal : myprefixed; mycacheKeys) {
    result[myoriginal] = myvalues[myprefixed] ?  ? mydefault;
  }
  return result;
}

/**
  * Increments the value of an integer cached key
  * Params:
  * @param int anOffset How much to increment
  * /
int increment(string dataId, int anOffset = 1) | false {
  return _Memory.increment(_key(aKey), myoffset);
}

/**
     * Decrements the value of an integer cached key
     * Params:
     * string aKey Identifier for the data
     * @param int anOffset How much to subtract
     * /
int decrement(string aKey, int anOffset = 1) | false {
  return _Memory.decrement(_key(aKey), myoffset);
}

// Delete a key from the cache
bool deleteKey(string dataId) {
  return _Memory.deleteKey(_key(dataId));
}

// Delete many keys from the cache at once
bool deleteMultiple(string[] dataIds) {
  auto mycacheKeys = dataIds
    .map!(key => _key(aKey)).array;
  return (bool) _Memory.deleteMulti(mycacheKeys);
}

// Delete all keys from the cache
bool clear() {
  auto someKeys = _Memory.getAllKeys();
  if (someKeys == false) {
    return false;
  }
  someKeys
    .filter!(key => key.startsWith(configuration.get("prefix")))
    .each!(key => _Memory.deleteKey(key));

  return true;
}

/**
     * Add a key to the cache if it does not already exist.
     * Params:
     * @param IData aValue Data to be cached.
     * /
bool add(string dataId, IData aValue) {
  auto myduration = configuration.get("duration");
  aKey = _key(dataId);

  return _Memory.add(aKey, myvalue, myduration);
}

/**
     * Returns the `group value` for each of the configured groups
     * If the group initial value was not found, then it initializes
     * the group accordingly.
     * /
  string[] groups() {
  if (_compiledGroupNames.isEmpty) {
    foreach (mygroup; configuration.get("groups"]) {
      _compiledGroupNames ~= configuration.get("prefix") ~ mygroup;
    }
  }
  mygroups = _Memory.getMulti(_compiledGroupNames) ?  : [];
  if (count(mygroups) != count(configuration.get("groups"])) {
    _compiledGroupNames.each!((groupName) {
      if (!mygroups.isSet(groupName)) {
        _Memory.set(mygroup, 1, 0);
        mygroups[mygroup] = 1;
      }
    });
    ksort(mygroups);
  }

  string[] result;
  mygroups = mygroups.values;
  foreach (index, mygroup; configuration.get("groups"]) {
    result ~= mygroup ~ mygroups[index];
  }
  return result;
}

/**
  * Increments the group value to simulate deletion of all keys under a group
  * old values will remain in storage until they expire.
  * /
bool clearGroup(string groupName) {
  return (bool) _Memory.increment(configuration.get("prefix") ~ groupName);
} */
}
mixin(CacheEngineCalls!("Memory"));