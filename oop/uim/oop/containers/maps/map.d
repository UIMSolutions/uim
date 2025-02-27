/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.containers.maps.map;

import uim.core;
@safe:

version (test_uim_oop) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DMap(T : Object) : IMap {
  this() {}

  protected T[string] _values;

  bool isEmpty() { return length == 0; }
  size_t length() { return _values.length; }

  bool removeKey(string[] keys) {
    return keys.all!(key => _values.removeKey(key));
  }
  bool removeItem(string key) {
    return _values.removeKey(key);
  }
  void clear(this O)() { 
    _values = null; 
  }

  override string toString() {
    return "%s".format(_values.byKeyValue.map!(value => value.toString).array);
  }
}

version(test_uim_oop) { unittest {
  // TODO auto map = new DMapObj;
}}
