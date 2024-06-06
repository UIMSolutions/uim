module uim.caches.classes.engines.null_;

import uim.caches;

@safe:

/**
 * Null cache engine, all operations appear to work, but do nothing.
 * This is used internally for when Cache.disable() has been called.
 */
class DNullCacheEngine : DCacheEngine {
  mixin(CacheEngineThis!("Null"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    return true;
  }

  override bool set(string itemKey, Json valueToSet, long timeToLive = 0) {
    return true;
  }

  override bool set(Json[string] valuesToSet, long timeToLive = 0) {
    return true;
  }

  override Json get(string itemKey, Json defaultValue = null) {
    return defaultValue;
  }

  override Json[string] cacheItems(string[] itemKeys, Json defaultValue = null) {
    return null;
  }

  override long increment(string itemKey, int incValue = 1) {
    return 1;
  }

  override long decrement(string itemKey, int decValue = 1) {
    return 0;
  }

  override bool remove(string itemKey) {
    return true;
  }

  override bool removeItems(string[] itemKeys) {
    return true;
  }

  override bool clear() {
    return true;
  }

  override bool clearGroup(string groupName) {
    return true;
  }
}
mixin(CacheEngineCalls!("Null"));
