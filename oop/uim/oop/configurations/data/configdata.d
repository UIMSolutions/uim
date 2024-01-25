/*********************************************************************************************************
	Copyright: © 2015 - 2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.configurations.data.configdata;

import uim.oop;

@safe:

class DConfigData : IConfigData {
	this() {
	}

	protected IConfigData[string] _configData;

    // Compare with other configData
	bool isEqual(IConfigData data) {
		if (data is null) {
			return false;
		}

		foreach (k; data.keys) {
			if (this.data(k).isEqual(data.data(k))) {
				continue;
			}
			return false;
		}
		return true;
	}

	// Get all keys
	string[] keys() {
		return _configData.keys;
	}

	// Get all values
	IConfigData[] values() {
		return _configData.values;
	}

	// Check if has all paths
	bool hasPaths(string[] paths) {
		return paths.all!(path => hasPath(path));
	}

	// Check if has path
	bool hasPath(string path) {
		auto pathItems = path.split("/");
		if (pathItems.length == 0) { return false; }
		if (pathItems.length == 1) { return hasKey(pathItems[0]); }

		if (auto data = data(pathItems[0])) { return hasPath(pathItems[1..$].join("/")); }
		return false;
	}

	// Check if has all keys
	bool hasKeys(string[] keys, bool deepSearch = false) {
		return keys.all!(key => hasKey(key, deepSearch));
	}

	// Check if has key
	bool hasKey(string key, bool deepSearch = false) {
		if (!deepSearch) {
			return _configData.hasKey(key);
		}

		return _configData.values.any!(data => data.hasKey(key, deepSearch));
	}

	bool hasData(IConfigData[] searchData, bool deepSearch = false) {
		return searchData.all!(data => hasData(data, deepSearch));
	}

	bool hasData(IConfigData searchData, bool deepSearch = false) {
		if (searchData is null) {
			return false;
		}

		return deepSearch
			? _configData.values.any!(value => value.hasData(searchData, deepSearch)) 
			: _configData.values.any!(value => value.isEqual(searchData));
	}

	IConfigData get(string key, IConfigData defaultData) {
		return hasKey(key)
			? _configData[key] 
			: defaultData;
	}

	IConfigData data(string key) {
		return hasKey(key)
			? _configData[key] : null;
	}

	IConfigData opIndex(string key) {
		return data(key);
	}

	IConfigData data(string key, IConfigData data) {
		_configData[key] = data;
		return this;
	}

	IConfigData opAssignIndex(IConfigData data, string key) {
		_configData[key] = data;
		return this;
	}

	override string toString() {
		return _configData.keys.map!(key => key ~ ":" ~ data(key).toString).join("\n");
	}
}
mixin(ConfigDataCalls!("ConfigData"));
