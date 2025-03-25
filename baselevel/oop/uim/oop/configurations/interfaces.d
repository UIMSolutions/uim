/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.configurations.interfaces;

version (test_uim_oop) {
  import std.stdio;
  
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

import uim.oop;
@safe:
interface IConfiguration : IObject {
  // #region entries
  Json[string] entries();
  void entries(Json[string] items);
  // #endregion entries

  // #region defaults
  Json[string] defaults();
  IConfiguration defaults(Json[string] items);
  // #region defaults

  // #region has
    // #region defaults
      bool hasAllDefaults(string[] keys...);
      bool hasAllDefaults(string[] keys);

      bool hasAnyDefaults(string[] keys...);
      bool hasAnyDefaults(string[] keys);

      bool hasDefault(string key);
    // #endregion defaults

    // #region entries
      bool hasAllEntries(string[] keys);
      bool hasAllEntries(string[] keys);

      bool hasAnyEntries(string[] keys);
      bool hasAnyEntries(string[] keys);

      bool hasEntry(string key);
    // #endregion entries
  // #endregion has

  // #region is
    // #region defaults
      bool isDefaultEmpty(string key);
      bool isDefaultBoolean(string key);
      bool isDefaultLong(string key);
      bool isDefaultDouble(string key);
      bool isDefaultString(string key);
      bool isDefaultArray(string key);
      bool isDefaultMap(string key);
    // #endregion defaults

    // #region entries
      bool isEmpty(string key);
      bool isBoolean(string key);
      bool isLong(string key);
      bool isDouble(string key);
      bool isString(string key);
      bool isArray(string key);
      bool isMap(string key);
    // #endregion entries
  // #endregion is

  // #region keys
    // #region defaults
      bool hasDefaultAllKeys(string[] keys...);
      bool hasDefaultAllKeys(string[] keys);

      bool hasDefaultAnyKeys(string[] keys...);
      bool hasDefaultAnyKeys(string[] keys);

      bool hasDefaultKey(string key);

      string[] defaultKeys();
    // #endregion defaults

    // #region entries
      bool hasAllKeys(string[] keys...);
      bool hasAllKeys(string[] keys);

      bool hasAnyKeys(string[] keys...);
      bool hasAnyKeys(string[] keys);

      bool hasKey(string key);

      string[] keys();
    // #endregion entries
  // #endregion keys

  // #region values
    // #region defaults
      bool hasDefaultAllValues(string[] values...);
      bool hasDefaultAllValues(string[] values);

      bool hasDefaultAnyValues(string[] values...);
      bool hasDefaultAnyValues(string[] values);

      bool hasDefaultValue(string value);
    // #endregion defaults

    // #region entries
      bool hasAllValues(string[] values...);
      bool hasAllValues(string[] values);

      bool hasAnyValues(string[] values...);
      bool hasAnyValues(string[] values);

      bool hasValue(string value);

      Json[] values(string[] includedKeys = null);
    // #endregion entries
  // #endregion values

  // #region get
    // #region defaults
      Json[string] getDefaults(string[] keys...);
      Json[string] getDefaults(string[] keys);

      Json getDefault(string key);

      bool getDefaultBoolean(string key);
      long getDefaultLong(string key);
      double getDefaultDouble(string key);
      string getDefaultString(string key);
      string[] getDefaultStringArray(string key);
      Json[] getDefaultArray(string key);
      Json[string] getDefaultMap(string key);
      string[string] getDefaultStringMap(string key);
    // #endregion defaults

    // #region entries
      Json[string] getEntries(string[] keys...);
      Json[string] getEntries(string[] keys);

      Json opIndex(string key);
      Json getEntry(string key);

      bool getBoolean(string key);
      long getLong(string key);
      double getDouble(string key);
      string getString(string key);
      string[] getStringArray(string key);
      Json[] getArray(string key);
      Json[string] getMap(string key);
      string[string] getStringMap(string key);
    // #endregion entries
  // #endregion get

  Json shift(string key);
  void opAssign(Json[string] data);

  //#region set
    // #region defaults
      IConfiguration setDefaults(bool[string] items, string[] validKeys = null);
      IConfiguration setDefaults(string[] keys, bool value);

      IConfiguration setDefaults(long[string] items, string[] validKeys = null);
      IConfiguration setDefaults(string[] keys, long value);

      IConfiguration setDefaults(double[string] items, string[] validKeys = null);
      IConfiguration setDefaults(string[] keys, double value);

      IConfiguration setDefaults(string[string] items, string[] validKeys = null);
      IConfiguration setDefaults(string[] keys, string value);

      IConfiguration setDefaults(Json[string] items, string[] validKeys = null);
      IConfiguration setDefaults(string[] keys, Json value);

      IConfiguration setDefaults(Json[][string] items, string[] validKeys = null);
      IConfiguration setDefaults(string[] keys, Json[] value);

      IConfiguration setDefaults(Json[string][string] items, string[] validKeys = null);
      IConfiguration setDefaults(string[] keys, Json[string] value);
    // #endregion defaults
    
    // #region default
      IConfiguration setDefault(string key, bool value);
      IConfiguration setDefault(string key, long value);
      IConfiguration setDefault(string key, double value);
      IConfiguration setDefault(string key, string value);
      IConfiguration setDefault(string key, Json value);
      IConfiguration setDefault(string key, Json[] value);
      IConfiguration setDefault(string key, Json[string] value);
    // #endregion default
    
    //#region entries
      IConfiguration setEntries(bool[string] items, string[] validKeys = null);
      IConfiguration setEntries(string[] keys, bool value);

      IConfiguration setEntries(long[string] items, string[] validKeys = null);
      IConfiguration setEntries(string[] keys, long value);

      IConfiguration setEntries(double[string] items, string[] validKeys = null);
      IConfiguration setEntries(string[] keys, double value);

      IConfiguration setEntries(string[string] items, string[] validKeys = null);
      IConfiguration setEntries(string[] keys, string value);

      IConfiguration setEntries(Json[string] items, string[] validKeys = null);
      IConfiguration setEntries(string[] keys, Json value);

      IConfiguration setEntries(Json[][string] items, string[] validKeys = null);
      IConfiguration setEntries(string[] keys, Json[] value);

      IConfiguration setEntries(Json[string][string] items, string[] validKeys = null);
      IConfiguration setEntries(string[] keys, Json[string] value);
    //#endregion entries

    //#region entry
      IConfiguration setEntry(string key, bool value);
      IConfiguration setEntry(string key, long value);
      IConfiguration setEntry(string key, double value);
      IConfiguration setEntry(string key, string value);
      IConfiguration setEntry(string key, Json value);
      IConfiguration setEntry(string key, Json[] value);
      IConfiguration setEntry(string key, Json[string] value);

      void opIndexAssign(bool value, string key);
      void opIndexAssign(long value, string key);
      void opIndexAssign(double value, string key);
      void opIndexAssign(string value, string key);
      void opIndexAssign(Json value, string key);
      void opIndexAssign(Json[] value, string key);
      void opIndexAssign(Json[string] value, string key);
    //#endregion entry
  //#endregion set

  //#region update
    // #region defaults
      IConfiguration updateDefaults(bool[string] items, string[] validKeys = null);
      IConfiguration updateDefaults(string[] keys, bool value);

      IConfiguration updateDefaults(long[string] items, string[] validKeys = null);
      IConfiguration updateDefaults(string[] keys, long value);

      IConfiguration updateDefaults(double[string] items, string[] validKeys = null);
      IConfiguration updateDefaults(string[] keys, double value);

      IConfiguration updateDefaults(string[string] items, string[] validKeys = null);
      IConfiguration updateDefaults(string[] keys, string value);

      IConfiguration updateDefaults(Json[string] items, string[] validKeys = null);
      IConfiguration updateDefaults(string[] keys, Json value);

      IConfiguration updateDefaults(Json[][string] items, string[] validKeys = null);
      IConfiguration updateDefaults(string[] keys, Json[] value);

      IConfiguration updateDefaults(Json[string][string] items, string[] validKeys = null);
      IConfiguration updateDefaults(string[] keys, Json[string] value);
    // #endregion defaults
    
    // #region default
      IConfiguration updateDefault(string key, bool value);
      IConfiguration updateDefault(string key, long value);
      IConfiguration updateDefault(string key, double value);
      IConfiguration updateDefault(string key, string value);
      IConfiguration updateDefault(string key, Json value);
      IConfiguration updateDefault(string key, Json[] value);
      IConfiguration updateDefault(string key, Json[string] value);
    // #endregion default

    //#region entries
      IConfiguration updateEntries(bool[string] items, string[] validKeys = null);
      IConfiguration updateEntries(string[] keys, bool value);

      IConfiguration updateEntries(long[string] items, string[] validKeys = null);
      IConfiguration updateEntries(string[] keys, long value);

      IConfiguration updateEntries(double[string] items, string[] validKeys = null);
      IConfiguration updateEntries(string[] keys, double value);

      IConfiguration updateEntries(string[string] items, string[] validKeys = null);
      IConfiguration updateEntries(string[] keys, string value);

      IConfiguration updateEntries(Json[string] items, string[] validKeys = null);
      IConfiguration updateEntries(string[] keys, Json value);

      IConfiguration updateEntries(Json[][string] items, string[] validKeys = null);
      IConfiguration updateEntries(string[] keys, Json[] value);

      IConfiguration updateEntries(Json[string][string] items, string[] validKeys = null);
      IConfiguration updateEntries(string[] keys, Json[string] value);
    //#endregion entries

    //#region entry
      IConfiguration updateEntry(string key, bool value);
      IConfiguration updateEntry(string key, long value);
      IConfiguration updateEntry(string key, double value);
      IConfiguration updateEntry(string key, string value);
      IConfiguration updateEntry(string key, Json value);
      IConfiguration updateEntry(string key, Json[] value);
      IConfiguration updateEntry(string key, Json[string] value);
    //#endregion entry
  //#endregion update

  //#region merge
    // #region defaults
      IConfiguration mergeDefaults(bool[string] items, string[] validKeys = null);
      IConfiguration mergeDefaults(string[] keys, bool value);

      IConfiguration mergeDefaults(long[string] items, string[] validKeys = null);
      IConfiguration mergeDefaults(string[] keys, long value);

      IConfiguration mergeDefaults(double[string] items, string[] validKeys = null);
      IConfiguration mergeDefaults(string[] keys, double value);

      IConfiguration mergeDefaults(string[string] items, string[] validKeys = null);
      IConfiguration mergeDefaults(string[] keys, string value);

      IConfiguration mergeDefaults(Json[string] items, string[] validKeys = null);
      IConfiguration mergeDefaults(string[] keys, Json value);

      IConfiguration mergeDefaults(Json[][string] items, string[] validKeys = null);
      IConfiguration mergeDefaults(string[] keys, Json[] value);

      IConfiguration mergeDefaults(Json[string][string] items, string[] validKeys = null);
      IConfiguration mergeDefaults(string[] keys, Json[string] value);
    // #endregion defaults
    
    // #region default
      IConfiguration mergeDefault(string key, bool value);
      IConfiguration mergeDefault(string key, long value);
      IConfiguration mergeDefault(string key, double value);
      IConfiguration mergeDefault(string key, string value);
      IConfiguration mergeDefault(string key, Json value);
      IConfiguration mergeDefault(string key, Json[] value);
      IConfiguration mergeDefault(string key, Json[string] value);
    // #endregion default

    // #region entries
      IConfiguration mergeEntries(bool[string] items, string[] validKeys = null);
      IConfiguration mergeEntries(string[] keys, bool value);

      IConfiguration mergeEntries(long[string] items, string[] validKeys = null);
      IConfiguration mergeEntries(string[] keys, long value);

      IConfiguration mergeEntries(double[string] items, string[] validKeys = null);
      IConfiguration mergeEntries(string[] keys, double value);

      IConfiguration mergeEntries(string[string] items, string[] validKeys = null);
      IConfiguration mergeEntries(string[] keys, string value);

      IConfiguration mergeEntries(Json[string] items, string[] validKeys = null);
      IConfiguration mergeEntries(string[] keys, Json value);

      IConfiguration mergeEntries(Json[][string] items, string[] validKeys = null);
      IConfiguration mergeEntries(string[] keys, Json[] value);

      IConfiguration mergeEntries(Json[string][string] items, string[] validKeys = null);
      IConfiguration mergeEntries(string[] keys, Json[string] value);
    // #endregion entries

    // #region entry
      IConfiguration mergeEntry(string key, bool value);
      IConfiguration mergeEntry(string key, long value);
      IConfiguration mergeEntry(string key, double value);
      IConfiguration mergeEntry(string key, string value);
      IConfiguration mergeEntry(string key, Json value);
      IConfiguration mergeEntry(string key, Json[] value);
      IConfiguration mergeEntry(string key, Json[string] value);
    // #endregion entry
  // #endregion merge

  // #region remove
    // #region defaults
      IConfiguration removeDefaults(string[] keys...);
      IConfiguration removeDefaults(string[] keys);
      IConfiguration removeDefault(string key);

      IConfiguration clearDefaults();
    // #endregion defaults

    // #region entries
      IConfiguration removeEntries(string[] keys...);
      IConfiguration removeEntries(string[] keys);
      IConfiguration removeEntry(string key);

      IConfiguration clearEntries();
    // #endregion entries
  // #endregion remove
}
