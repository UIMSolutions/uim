/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.containers.maps.map;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

class DMap(K, V) : IMap {
  this() {}

  // #region entries
  protected V[K] _entries;
  V[K] entries() {
    return _entries.dup;
  }
  void entries(V[K] newEntries) {
    _entries = newEntries.dup;
  }
  // #endregion entries

  bool isEmpty() { return length == 0; }
  size_t length() { return _entries.length; }

  // #region keys
  // Retrieve all the names of the object's own enumerable properties.
  K[] keys() {
    return _entries.keys.dup;
  }
  // #endregion keys

  // #region values
  // Return all of the values of the object's own properties.
  V[] values() {
    return _entries.values.dup;
  }
  // #endregion values

  void opIndexAssign(T)(T value, K key) {
    _entries[key] = value;
  }

  V opIndex(K key) {
    return _entries[key];
  }

  // #region removeKeys
  bool removeKeys(K[] keys...) {
    return removeKeys(keys.dup);
  }
  bool removeKeys(K[] keys) {
    return keys.all!(key => _entries.removeKey(key));
  }
  bool removeKey(K key) {
    return _entries.remove(key);
  }
  // #endregion removeKeys

  void clear(this O)() { 
    _entries = null; 
  }

/*   override string toString() {
    return "%s".format(_entries.byKeyValue.map!(value => value.toString).array);
  } */
}

unittest {
}
