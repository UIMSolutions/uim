/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.data.data;

import uim.oop;

class DData : IData {
  this() {
  }

  protected IData[string] _data;

	// Get all keys
  string[] keys() {
    return _data.keys;
  }

	// Get all values
  IData[] values() {
    return _data.values;
  }

    // Compare with other Data
  bool isEqual(IData[string] checkData) {
    return hasKeys(checkData.keys) 
      ? checkData.keys.all!(key => get(key).isEqual(checkData[key]))
      : false;
  }

	// Check if has path
  bool hasPaths(string[] paths, string separator = "/") {
    return paths.all!(path => hasPath(path, separator));
  }

	// Check if has all paths
  bool hasPath(string path, string separator = "/") {
		string[] pathItems = path.split(separator);
		if (pathItems.isEmpty) { return false; }
		if (pathItems.length == 1) { return hasKey(pathItems[0]); }

		if (auto data = data(pathItems[0])) { return hasPath(pathItems[1..$].join(separator)); }
		return false;
  }

	// Check if has all keys
  bool hasKeys(string[] keys, bool deepSearch = false) {
    return keys.all!(key => hasKey(key, deepSearch));
  }

	// Check if has key
  bool hasKey(string checkKey, bool deepSearch = false) {
    if (checkKey in _data) return true;
    return deepSearch
      ? keys.any!(key => data(key).checkKey(key))
      : false;
  }

  bool hasData(IData[string] checkData, bool deepSearch = false) {
    return checkData.keys.all!(keys => hasData(checkData[key], deepSearch));
  }
  bool hasData(IData[] checkData, bool deepSearch = false) {
    return checkData.all!(data => hasData(data, deepSearch));
  }
  bool hasData(IData checkData, bool deepSearch = false) {
    return keys.any!(key => data(key) == checkData)
      ? true
      : (deepSearch
        ? keys.any!(key => data(key).hasData(checkData, deepSearch))
        : false
      ); 
  }

  IData get(string key, IData defaultData = null) {
    return _data.get(key, defaultData);
  }

  IData data(string key) {
    return _data.get(key, null);
  }
  IData opIndex(string key) {
    return data(key);
  }

  void data(string key, IData data) {
    return _data[key] = data;
  }
  void opAssignIndex(IData data, string key) {
    data(key, data);
  }

  override string toString() {
    return _data.toString;
  }
	Json toJson(string[] selectedKeys = null) {
		Json result = Json.emptyObject;
		return result;
	}
}
// mixin(DataCalls!("Data"));
