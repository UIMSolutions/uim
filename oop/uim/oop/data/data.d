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

  string[] keys() {
    return _data.keys;
  }

  IData[] values() {
    return _data.values;
  }

  bool isEqual(IData[string] checkData) {
    return hasKeys(checkData.keys) 
      ? checkData.keys.all!(key => checkData[key] == get(key))
      : false;
  }

  bool hasPath(string path, string separator = "/") {
    return hasPaths(path.split(separator));
  }

  bool hasPaths(string[] paths) {
    switch (paths.length) {
      case 0: return false;
      case 1: return hasKey(paths[0]);
      default: return hasPaths(paths[1..$]);
    }
  }

  bool hasKeys(string[] keys, bool deepSearch = false) {
    return keys.all!(key => hasKey(key, deepSearch));
  }

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
    return _data.get(key);
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
  Json toJson() {
    	
  }
}
