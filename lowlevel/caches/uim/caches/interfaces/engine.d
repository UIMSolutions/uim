/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.caches.interfaces.engine;

import uim.caches;

@safe:

interface ICacheEngine : IObject {
  // #region groupName
  ICacheEngine groupName(string name);
  string groupName();

  ICacheEngine clearGroup(string groupName);
  // #endregion groupName

  // #region keys
  string[] keys();
  // #region has
  bool hasAllKeys(string[] keys...);
  bool hasAllKeys(string[] keys);
  bool hasAnyKeys(string[] keys...);
  bool hasAnyKeys(string[] keys);
  bool hasKey(string[] keys);
  // #endregion has
  // #endregion keys

  // #region entries
  ICacheEngine entries(Json[string] newItems);
  Json[string] entries(string[] keys);
  Json entry(string key, Json defaultValue = Json(null));

  ICacheEngine setEntries(Json[string] entries);
  ICacheEngine setEntries(string[] keys, Json entry);
  ICacheEngine setEntry(string key, Json entry);

  ICacheEngine mergeEntries(Json[string] entries);
  ICacheEngine mergeEntries(string[] keys, Json entry);
  ICacheEngine mergeEntry(string key, Json entry);

  ICacheEngine updateEntries(Json[string] entries);
  ICacheEngine updateEntries(string[] keys, Json entry);
  ICacheEngine updateEntry(string key, Json entry);

  ICacheEngine removeEntries(string[] keys...);
  ICacheEngine removeEntries(string[] keys);
  ICacheEngine removeEntry(string key);

  ICacheEngine clearEntries();
  // #endregion entries

  long increment(string key, int incValue = 1);
  long decrement(string key, int decValue = 1);
}
