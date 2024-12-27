module uim.caches.classes.engines.null_;

import uim.caches;

@safe:

// Null cache engine, all operations appear to work, but do nothing.
class DNullCacheEngine : DCacheEngine {
  mixin(CacheEngineThis!("Null"));

 /*  override string[] keys() {
    return null;
  }

  override bool updateKey(string key, Json valueToSet, long timeToLive = 0) {
    return true;
  } */
}
  mixin(CacheEngineCalls!("Null"));
