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
    _cachedData[internalKey(itemKey)] = data;

    return true;
  }

  // Cached data.
  // Structured as [key: [exp: expiration, val: value]]
  protected Json[string] _cachedData;
  // Delete a key from the cache
  override bool removeItem(string itemKey) {
    return _cachedData.remove(internalKey(itemKey));
  }

  // Delete all keys from the cache. This will clear every cache config using APC.
  override bool clear() {
    return _cachedData.clear;
  }

  // Read a key from the cache
  override Json get(string key, Json defaultValue = Json(null)) {
    string internalKey = internalKey(key);
    if (!_cachedData.hasKey(internalKey)) {
      return defaultValue;
    }

    auto value = _cachedData[internalKey];

    // Check expiration
    auto checkTime = time();
    if (value.getLong("exp") <= checkTime) {
      _cachedData.remove(internalKey);
      return defaultValue;
    } 
    
    return value["val"];
  }

  // Increments the value of an integer cached key
  override long increment(string itemKey, int incValue = 1) {
    return 0;
    // TODO
    /* 
    if (get(itemKey).isNull) {
      set(itemKey, Json(0));
    }

    auto key = internalKey(itemKey);
    _cachedData[itemKey]["val"] += incValue;

    return _cachedData[key]["val"];
    */
  }

  // Decrements the value of an integer cached key
  /* long decrement(string itemKey, int decValue = 1) {
    if (get(itemKey).isNull) {
      set(itemKey, Json(0));
    }
    auto key = internalKey(itemKey);
    _cachedData[key]["val"] -= decValue;

    return _cachedData[key]["val"];
  } */

  override bool removeItem(string key) {
    return false;
  }

  /**
     * Returns the `group value` for each of the configured groups.
     * If the group initial value was not found, then it initializes the group accordingly.
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
     */
  override bool clearGroup(string groupName) {
    string key = configuration.get("prefix").toString ~ groupName;
    // TODO 
    /*    if (_cachedData.hasKey(key)) {
      _cachedData[key]["val"] += 1;
    } */
    return true;
  }
}
mixin(CacheEngineCalls!("Array"));
