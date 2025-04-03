/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
    configuration
      .setEntry("compress", false)
      .setEntry("duration", 3600)
      .setEntry("username", "")
      .setEntries(["host", "password", "persistent", "port"], Json(null))
      .setEntry("prefix", "uim_")
      .setEntry("serialize", "d")
      .setEntry("servers", ["127.0.0.1"].toJson) // `servers` String or array of memcached servers. If an array MemcacheEngine will use them as a pool.
      .setEntries(["groups", "options"], Json.emptyArray); // `options` - Additional options for the memcached client. Should be an array of option: value.

    return true;
  }

  // #region groupName
  protected string _groupName;
  override ICacheEngine groupName(string name) {
    _groupName = name;
    return this;
  }

  override string groupName() {
    if (_groupName.isEmpty) {
      _groupName = configuration.getStringEntry("prefix");
    }
    return _groupName;
  }

  override ICacheEngine clearGroup(string groupName) {
    // TODO return  /* (bool) */ _entries.increment(configuration.getStringEntry("prefix") ~ groupName);
    return this;
  }
  // #endregion groupName

  // List of available serializer engines
  // Memory must be compiled with Json and igbinary support to use these engines
  protected int[string] _serializers;
  protected string[] _compiledGroupNames;

  // #region entries

  protected Json[string] _entries; 
  override Json[string] entries() {
    if (_entries is null) {
      _entries = new Json[string];
    }
    return _entries;
  }

  override ICacheEngine entries(Json[string] newEntries) {
    _entries = newEntries;
    return this;
  }
  // #endregion entries

  // #region keys
  override string[] keys() {
    return _entries.keys;
  }
  // #endregion keys

  // #region has
  override bool hasEntry(string key) {
    return _entries.hasKey(key);
  }
  // #endregion has

  // #region get
  override Json getEntry(string key) {
    return _entries.get(key, Json(null));
  }
  // #endregion get

  // #region set
  override ICacheEngine setEntry(string key, Json value) {
    _entries[key] = value;
    return this;
  }
  // #endregion set

  // #region remove
  override ICacheEngine removeEntry(string key) {
    _entries.removeKey(key);
    return this;
  }
  // #endregion remove

  /**
     * Parses the server address into the host/port. Handles both IPv6 and IPv4
     * addresses and Unix sockets
     * Params:
     * string myserver The server address string.
     */
  Json[string] parseServerString(string myserver) {
    auto mysocketTransport = "unix://"; /* if (myserver.startsWith(mysocketTransport)) {
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
    ]; */
    return null;
  }

  // Increments the value of an integer cached key
  override long increment(string key, int incValue = 1) {
    return 1; // TODO return _entries.set(internalcorrectKey(key), _entries.getLong(internalcorrectKey(key)) + incValue);
  }

  // Decrements the value of an integer cached key
  override long decrement(string key, int decValue = 1) {
    return 0; // TODO return _entries.set(internalcorrectKey(key), _entries.getLong(internalcorrectKey(key)) - decValue);
  }

  // Delete all keys from the cache
  override ICacheEngine clearEntries() {
    string prefix = configuration.getStringEntry("prefix");
    /*    _entries.getAllKeys()
      .filter!(key => key.startsWith(prefix))
      .each!(key => _entries.removeKey(key)); */
    return this;
  }

  // Returns the `group value` for each of the configured groups
  string[] groups() {
    if (_compiledGroupNames.isEmpty) {
      auto prefix = configuration.getStringEntry("prefix");
      _compiledGroupNames = configuration.getArrayEntry("groups")
        .map!(group => prefix ~ group.getString)
        .array;
    }

    /* 
    auto mygroups = hasEntries(_compiledGroupNames) 
      ? memory.get(_compiledGroupNames) 
      : null;

    if (count(mygroups) != count(configuration.getEntry("groups"))) {
      _compiledGroupNames
        .filter!(groupName => !mygroups.hasKey(groupName))
        .each!((groupName) { setEntry(mygroup, 1, 0); mygroups[mygroup] = 1; }); */
      /* mygroups = mygroups.sort; * /
    } * /

    // auto groupValues = mygroups.values;
    string[] result = configuration.getStringArrayEntry("groups").map!((index, group) => group ~ groupValues[index].getString).array;
    */
    string[] result;
    return result;
  } 
}
mixin(CacheEngineCalls!("Memory"));

unittest {
  auto config = DMemoryCacheEngine;

  assert(config.groupName("test").groupName() == "test");
  assert(config.entries(Json[string]()).entries().length == 0);
  assert(config.keys().length == 0);
  assert(config.hasEntry("test") == false);
  assert(config.getEntry("test") == Json(null));
  assert(config.setEntry("test", Json(1)).getEntry("test") == Json(1));
  assert(config.increment("test", 1) == 2);
  assert(config.decrement("test", 1) == 1);
}
