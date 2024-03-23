/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.registries.registry;

import uim.oop;

@safe:

class DObjectRegistry(T : Object) {
	private static DObjectRegistry _instance;
	private T[string] _entries;
	private T _nullValue;

	private this() {
		// 
	}

	public static DObjectRegistry getInstance() {
		if (_instance is null) {
			_instance = new DObjectRegistry;
		}
		return _instance;
	}

	size_t length() {
		return _entries.length;
	}
	
	T item(string path) {
		return _entries.get(path, _nullValue);
	}

	  T[] allItems() {
    return _entries.byValue.array;
  }


	/// contains entry
	bool hasPath(string[] path) {
		return _entries.hasKey(path.join("/"));
	}

	bool hasPath(string path) {
		return _entries.hasKey(path);
	}

	// TODO bool hasValue(T value) {
	// return (entry.registerPath in _entries) ? true : false;
	// }

	/// Get entry by index
	T opIndex(string path) {
		return item(path);
	}

	unittest {
		// TODO 
	}

	void add(string path, T item) {
		_entries[path] = item;
	}

	void opIndexAssign(string path, T item) {
		add(path, item);
	}

	string[] paths() {
		return _entries.byKey.array;
	}

	T remove(string path) {
		auto selectedEntry = item(path);
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

	void clear() {
		_entries = null;
	}
}
