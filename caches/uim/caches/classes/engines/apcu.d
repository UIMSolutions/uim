module uim.caches.classes.engines.apcu;

import uim.caches;

@safe:

// APCu storage engine for cache
class DApcuEngine : DCacheEngine {
  /**
     * Contains the compiled group names
     * (prefixed with the global configuration prefix)
     */
  protected string[] my_compiledGroupNames;

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    /* if (!extension_loaded("apcu")) {
      throw new UimException("The `apcu` extension must be enabled to use ApcuEngine.");
    } */ 
    
    return true;
  }

  /**
     * Write data for key into cache
     * Params:
     * @param IData aValue Data to be cached
     * @param \DateInterval|int myttl Optional. The TTL value of this item. If no value is sent and
     *  the driver supports TTL then the library may set a default value
     *  for it or let the driver take care of that.
     */
  /* bool set(string dataId, IData dataToCache, DateInterval | int | null myttl = null) {
    auto aKey = _key(dataId);
    auto myDuration = this.duration(myttl);

    return apcu_store(aKey, dataToCache, myDuration);
  } */

  /**
     * Read a key from the cache
     * @param IData mydefault Default value in case the cache misses.
     * /
  override IData get(string dataId, IData mydefault = null) {
    auto myValue = apcu_fetch(_key(dataId), mysuccess);
    
    return mysuccess == false ? mydefault : myValue;
  }

  /**
     * Increments the value of an integer cached key
     *
     * @param int incValue How much to increment
     * /
  override int increment(string dataId, int incValue = 1) {
    auto key = _key(dataId);

    return apcu_inc(key, incValue);
  }

  /**
     * Decrements the value of an integer cached key
     * @param int anOffset How much to subtract
     */
  /* int | false decrement(string dataId, int anOffset = 1) {
    auto key = _key(dataId);

    return apcu_dec(key, myoffset);
  } */ 

  // Delete a key from the cache
  /* bool delete_(string dataId) {
    auto key = _key(dataId);

    return apcu_delete_(key);
  } */

  //  Delete all keys from the cache. This will clear every cache config using APC.
  /* bool clear() {
    if (class_exists(APCUIterator.class, false)) {
      auto myIterator = new APCUIterator(
        "/^" ~ preg_quote(configuration.get("prefix"), "/") ~ "/",
        APC_ITER_NONE
      );
      apcu_delete_(myiterator);

      return true;
    }
    
    auto mycache = apcu_cache_info(); // Raises warning by itself already
    mycache["cache_list"]
      .filter!(key => aKey["info"].startsWith(configuration.get("prefix")))
      .each!(key => apcu_delete_(aKey["info"]));
    }
    return true;
  } */ 

  /**
     * Write data for key into cache if it doesn`t exist already.
     * If it already exists, it fails and returns false.
     * Params:
     * string aKey Identifier for the data.
     * @param IData aValue Data to be cached.
     */
  /* bool add(string aKey, IData aValue) {
    auto myKey = _key(aKey);
    IData duration = configuration.get("duration");

    return apcu_add(myKey, myvalue, duration);
  } */ 

  /**
     * Returns the `group value` for each of the configured groups
     * If the group initial value was not found, then it initializes
     * the group accordingly.
     * /
  string[] groups() {
    if (_compiledGroupNames.isEmpty) {
      configuration.get("groups").map!(group => configuration.get("prefix") ~ group).array;
    }
    auto mysuccess = false;
    auto mygroups = apcu_fetch(_compiledGroupNames, mysuccess);
    if (mysuccess && count(mygroups) != count(configuration.get("groups"])) {
      _compiledGroupNames.each!((groupname) {
        if (!mygroups.isSet(groupname)) {
          auto myvalue = 1;
          if (apcu_store(groupname, myvalue) == false) {
            this.warning(
              "Failed to store key `%s` with value `%s` into APCu cache."
              .format(groupname, myvalue)
            );
          }
          mygroups[mygroup] = myvalue;
        }
      });
      ksort(mygroups);
    }
    auto results = null;
    auto groupValues = mygroups.values;
    foreach (myi : mygroup; configuration.get("groups"]) {
      results ~= mygroup ~ groupValues[myi];
    }
    return results;
  } */

  /*
     * Increments the group value to simulate deletion of all keys under a group
     * old values will remain in storage until they expire.
     * /
  override bool clearGroup(string groupName) {
    bool isSuccess = false;
    apcu_inc(configuration.get("prefix") ~ groupName, 1, isSuccess);

    return isSuccess;
  } */ 
}
