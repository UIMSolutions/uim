/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.caches.interfaces.engine;

import uim.caches;

@safe:

interface ICacheEngine : INamed {
  /* void groupName(string name);
  string groupName();

  void items(Json[string] newItems, long timeToLive = 0);
  Json[string] items(string[] keys);

  string[] keys();

  bool merge(Json[string] newItems, long timeToLive = 0);
  bool merge(string key, Json value, long timeToLive = 0);

  bool updateKey(Json[string] newItems, long timeToLive = 0);
  bool updateKey(string key, Json value, long timeToLive = 0);

  Json[] read(string key, Json defaultValue = null);
  Json read(string key, Json defaultValue = null);

  long increment(string key, int incValue = 1);
  long decrement(string key, int decValue = 1);

  bool removeKey(string[] keys);
  bool removeKey(string key);

  bool clear();
  bool clearGroup(string groupName); */
}
