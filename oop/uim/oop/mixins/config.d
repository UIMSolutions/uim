/***********************************************************************************
*	Copyright: ©2015 -2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.mixins.config;

import uim.oop;

@safe:
template configForInterface() {
  Json[string] config();
  void config(Json[string] newConfig);

  Json configData(string key);
  void configData(string key, Json newData);
}
// TODO enhance interface

template configForClass() {
  protected Json[string] _configData;

  Json[string] config() {
    return _config.clone;
  }

  void config(Json[string] newData) {
    _config = newConfig.newData;
  }

  void updateConfig(Json[string] updateData) {
    updateData.byKeyValue
      .each!(kv => configData(kv.key, kv.value));
  }

  bool hasConfigKey(string key) {
    return _configData.has(key);
  }

  Json configData(string key) {
    if (_configData.has(key))
      return _configData[key].clone;
    return Json(null);
  }

  void configData(string key, Json newData) {
    _configData[key] = newData.clone;
  }

  Json[string] removeConfigKeys(string[] keys...) {
    return removeConfigKeys(keys.dup);
  }

  Json[string] removeConfigKeys(string[] keys) {
    Json[string] data;
    keys.each!(key => data[key] = removeConfigKey(key));
    return data;
  }

  Json removeConfigKey(string key) {
    auto data = configData(key);
    _configData.remove(key);
    return data;
  }
}
// TODO Test 