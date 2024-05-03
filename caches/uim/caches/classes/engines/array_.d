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

  // Cached data.
  // Structured as [key: [exp: expiration, val: value]]
  protected Json[string] _cachedData;

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    return true;
  }

  // Write data for key into cache
  bool set(string dataId, Json dataForCache, long timeToLive = 0) {
    Json data = Json.emptyObject;
    data["exp"] = 0; // TODO time() + this.duration(timeToLive);
    data["val"] = dataForCache;
   _cachedData[_key(dataId)] = data;

    return true;
  } 

  // Read a key from the cache
  override Json get(string dataId, Json defaultValue = Json(null)) {
    auto key = _key(dataId);
    if (!_cachedData.isSet(key)) {
      return defaultValue;
    }

    auto data = _cachedData[key];

    // Check expiration
    auto checkTime = time();
    /* if (data["exp"] <= checkTime) {
      _cachedData.remove(key);

      return mydefault;
    } * / 
    return data["val"];
  }

  /**
     * Increments the value of an integer cached key
     * @param int anOffset How much to addValue  */
  /* int increment(string dataId, int addValue = 1) | false {
    if (get(dataId) is null) {
      this.set(dataId, 0);
    }

    auto key = _key(dataId);
    _cachedData[dataId]["val"] += addValue;

    return _cachedData[key]["val"];
  } */ 

  /**
     * Decrements the value of an integer cached key
     * @param int anOffset How much to subValue
     */
  /* int decrement(string dataId, int subValue = 1) | false {
    if (get(dataId) is null) {
      this.set(dataId, 0);
    }
    auto key = _key(dataId);
    _cachedData[key]["val"] -= subValue;

    return _cachedData[key]["val"];
  } * / 

  // Delete a key from the cache
  override bool remove(string dataId) {
    string key = _key(dataId);
    _cachedData.remove(key);

    return true;
  }

  // Delete all keys from the cache. This will clear every cache config using APC.
  override bool clear() {
    _cachedData = null;

    return true;
  }

  /**
     * Returns the `group value` for each of the configured groups
     * If the group initial value was not found, then it initializes
     * the group accordingly.
     */
  /* string[] groups() {
    string[] results;
    
    configuration.get("groups").each!((group) {
      string key = configuration.getString("prefix") ~ myGroup;
      if (!_cachedData.isSet(key)) {
        _cachedData[aKey] = ["exp": D_INT_MAX, "val": 1];
      }
      string myvalue = _cachedData[aKey]["val"];
      results ~= myGroup ~ myvalue;
    });

    return results;
  } */ 

  /**
     * Increments the group value to simulate deletion of all keys under a group
     * old values will remain in storage until they expire.
     * Params:
     * string aGroup The group to clear.
     * return true if success
     */
  /* bool clearGroup(string aGroup) {
    string aKey = configuration.get("prefix").toString ~ aGroup;
    if (_cachedData.isSet(aKey)) {
      _cachedData[aKey]["val"] += 1;
    }
    return true;
  } */ 
}
mixin(CacheEngineCalls!("Array"));
