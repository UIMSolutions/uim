/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.patterns.registry;

import uim.oop;

@safe:

class DObjectRegistry(T : UIMObject) {
  // #region Singleton
  protected static DObjectRegistry!T _registration;
  public static O _registrationtry(this O)() {
    return cast(O)(_registration is null) 
      ? _registration = new DObjectRegistry!T
      : _registration;
  }
  // #endregion Singleton

  protected T[string] _objects;
  protected T _nullValue = null;
  protected string _pathSeparator = ".";

  size_t length() {
    return _objects.length;
  }

  // #region keys
  string[] keys() {
    return _objects.keys;
  }

  bool hasAnyPaths(string[][] paths) {
    return paths.any!(path => hasPath(path));
  }

  bool hasAllPaths(string[][] paths) {
    return paths.all!(path => hasPath(path));
  }

  bool hasPath(string[] path) {
    return _objects.hasKey(correctKey(path));
  }

  bool hasAllKeys(string[] keys) {
    return keys.all!(key => hasKey(key));
  }

  bool hasAnyKeys(string[] keys) {
    return keys.any!(key => hasKey(key));
  }

  bool hasKey(string key) {
    return _objects.hasKey(correctKey(key));
  }

  string correctKey(string[] path) {
    return correctKey(path.join(_pathSeparator));
  }

  string correctKey(string key) {
    return key.strip;
  }
  // #endregion keys

  // #region objects
  T[] objects() {
    return _objects.values;
  }

  bool hasAnyObjects(T[] objects) {
    return objects.any!(obj => hasObject(obj));
  }

  bool hasAllObjects(T[] objects) {
    return objects.all!(obj => hasObject(obj));
  }

  // TODO
  bool hasObject(T object) {
    foreach (obj; _objects.values) {
      // if (obj.isEquals(object)) { return true; }
    }
    return false;
  }

  T get(string[] path) {
    return get(correctKey(path));
  }

  T opIndex(string key) {
    return get(key);
  }

  T get(string key) {
    return correctKey(key) in _objects ? _objects[correctKey(key)] : _nullValue;
  }
  // #endregion objects

  /// Get registeredobject by index

  // #region register
  void opIndexAssign(string key, T newObject) {
    register(key, newObject);
  }

  O register(this O)(T newObject) {
    this.register(newObject.classname, newObject);
    return cast(O) this;
  }

  O register(this O)(string[] path, T newObject) {
    this.register(correctKey(path), newObject);
    return cast(O) this;
  }

  O register(this O)(string key, T newObject) {
    _objects[correctKey(key)] = newObject;
    return cast(O) this;
  }
  // #endregion register

  // #region clone
  T create(string[] path) {
    return create(correctKey(path));
  }

  T create(string key) {
    T createdObject;
    if (auto registerdObject = get(correctKey(key))) {
      () @trusted {
        createdObject = cast(T) factory(registerdObject.classname);
      }();
    }
    return createdObject;
  }
  // #endregion clone

  // #region remove
  O removeKey(this O)(string[] keys...) {
    removeKey(keys.dup);
    return cast(O)this;
  }

  O removeKey(this O)(string[] keys) {
    keys.all!(reg => removeKey(reg));
    return cast(O)this;
  }

  O remove(this O)(string key) {
    _objects.removeKey(key);
    return cast(O)this;
  }

  O removeKey(this O)(string key) {
    _objects.removeKey(key);
    return cast(O)this;
  }

  O clear(this O)() {
    _objects = null;
    return cast(O)this;
  }
  // #endregion remove

  // Create the registeredobject object with the correct settings.
  /* 
    T create(string registration, Json[string] initData = null) {
        return hasRegistration(registration) 
      ? registeredobjects(registration).clone(initData)
      : null;
    } */

}

/* unittest {
  class Test {
    this() {      
    }
    this(string newName) {
      this().name(newName);      
    }
    mixin(TProperty!("string", "name"));
  }

  class TestRegistry : DObjectRegistry!Test {}

  assert(TestRegistry.registration.length == 0);
  assert(TestRegistry.registration.length == 0);
} */
