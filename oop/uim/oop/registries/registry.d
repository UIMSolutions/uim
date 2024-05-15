/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.registries.registry;

import uim.oop;

@safe:

class DObjectRegistry(T : Object) {
	this() {
	}

	public static DObjectRegistry!T registry() {
		if (_registry.isNull) {
			_registry = new DObjectRegistry!T;
		}
		return _registry;
	}

	protected static DObjectRegistry!T _registry;
	protected T[string] _registeredObjects;
	protected T _nullValue;
	protected string _pathSeparator = "/";

	size_t length() {
		return _registeredObjects.length;
	}

	// #region registration
	string[] registrations() {
		return _registeredObjects.byKey.array;
	}

	bool hasAnyRegistrations(string[][] registrations) {
		return registrations.any!(registration => hasRegistration(registration));
	}

	bool hasAllRegistrations(string[][] registrations) {
		return registrations.all!(registration => hasRegistration(registration));
	}

	bool hasAnyRegistrations(string[] registrations) {
		return registrations.any!(registration => hasRegistration(registration));
	}

	bool hasAllRegistrations(string[] registrations) {
		return registrations.all!(registration => hasRegistration(registration));
	}

	bool hasRegistration(string[] registration) {
		return _registeredObjects.hasKey(registration.join(_pathSeparator));
	}

	bool hasRegistration(string registration) {
		return _registeredObjects.hasKey(registration);
	}
	// #endregion registration

	// #region registeredobjects
	bool hasAnyRegisteredObjects(T[] checkRegisteredObjects) {
		return checkRegisteredObjects.any!(
			registeredObject => hasRegisteredObject(registeredObject));
	}

	bool hasAllRegisteredObjects(T[] checkRegisteredObjects) {
		return checkRegisteredObjects.all!(
			registeredObject => hasRegisteredObject(registeredObject));
	}

	bool hasRegisteredObject(T registeredObject) {
		// TODO ERROR return _registeredObjects.byValue.any!(registeredobject => registeredobject.isEqual(registeredObject));
		return false;
	}

	T registeredObject(string registration) {
		return _registeredObjects.get(registration, _nullValue);
	}

	T[] registeredObjects() {
		return _registeredObjects.values;
	}
	// #endregion registeredobjects

	/// Get registeredobject by index
	T opIndex(string registration) {
		return registeredObject(registration);
	}

	unittest {
            version(test_uim_opp) {
                writeln(__MODULE__, " in ", __LINE__);
            }
		// TODO 
	}

	void register(string[] registerPath, T newRegisteredObject) {
		register(registerPath.join(_pathSeparator), newRegisteredObject);
	}

	void register(string registration, T registeredObject) {
		_registeredObjects[registration] = registeredObject;
	}
	unittest {
            version(test_uim_opp) {
                writeln(__MODULE__, " in ", __LINE__);
            }
		class DTest{}
		auto registry = DObjectRegistry!DTest;
		// TODO
	}

	void opIndexAssign(string registration, T registeredObject) {
		register(registration, registeredObject);
	}
	unittest {
            version(test_uim_opp) {
                writeln(__MODULE__, " in ", __LINE__);
            }
		class DTest{}
		auto registry = DObjectRegistry!DTest;
		// TODO
	}

	// #region remove
	void remove(string[] registrations) {
		registrations.each!(reg => remove(reg));
	}
	unittest {
            version(test_uim_opp) {
                writeln(__MODULE__, " in ", __LINE__);
            }
		class DTest{}
		auto registry = DObjectRegistry!DTest;
		// TODO
	}

	void remove(string registration) {
		_registeredObjects.remove(registration);
	}
	unittest {
            version(test_uim_opp) {
                writeln(__MODULE__, " in ", __LINE__);
            }
		class DTest{}
		auto registry = DObjectRegistry!DTest;
		// TODO
	}
	// #endregion remove


	// Create the registeredobject object with the correct settings.
	/* 
    T create(string registration, Json[string] initData = null) {
        return hasRegistration(registration) 
			? registeredobjects(registration).clone(initData)
			: null;
    } */

	void clear() {
		_registeredObjects = null;
	}
}
