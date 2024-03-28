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
class DArrayEngine : DCacheEngine {
  // Cached data.
  // Structured as [key: [exp: expiration, val: value]]
  protected IData[string] _cachedData;

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    return true;
  }

  /**
     * Write data for key into cache
     *
     * @param \DateInterval|int myttl Optional. The TTL value of this item. If no value is sent and
     *  the driver supports TTL then the library may set a default value
     *  for it or let the driver take care of that.
     * returns True on success and false on failure.
     */
  /* bool set(string dataId, IData dataForCache, DateInterval | int | nullmyttl = null) {
    auto key = _key(dataId);
    auto myexpires = time() + this.duration(myttl);
   _cachedData[key] = ["exp": myexpires, "val": dataForCache];

    return true;
  } * / 

  // Read a key from the cache
  override IData get(string dataId, IData defaultValue = null) {
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
    if (get(dataId).isNull) {
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
    if (get(dataId).isNull) {
      this.set(dataId, 0);
    }
    auto key = _key(dataId);
    _cachedData[key]["val"] -= subValue;

    return _cachedData[key]["val"];
  } * / 

  // Delete a key from the cache
  override bool delete_(string dataId) {
    string key = _key(dataId);
    _cachedData.remove(key);

    return true;
  }

  /**
     * Delete all keys from the cache. This will clear every cache config using APC.
     * /
  override bool clear() {
    _cachedData = [];

    return true;
  }

  /**
     * Returns the `group value` for each of the configured groups
     * If the group initial value was not found, then it initializes
     * the group accordingly.
     */
  /* string[] groups() {
    auto result;
    foreach (myGroup; configuration["groups"]) {
      string key = configuration.getString("prefix") ~ myGroup;
      if (!_cachedData.isSet(key)) {
        _cachedData[aKey] = ["exp": PHP_INT_MAX, "val": 1];
      }
      myvalue = _cachedData[aKey]["val"];
      result ~= myGroup ~ myvalue;
    }
    return result;
  } */ 

  /**
     * Increments the group value to simulate deletion of all keys under a group
     * old values will remain in storage until they expire.
     * Params:
     * string aGroup The group to clear.
     * return true if success
     */
  /* bool clearGroup(string aGroup) {
    string aKey = configuration["prefix").toString ~ aGroup;
    if (_cachedData.isSet(aKey)) {
      _cachedData[aKey]["val"] += 1;
    }
    return true;
  } */ 
}
