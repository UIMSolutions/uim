/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.configurations.interfaces;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

interface IConfiguration : IObject {
  // #region entries
    Json[string] entries();
    IConfiguration entries(Json[string] newEntries);
  // #endregion entries

  // #region values
    string[] entryKeys();
  // #endregion values

  // #region values
    Json[] entryValues();
  // #endregion values

  // #region has
    mixin(HasInterfaces!("Entries", "Entry", "string"));
  
    mixin(HasInterfaces!("EntryValues", "EntryValue", "bool"));
    mixin(HasInterfaces!("EntryValues", "EntryValue", "long"));
    mixin(HasInterfaces!("EntryValues", "EntryValue", "double"));
    mixin(HasInterfaces!("EntryValues", "EntryValue", "string"));
    mixin(HasInterfaces!("EntryValues", "EntryValue", "Json[]"));
    mixin(HasInterfaces!("EntryValues", "EntryValue", "Json[string]"));
    mixin(HasInterfaces!("EntryValues", "EntryValue", "Json"));
  // #endregion has

  // #region is
    mixin(IsInterfaces!("EmptyEntries", "EmptyEntry", "string"));
    mixin(IsInterfaces!("BooleanEntries", "BooleanEntry", "string"));
    mixin(IsInterfaces!("LongEntries", "LongEntry", "string")); 
    mixin(IsInterfaces!("DoubleEntries", "DoubleEntry", "string"));
    mixin(IsInterfaces!("StringEntries", "StringEntry", "string"));
    mixin(IsInterfaces!("ArrayEntries", "ArrayEntry", "string"));
    mixin(IsInterfaces!("MapEntries", "MapEntry", "string"));
  // #endregion is

  // #region get
    mixin(GetInterfaces!("bool", "BooleanEntries", "BooleanEntry", "string"));
    mixin(GetInterfaces!("long", "LongEntries", "LongEntry", "string"));
    mixin(GetInterfaces!("double", "DoubleEntries", "DoubleEntry", "string"));
    mixin(GetInterfaces!("string", "StringEntries", "StringEntry", "string"));
    mixin(GetInterfaces!("Json[]", "ArrayEntries", "ArrayEntry", "string"));
    mixin(GetInterfaces!("Json[string]", "MapEntries", "MapEntry", "string"));
    mixin(GetInterfaces!("Json", "Entries", "Entry", "string"));
  // #endregion get

  // #region shift
    mixin(ShiftInterfaces!("Json", "Entries", "Entry", "string"));
  // #endregion shift

  //#region set
    mixin(SetInterfaces!("IConfiguration", "Entries", "Entry", "string", "bool"));
    mixin(SetInterfaces!("IConfiguration", "Entries", "Entry", "string", "long"));
    mixin(SetInterfaces!("IConfiguration", "Entries", "Entry", "string", "double"));
    mixin(SetInterfaces!("IConfiguration", "Entries", "Entry", "string", "string"));
    mixin(SetInterfaces!("IConfiguration", "Entries", "Entry", "string", "Json[]"));
    mixin(SetInterfaces!("IConfiguration", "Entries", "Entry", "string", "Json[string]"));
    mixin(SetInterfaces!("IConfiguration", "Entries", "Entry", "string", "Json"));
  //#endregion set

  //#region update
    mixin(UpdateInterfaces!("IConfiguration", "Entries", "Entry", "string", "bool"));
    mixin(UpdateInterfaces!("IConfiguration", "Entries", "Entry", "string", "long"));
    mixin(UpdateInterfaces!("IConfiguration", "Entries", "Entry", "string", "double"));
    mixin(UpdateInterfaces!("IConfiguration", "Entries", "Entry", "string", "string"));
    mixin(UpdateInterfaces!("IConfiguration", "Entries", "Entry", "string", "Json[]"));
    mixin(UpdateInterfaces!("IConfiguration", "Entries", "Entry", "string", "Json[string]"));
    mixin(UpdateInterfaces!("IConfiguration", "Entries", "Entry", "string", "Json"));
  //#endregion update

  //#region merge
    mixin(MergeInterfaces!("IConfiguration", "Entries", "Entry", "string", "bool"));
    mixin(MergeInterfaces!("IConfiguration", "Entries", "Entry", "string", "long"));
    mixin(MergeInterfaces!("IConfiguration", "Entries", "Entry", "string", "double"));
    mixin(MergeInterfaces!("IConfiguration", "Entries", "Entry", "string", "string"));
    mixin(MergeInterfaces!("IConfiguration", "Entries", "Entry", "string", "Json[]"));
    mixin(MergeInterfaces!("IConfiguration", "Entries", "Entry", "string", "Json[string]"));
    mixin(MergeInterfaces!("IConfiguration", "Entries", "Entry", "string", "Json"));
  // #endregion merge

  // #region remove
    mixin(RemoveInterfaces!("IConfiguration", "Entries", "Entry", "string"));
  // #endregion remove

  // #region clone
    IConfiguration clone();
  // #endregion clone
}
