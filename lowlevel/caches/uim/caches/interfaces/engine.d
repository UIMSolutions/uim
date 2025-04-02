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

  string[] keys();

  // #region entries
  ICacheEngine entries(Json[string] newItems);
  Json[string] entries();
  // #endregion entries

  mixin(HasInterfaces!("Entries", "Entry", "string"));
  mixin(GetInterfaces!("Json", "Entries", "Entry", "string"));
  mixin(SetInterfaces!("ICacheEngine", "Entries", "Entry", "string", "Json"));
  mixin(MergeInterfaces!("ICacheEngine", "Entries", "Entry", "string", "Json"));
  mixin(UpdateInterfaces!("ICacheEngine", "Entries", "Entry", "string", "Json"));
  mixin(RemoveInterfaces!("ICacheEngine", "Entries", "Entry", "string"));

  long increment(string key, int incValue = 1);
  long decrement(string key, int decValue = 1);
}
