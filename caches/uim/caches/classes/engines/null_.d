module uim.caches.classes.engines.null_;

import uim.caches;

@safe:

// Null cache engine, all operations appear to work, but do nothing.
class DNullCacheEngine : DCacheEngine {
  mixin(CacheEngineThis!("Null"));

  override string[] keys() {
    return null;
  }

  override bool updateKey(string key, Json valueToSet, long timeToLive = 0) {
    return true;
  }

  override Json read(string itemKey, Json defaultValue = null) {
    return defaultValue;
  }

  override long increment(string itemKey, int incValue = 1) {
    return 1;
  }

  override long decrement(string itemKey, int decValue = 1) {
    return 1;
  }

  override bool removeKey(string key) {
    return true;
  }

    override bool clearGroup(string groupName) {
    return true;
  }
}
mixin(CacheEngineCalls!("Null"));
