module uim.caches.classes.engines.array_;

import uim.caches;

@safe:

/**
 * Array storage engine for cache.
 * Not actually a persistent cache engine. All data is only
 * stored in memory for the duration of a single process. While not
 * useful in production settings this engine can be useful in tests
 * or console tools where you don`t want the overhead of interacting
 * with a cache servers, but want the work saving properties a cache provides.
 */
class DArrayCacheEngine : DCacheEngine {
  mixin(CacheEngineThis!("Array"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // Write data for key into cache
  override bool set(string itemKey, Json dataForCache, long timeToLive = 0) {
    Json data = Json.emptyObject;
    data["exp"] = 0; // TODO time() + duration(timeToLive);
    data["val"] = dataForCache;
    _cachedData[_key(itemKey)] = data;

    return true;
  }

  // Cached data.
  // Structured as [key: [exp: expiration, val: value]]
  protected Json[string] _cachedData;
  // Delete a key from the cache
  override bool remove(string itemKey) {
    _cachedData.remove(_key(itemKey));

    return true;
  }

  // Delete all keys from the cache. This will clear every cache config using APC.
  override bool clear() {
    _cachedData = null;
    return true;
  }

  // Read a key from the cache
  override Json get(string itemKey, Json defaultValue = Json(null)) {
    // TODO 
    /* auto key = _key(itemKey);
    if (!_cachedData.hasKey(key)) {
      return defaultValue;
    }

    auto data = _cachedData[key];

    // Check expiration
    auto checkTime = time();
    /* if (data["exp"] <= checkTime) {
      _cachedData.remove(key);

      return mydefault;
    } */
    return data["val"];
  }

  // Increments the value of an integer cached key
  override int increment(string itemKey, int incValue = 1) {
    return 0;
    // TODO
    /* 
    if (get(itemKey).isNull) {
      set(itemKey, Json(0));
    }

    auto key = _key(itemKey);
    _cachedData[itemKey]["val"] += incValue;

    return _cachedData[key]["val"];
    */
  }

  // Decrements the value of an integer cached key
  /* int decrement(string itemKey, int decValue = 1) {
    if (get(itemKey).isNull) {
      set(itemKey, Json(0));
    }
    auto key = _key(itemKey);
    _cachedData[key]["val"] -= decValue;

    return _cachedData[key]["val"];
  } */

  /**
     * Returns the `group value` for each of the configured groups
     * If the group initial value was not found, then it initializes
     * the group accordingly.
     */
  override string[] groups() {
    string[] results;

    // TODO
    /*
    configuration.get("groups").each!((group) {
      string key = configuration.getString("prefix") ~ myGroup;
      if (!_cachedData.hasKey(key)) {
        _cachedData[aKey] = ["exp": D_INT_MAX, "val": 1];
      }
      string myvalue = _cachedData[aKey]["val"];
      results ~= myGroup ~ myvalue;
    });
    */
    return results;
  }

  /**
     * Increments the group value to simulate deletion of all keys under a group
     * old values will remain in storage until they expire.
     * Params:
     * string aGroup The group to clear.
     * return true if success
     */
  override bool clearGroup(string groupName) {
    string aKey = configuration.get("prefix").toString ~ groupName;
    // TODO 
    /*    if (_cachedData.hasKey(aKey)) {
      _cachedData[aKey]["val"] += 1;
    }
 */
    return true;
  }
}

mixin(CacheEngineCalls!("Array"));
