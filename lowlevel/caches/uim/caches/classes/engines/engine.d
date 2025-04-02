/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.caches.classes.engines.file;

mixin(Version!"test_uim_caches");

import uim.caches;
@safe:

// Storage engine for UIM caching
class DCacheEngine : UIMObject, ICacheEngine {
  mixin(CacheEngineThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }
    
    return true;
  }
  
  // #region timeToLive
  long timeToLive();
  // #region timeToLive

  // #region groupName
  abstract ICacheEngine groupName(string name);
  abstract string groupName();

  abstract ICacheEngine clearGroup(string groupName);
  // #endregion groupName

  // #region keys
  abstract string[] keys();
  // #endregion keys

  // #region entries
  abstract ICacheEngine entries(Json[string] newItems);
  abstract Json[string] entries();
  // #endregion entries

  // #region has
    mixin(HasMethods!("Entries", "Entry", "string"));
    abstract bool hasEntry(string key);
  // #endregion has
  
  // #region get
  mixin(GetInterfaces!("Json", "Entries", "Entry", "string"));
  abstract Json getEntry(string key);
  // #endregion has

  // #region set
  mixin(SetInterfaces!("ICacheEngine", "Entries", "Entry", "string", "Json"));
  abstract ICacheEngine setEntry(string key, Json value);
  // #endregion set

  // #region merge
  mixin(MergeInterfaces!("ICacheEngine", "Entries", "Entry", "string", "Json"));
  abstract ICacheEngine mergeEntry(string key, Json value);
  // #endregion merge

  // #region update
  mixin(UpdateInterfaces!("ICacheEngine", "Entries", "Entry", "string", "Json"));
  abstract ICacheEngine updateEntry(string key, Json value);
  // #endregion update

  // #region remove
  mixin(RemoveInterfaces!("ICacheEngine", "Entries", "Entry", "string"));
  abstract ICacheEngine removeEntry(string key);
  abstract ICacheEngine clearEntries(string key);
  // #endregion remove

  abstract long increment(string key, int incValue = 1);
  abstract long decrement(string key, int decValue = 1);
}