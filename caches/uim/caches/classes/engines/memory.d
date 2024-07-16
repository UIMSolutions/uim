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

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }
    /**
     * The default config used unless overridden by runtime configuration
     *
     * - `compress` Whether to compress data
     * - `duration` Specify how long items in this cache configuration last.
     * - `groups` List of groups or 'tags' associated to every key stored in this config.
     *  handy for deleting a complete group from cache.
     * - `username` Login to access the Memcache server
     * - `password` Password to access the Memcache server
     * - `persistent` The name of the persistent connection. All configurations using
     *  the same persistent value will share a single underlying connection.
     * - `prefix` Prepended to all entries. Good for when you need to share a keyspace
     *  with either another cache config or another application.
     * - `serialize` The serializer engine used to serialize data. Available engines are 'D",
     *  'igbinary' and 'Json'. Beside 'D", the memcached extension must be compiled with the
     *  appropriate serializer support.
     *  Use the \Memory.OPT_* constants as keys.
     */
    configuration.updateDefaults([
      "compress": false.toJson,
      "duration": 3600.toJson,
      "groups": Json.emptyArray,
      "host": Json(null),
      "username": "".toJson,
      "password": Json(null),
      "persistent": Json(null),
      "port": Json(null),
      "prefix": Json("uim_"),
      "serialize": Json("d"),
      // `servers` String or array of memcached servers. If an array MemcacheEngine will use them as a pool.
      "servers": ["127.0.0.1"].toJson,
      // `options` - Additional options for the memcached client. Should be an array of option: value.
      "options": Json.emptyArray,
    ]);

    return true;
  }

  // List of available serializer engines
  // Memory must be compiled with Json and igbinary support to use these engines
  protected int[string] _serializers;

  protected string[] _compiledGroupNames;
  protected Json[string] _memory;
  /* protected DMemory _memcached;*/

  override string[] keys() {
    // TODO wrong these are the internal Keys
    return _memory.keys;
  }

  /**
     * Initialize the Cache Engine
     *
     * Called automatically by the cache frontend
     * /

    if (!extension_loaded("memcached")) {
      throw new DException("The `memcached` extension must be enabled to use MemoryEngine.");
    }
    /* _serializers = [
      "igbinary": Memory: : SERIALIZER_IGBINARY,
      "Json": Memory: : SERIALIZER_Json,
      "d": Memory: : SERIALIZER_D,
    ]; */
  /*
    if (defined("Memory.HAVE_MSGPACK")) {
      // TODO _serializers["msgpack"] = Memory.SERIALIZER_MSGPACK;
    }
    super.initialize(initData);

    if (!configuration.isEmpty("host")) {
      configuration.get("servers") = configuration.isEmpty("port")
        ? [configuration.get("host")] : [
          "%s:%d".format(configuration.getString("host"), configuration.getString("port"))
        ];
    }
    /* if (configData.hasKey("servers")) {
      configuration.set("servers", configuration.get("servers"], false);
    } */
  /* if (!configuration.isArray("servers")) {
      configuration.set("servers", [configuration.get("servers")]);
    } * / 
    if (!_memory is null) {
      return true;
    }
    // _memory = configuration.get("persistent"]
    // TODO ? new DMemory(configuration.get("persistent"]) : new DMemory();
    
  }

  _setOptions();

  string[] serversFromConfig = configuration.get("servers");
  if (auto servers = _memory.getServerList()) {
    if (_memory.isPersistent()) {
      servers
        .filter!(server => !server.getString("host") ~ ": " ~ server.getString("port").isIn(serversFromConfig))
        .each!(server => throw new DInvalidArgumentException(
            "Invalid cache configuration. Multiple persistent cache configurations are detected" ~
            " with different `servers` values. `servers` values for persistent cache configurations" ~
            " must be the same when using the same persistence id."
         ));
      }
    }
    return true;
  }
  serversFromConfig
    .map!(server => parseServerString(server))
    .array;
}
if (!_memory.addServers(myservers)) {
  return false;
}

if (configuration.isArray("options"]) {
  configuration.get("options"].byKeyValue
    .each!(optValue => _memory.setOption(optValue.key, optValue.value));
}
if (configuration.isEmpty("username"] && !configuration.isEmpty("login")) {
  throw new DInvalidArgumentException(
    "Please pass " username" instead of 'login' for connecting to Memory"
 );
}
if (configuration.hasKeys("username", "password")) {
  if (!method_exists(_memory, "setSaslAuthData")) {
    throw new DInvalidArgumentException(
      "Memory extension is not built with SASL support"
   );
  }
  _memory.setOption(Memory.OPT_BINARY_PROTOCOL, true);
  _memory.setSaslAuthData(
    configuration.getString("username"),
    configuration.getString("password")
 );
}
return true;
}

/**
     * Settings the memcached instance
     * When the Memory extension is not built
     * with the desired serializer engine.
     */
  protected void _setOptions() {
    // _memory.setOption(Memory.OPT_LIBKETAMA_COMPATIBLE, true);

    string myserializer = configuration.getString("serialize").lower;
    if (!_serializers.hasKey(myserializer)) {
      throw new DInvalidArgumentException(
        "`%s` is not a valid serializer engine for Memory.".format(myserializer)
      );
    }
    /*    if (myserializer != "d" && !constant("Memory.HAVE_" ~ myserializer.upper)) {
      throw new DInvalidArgumentException(
        "Memory extension is not compiled with `%s` support.".format(myserializer)
     ); */
  }

  /* _memory.setOption(
    Memory.OPT_SERIALIZER,
    _serializers[myserializer]
  );  */
  // Check for Amazon ElastiCache instance
  /* if (
    defined("Memory.OPT_CLIENT_MODE") &&
    defined("Memory.DYNAMIC_CLIENT_MODE")
    ) {
    _memory.setOption(Memory.OPT_CLIENT_MODE, Memory.DYNAMIC_CLIENT_MODE);
  } */

  /* _memory.setOption(
    Memory.OPT_COMPRESSION,
    configuration.getBoolean("compress")
  ); 
}*/

  /**
     * Parses the server address into the host/port. Handles both IPv6 and IPv4
     * addresses and Unix sockets
     * Params:
     * string myserver The server address string.
     */
  /* Json[string] parseServerString(string myserver) {
    auto mysocketTransport = "unix://";
    /* if (myserver.startsWith(mysocketTransport)) {
      return [subString(myserver, mysocketTransport.length), 0];
    } * /

    /* size_t myposition;
    if (myserver.startsWith("[")) {
      size_t myposition = indexOf(myserver, "]:");
      if (myposition == true) {
        myposition++;
      }
    } else {
      myposition = indexOf(myserver, ": ");
    }
    auto myport = 11211;
    auto myhost = myserver;
    if (myposition == true) {
      myhost = subString(myserver, 0, myposition);
      myport = subString(myserver, myposition + 1);
    }
    return [
      myhost, /* (int)  * / myport
    ]; 
  } */

  /**
     * Read an option value from the memcached connection.
     * Params:
     * int myname The option name to read.
     */
  /* Json getOption(string myname) {
    return _memory.get(myname);
  } */

  /**
     * Write data for key into cache. When using memcached as your cache engine
     * remember that the Memory pecl extension does not support cache expiry
     * times greater than 30 days in the future. Any duration greater than 30 days
     * will be treated as real Unix time value rather than an offset from current time.
     */
  override bool update(string itemKey, Json dataToCache, long timeToLive = 0) {
      return false;
      // TODO 
    // return _memory.set(internalKey(itemKey), dataToCache, duration(timeToLive));
  }

