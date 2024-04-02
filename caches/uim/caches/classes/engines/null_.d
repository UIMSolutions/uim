module uim.caches.classes.engines.null_;

import uim.caches;

@safe:

/**
 * Null cache engine, all operations appear to work, but do nothing.
 * This is used internally for when Cache.disable() has been called.
 */
class DNullEngine : DCacheEngine {
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    return true;
  }

/*
  bool set(string aKey, IData aValue, DateInterval | int | null aTtl = null) {
    return true;
  }

  bool setMultiple(Range someValues, DateInterval | int | null aTtl = null) {
    return true;
  } * / 

  IData get(string aKey, IData defaultValues = null) {
    return defaultValues;
  }

  range getMultiple(string[] someKeys, IData defaultValues = null) {
    return null;
  }

  int increment(string aKey, int anOffset = 1) | false {
    return 1;
  }

  int decrement(string aKey, int anOffset = 1) | false {
    return 0;
  }
* /
  override bool deleteKey(string aKey) {
    return true;
  }

  override bool deleteMultiple(string[] someKeys) {
    return true;
  }

  override bool clear() {
    return true;
  }

  override bool clearGroup(string aGroup) {
    return true;
  } */
}
