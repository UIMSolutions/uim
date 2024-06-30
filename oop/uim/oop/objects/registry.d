/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.oop.objects.registry;

import uim.oop;

@safe:

class DObjectRegistry(T : UIMObject) {
	this() {
	}

	public static DObjectRegistry!T registry() {
		if (_registry is null) {
			_registry = new DObjectRegistry!T;
		}
		return _registry;
	}

	protected static DObjectRegistry!T _registry;
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
		return _objects.hasKey(correctedKey(path));
	}

	bool hasAllKeys(string[] keys) {
		return keys.all!(key => hasKey(key));
	}

	bool hasAnyKeys(string[] keys) {
		return keys.any!(key => hasKey(key));
	}

	bool hasKey(string key) {
		return _objects.hasKey(correctedKey(key));
	}

	string correctedKey(string[] path) {
		return correctedKey(path.join(_pathSeparator));
	}

	string correctedKey(string key) {
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

	bool hasObject(T object) {
		foreach (obj; _objects.values) {
			// if (obj.isEquals(object)) { return true; }
		}
		return false;
	}

	T get(string[] path) {
		return get(correctedKey(path));
	}

	T opIndex(string key) {
		return get(key);
	}

	T get(string key) {
		return _objects.get(correctedKey(key), _nullValue);
	}
	// #endregion objects

	/// Get registeredobject by index

	// #region register
	O register(this O)(string[] path, T newObject) {
		register(correctedKey(path), newObject);
		return cast(O) this;
	}

	void opIndexAssign(string key, T newObject) {
		register(key, newObject);
	}

	O register(this O)(string key, T newObject) {
		_objects[correctedKey(key)] = newObject;
		return cast(O) this;
	}
	// #endregion register

	// #region clone
	T create(string[] path) {
		return create(correctedKey(path));
	}

	T create(string key) {
		T createdObject;
		if (auto registerdObject = get(correctedKey(key))) {
			() @trusted {
				createdObject = cast(T) factory(registerdObject.classname);
			}();
		}
		return createdObject;
	}
	// #endregion clone

	// #region remove
	bool remove(string[] keys) {
		return keys.all!(reg => remove(reg));
	}

	bool remove(string key) {
		return _objects.remove(key);
	}

	void clear() {
		_objects = null;
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

	assert(TestRegistry.registry.length == 0);
	assert(TestRegistry.registry.length == 0);
} */
