/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.registries.registry;

import uim.oop;

@safe:

class DObjectRegistry(T : Object) {
	protected static DObjectRegistry!T _instance;
	protected T[string] _entries;
	protected T _nullValue;
	protected string _pathSeparator = "/";

	this() {
	}

	public static DObjectRegistry!T instance() {
		if (_instance.isNull) {
			_instance = new DObjectRegistry!T;
		}
		return _instance;
	}

	size_t length() {
		return _entries.length;
	}

	// #region path
		string[] paths() {
			return _entries.byKey.array;
		}

		bool hasAnyPaths(string[][] paths) {
			return paths.any!(path => hasPath(path));
		}

		bool hasAllPaths(string[][] paths) {
			return paths.all!(path => hasPath(path));
		}
		
		bool hasAnyPaths(string[] paths) {
			return paths.any!(path => hasPath(path));
		}

		bool hasAllPaths(string[] paths) {
			return paths.all!(path => hasPath(path));
		}

		bool hasPath(string[] path) {
			return _entries.hasKey(path.join(_pathSeparator));
		}

		bool hasPath(string path) {
			return _entries.hasKey(path);
		}
	// #endregion path

	// #region entries
		bool hasAnyEntries(T[] checkEntries) {
			return checkEntries.any!(checkEntry => hasEntry(checkEntry));
		}

		bool hasAllEntries(T[] checkEntries) {
			return checkEntries.all!(checkEntry => hasEntry(checkEntry));
		}

		bool hasEntry(T checkEntry) {
			// TODO ERROR return _entries.byValue.any!(entry => entry.isEqual(checkEntry));
			return false;
		}

		T entry(string path) {
			return _entries.get(path, _nullValue);
		}

		T[] entries() {
			return _entries.values;
		}
	// #endregion entries

	/// Get entry by index
	T opIndex(string path) {
		return entry(path);
	}

	unittest {
		// TODO 
	}

	void add(string[] pathEntries, T newEntry) {
		add(pathEntries.join(_pathSeparator), newEntry);
	}

	void add(string path, T newEntry) {
		_entries[path] = newEntry;
	}

	void opIndexAssign(string path, T newEntry) {
		add(path, newEntry);
	}

	T remove(string path) {
		auto selectedEntry = entry(path);
		if (selectedEntry) {
			_entries.remove(path);
		}
		return selectedEntry;
	}

	version (test_uim_oop) {
		unittest {
			// TODO 
		}
	}

    // Create the entry object with the correct settings.
	/* 
    T create(string path, Json[string] initData = null) {
        return hasPath(path) 
			? entries(path).clone(initData)
			: null;
    } */

	void clear() {
		_entries = null;
	}
}
