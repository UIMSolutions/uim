module uim.caches.classes.engines.apcu;

import uim.caches;

@safe:

// APCu storage engine for cache
class DApcuCacheEngine : DCacheEngine {
  mixin(CacheEngineThis!("Apcu"));
  /**
     * Contains the compiled group names
     * (prefixed with the global configuration prefix)
     */
  protected string[] _compiledGroupNames;

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

/*     if (!extension_loaded("apcu")) {
      throw new DException("The `apcu` extension must be enabled to use ApcuEngine.");
    }   */
    
    return true;
  }

  // Write data for key into cache
     
  override bool set(string itemKey, Json dataToCache, long timeToLive = 0) {
    return false;
    // TODO 
    /* auto aKey = internalKey(itemKey);
    auto myDuration = duration(timeToLive);

    return apcu_store(aKey, dataToCache, myDuration); */
  }

  // Read a key from the cache
  override Json get(string itemKey, Json defaultValue = Json(null)) {
    return Json(null); 
    // TODO 
/*     auto myValue = apcu_fetch(internalKey(itemKey), mysuccess);
    
    return mysuccess ? myValue : defaultValue;
 */  }

  // Increments the value of an integer cached key
  override int increment(string itemKey, int incValue = 1) {
/*     auto key = internalKey(itemKey);

    return apcu_inc(key, incValue); */
    return 0;
  }

  // Decrements the value of an integer cached key
  override int decrement(string itemKey, int decValue = 1) {
    /* auto key = internalKey(itemKey);
    return apcu_dec(key, myoffset); */
    return 0;
  }

  // Delete a key from the cache
  /* override bool remove(string[] itemKeys) {
    // TODO
  /* override bool remove(string itemKey) {
    auto key = internalKey(itemKey);

    return apcu_remove(key);
  } */

  //  Delete all keys from the cache. This will clear every cache config using APC.
  /* override bool clear() {
    if (class_exists(APCUIterator.class, false)) {
      auto myIterator = new APCUIterator(
        "/^" ~ preg_quote(configuration.getString("prefix"), "/") ~ "/",
        APC_ITER_NONE
     );
      apcu_remove(myiterator);

      return true;
    }
    
    auto mycache = apcu_cache_info(); // Raises warning by itself already
    mycache["cache_list"]
      .filter!(key => aKey["info"].startsWith(configuration.get("prefix")))
      .each!(key => apcu_remove(aKey["info"]));
    }
    return true;
  } */ 

  /**
     * Write data for key into cache if it doesn`t exist already.
     * If it already exists, it fails and returns false.
     */
  /* override bool add(string itemKey, Json dataToCache) {
    auto myKey = internalKey(itemKey);
    Json duration = configuration.get("duration");

    return apcu_add(myKey, dataToCache, duration);
  } */ 

  /**
     * Returns the `group value` for each of the configured groups
     * If the group initial value was not found, then it initializes the group accordingly.
     */
  override string[] groups() {
    if (_compiledGroupNames.isEmpty) {
      configuration.getArray("groups").map!(group => configuration.getString("prefix") ~ group).array;
    }
    auto mysuccess = false;
    // TODO 
    /* auto mygroups = apcu_fetch(_compiledGroupNames, mysuccess);
    if (mysuccess && count(mygroups) != count(configuration.get("groups"))) {
      _compiledGroupNames.each!((groupname) {
        if (!mygroups.hasKey(groupname)) {
          auto myvalue = 1;
          if (apcu_store(groupname, myvalue) == false) {
            warning(
              "Failed to store key `%s` with value `%s` into APCu cache."
              .format(groupname, myvalue)
           );
          }
          mygroups[mygroup] = myvalue;
        }
      });
      //TODO ksort(mygroups);
    } */
    string[] results = null;
    // TOD auto groupValues = mygroups.values;
    //TODO
    /* foreach (myi : mygroup; configuration.get("groups")) {
      results ~= mygroup ~ groupValues[myi];
    } */
    return results;
  } 

  /*
     * Increments the group value to simulate deletion of all keys under a group
     * old values will remain in storage until they expire.
     */
  override bool clearGroup(string groupName) {
    bool isSuccess = false;
    // TODO apcu_inc(configuration.getString("prefix") ~ groupName, 1, isSuccess);

    return isSuccess;
  }
}
mixin(CacheEngineCalls!("Apcu"));
