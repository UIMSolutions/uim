/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.mixins.config;

import uim.oop;

@safe:
mixin template ConfigForInterface() {
  IData[string] config();
  void config(IData[string] newConfig);

  Json Data(string key);
  void Data(string key, Json newData);
}
// TODO enhance interface

template ConfigForClass() {
  protected IData[string] _Data;

  IData[string] config() {
    return _config.clone;
  }

  void config(IData[string] newData) {
    _config = newConfig.newData;
  }

  void updateConfig(IData[string] updateData) {
    updateData.byKeyValue
      .each!(kv => Data(kv.key, kv.value));
  }

  bool hasData(string key) {
    return _Data.hasKey(key);
  }

  Json Data(string key) {
    if (_Data.has(key))
      return _Data[key].clone;
    return Json(null);
  }

  void Data(string key, Json newData) {
    _Data[key] = newData.clone;
  }

  IData[string] removeConfigKeys(string[] keys...) {
    return removeConfigKeys(keys.dup);
  }

  IData[string] removeConfigKeys(string[] keys) {
    IData[string] data;
    keys.each!(key => data[key] = removeConfigKey(key));
    return data;
  }

  Json removeConfigKey(string key) {
    auto data = Data(key);
    _Data.remove(key);
    return data;
  }
}
// TODO Test 