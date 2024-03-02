module uim.caches.engines.null_;

import uim.caches;

@safe:

/**
 * Null cache engine, all operations appear to work, but do nothing.
 * This is used internally for when Cache.disable() has been called.
 */
class NullEngine : CacheEngine {

  bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    return true;
  }

  bool set(string aKey, Json aValue, DateInterval | int | null aTtl = null) {
    return true;
  }

  bool setMultiple(iterable someValues, DateInterval | int | null aTtl = null) {
    return true;
  }

  Json get(string aKey, Json defaultValues = null) {
    return defaultValues;
  }

  iterable getMultiple(string[] someKeys, Json defaultValues = null) {
    return null;
  }

  int increment(string aKey, int anOffset = 1) | false {
    return 1;
  }

  int decrement(string aKey, int anOffset = 1) | false {
    return 0;
  }

  bool deleteKey(string aKey) {
    return true;
  }

  bool deleteMultiple(string[] someKeys) {
    return true;
  }

  bool clear() {
    return true;
  }

  bool clearGroup(string aGroup) {
    return true;
  }
}
