/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.caches.interfaces.engine;

import uim.caches;

@safe:

interface ICacheEngine : IObject {
  void groupName(string name);
  string groupName();

  void items(Json[string] newItems);
  Json[string] items(string[] keys);

  string[] keys();

  ICacheEngine setEntries(Json[string] entries);
  ICacheEngine setEntries(string[] keys, Json entry);
  ICacheEngine setEntry(string key, Json entry);

  ICacheEngine mergeEntries(Json[string] entries);
  ICacheEngine mergeEntries(string[] keys, Json entry);
  ICacheEngine mergeEntry(string key, Json entry);

  ICacheEngine updateEntries(Json[string] entries);
  ICacheEngine updateEntries(string[] keys, Json entry);
  ICacheEngine updateEntry(string key, Json entry);

  Json[] read(string key, Json defaultValue = null);
  Json read(string key, Json defaultValue = null);

  long increment(string key, int incValue = 1);
  long decrement(string key, int decValue = 1);

  // #region remove
  bool removeEntries(string[] keys...);
  bool removeEntries(string[] keys);
  bool removeEntry(string key);
  // #endregion remove

  bool clear();
  bool clearGroup(string groupName);
}