override bool merge(Json[string] items, long timeToLive = 0) {
    Json[string] cacheData = null;
    items.byKeyValue
      .each!(kv => cacheData.set(internalKey(kv.key), kv.value));
    // TODOreturn _memory.merge(cacheData, duration(timeToLive));
    return false; 
  } 

  // Write many cache entries to the cache at once
  /*  override bool update(Json[string] items, long timeToLive = 0) {
    Json[string] cacheData = null;
    items.byKeyValue
      .each!(kv => cacheData[internalKey(kv.key)] = kv.value);
    return _memory.set(cacheData); //, duration(timeToLive));
  } */

  // Read a key from the cache
  override Json read(string key, Json defaultValue = Json(null)) {
    string internKey = internalcorrectKey(key);
    // TODO auto myvalue = _memory.get(internKey);
    /* return _memory.getResultCode() == Memory.RES_NOTFOUND
      ? defaultValue : myvalue; */
    return Json(null);
  }

  // Increments the value of an integer cached key
  override long increment(string key, int incValue = 1) {
    return 1;
    // TODO return _memory.set(internalcorrectKey(key), _memory.getLong(internalcorrectKey(key)) + incValue);
  }

  // Decrements the value of an integer cached key
  override long decrement(string key, int decValue = 1) {
    return 0;
    // TODO return _memory.set(internalcorrectKey(key), _memory.getLong(internalcorrectKey(key)) - decValue);
  }

  // Delete a key from the cache
  override bool remove(string key) {
    return _memory.remove(internalcorrectKey(key));
  }

  // Delete all keys from the cache
  override bool clear() {
    string prefix = configuration.getString("prefix");
/*    _memory.getAllKeys()
      .filter!(key => key.startsWith(prefix))
      .each!(key => _memory.remove(key)); */
    return true;
  }

  // Add a key to the cache if it does not already exist.
/*  override bool merge(string key, Json value, long timeToLive = 0) {
    auto internKey = internalcorrectKey(key);
    return _memory.add(internKey, value, duration);
  } */

  /**
     * Returns the `group value` for each of the configured groups
     * If the group initial value was not found, then it initializes the group accordingly.
     */
  override string[] groups() {
    /* if (_compiledGroupNames.isEmpty) {
      _compiledGroupNames = configuration.getStringArray("groups")
        .map!(group => configuration.getString("prefix") ~ group).array;
    }

    auto mygroups = _memory.data(_compiledGroupNames) ? memory.data(
      _compiledGroupNames) : null;
    if (count(mygroups) != count(configuration.get("groups"))) {
      _compiledGroupNames
        .filter!(groupName => !mygroups.hasKey(groupName))
        .each!((groupName) { _memory.set(mygroup, 1, 0); mygroups[mygroup] = 1; }); */
    /* ksort(mygroups); * /
  } */

  string[] result;
  /* auto mygroups = mygroups.values;
    foreach (index, mygroup; configuration.get("groups")) {
      result ~= mygroup ~ mygroups[index];
    } */
  return result;
}

/**
  * Increments the group value to simulate deletion of all keys under a group
  * old values will remain in storage until they expire.
  */
override bool clearGroup(string groupName) {
  // TODO return  /* (bool) */ _memory.increment(configuration.getString("prefix") ~ groupName);
  return false;
}
}
mixin(CacheEngineCalls!("Memory"));
