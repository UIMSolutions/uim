/***********************************************************************************
*	Copyright: ©2015 -2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.generals.registry;

import uim.oop;
@safe:

class DRegistry(T) {
  this() {}

  protected T _nullValue = T.init;
  @property O nullValue(this O)(T newNullValue) {
    _nullValue = newNullValue;
    return cast(O)this;
  }  

  protected T[string] _entries;
  T entry(string path) {
    return _entries.get(path, _nullValue); }
  version(test_uim_oop) { unittest {
      auto registry = new DRegistry!int;
      registry.register("1", 1);
      assert(registry["1"] == 1);   
      }}

  /// contains entry
  bool contains(string path) {
    return (path in _entries) ? true : false;
  }

  bool contains(T entry) {
    return (entry.registerPath in _entries) ? true : false;
  }
  
  /// Get entry by index
  T opIndex(string path) {
    return _entries.get(path, _nullValue); }
    unittest {
      // TODO 
      }
  
  /// Det entry by index
  void opIndexAssign(T newEntry, string path) {
    register(path, newEntry); }
    unittest {
      // TODO 
      }
  
  /// Add new entry
  O register(this O)(T[] newEntries...) {
    this.register(newEntries.dup);
    return cast(O)this;
  }

  // register new Entries
  O register(this O)(T[] newEntries) {
    newEntries
      .filter!(entry => entry !is null).array
      .each!(entry => this.register(entry.registerPath, entry));
    return cast(O)this;
  }

  // register new entry
  O register(this O)(string path, T newEntry) {
    _entries[path] = newEntry;
    return cast(O)this;
  }

/*   O register(this O)(T newEntry, string name) {
    _entries[name] = newEntry;
    return cast(O)this; }
 */

  T[] all() {
    return _entries.byValue.array;
  }

  string[] paths() {
    return _entries.byKey.array; }

  T remove(string path) { 
    auto selectedEntry = this.entry(path);
    if (selectedEntry) _entries.remove(path);
    return selectedEntry; 
  }
  version(test_uim_oop) { unittest {
      // TODO 
      }}

  O clear(this O)() { 
    _entries = null;
    return cast(O)this; 
  }
  version(test_uim_oop) { unittest {
      // TODO 
      }}

}
// auto Registry() { return new DRegistry; }