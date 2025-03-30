/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.interfaces;

import uim.oop;
@safe:

// #region isInterfaces
// This mixin is used to generate interfaces for the classes that implement the interfaces.
string isInterfaces(string plural, string singular, string keyType) {
  return `
    bool isAll{plural}({keyType}[] keys...);
    bool isAll{plural}({keyType}[] keys);

    bool isAny{plural}({keyType}[] keys...);
    bool isAny{plural}({keyType}[] keys);

    bool is{singular}({keyType} key);
  `
  .replace("{plural}", plural)
  .replace("{singular}", singular)
  .replace("{keyType}", keyType);
}

template IsInterfaces(string plural, string singular, string keyType) {
  const char[] IsInterfaces = isInterfaces(plural, singular, keyType);
}

unittest {
  writeln("isInterfaces ->", isInterfaces("Empty", "Empty", "string"));
}
// #endregion isInterfaces

// #region hasInterfaces
string hasInterfaces(string plural, string singular, string keyType) {
  return `
    bool hasAll{plural}({keyType}[] keys...);
    bool hasAll{plural}({keyType}[] keys);

    bool hasAny{plural}({keyType}[] keys...);
    bool hasAny{plural}({keyType}[] keys);

    bool has{singular}({keyType} key);
  `
  .replace("{plural}", plural)
  .replace("{singular}", singular)
  .replace("{keyType}", keyType);
}

template HasInterfaces(string plural, string singular, string keyType) {
  const char[] HasInterfaces = hasInterfaces(plural, singular, keyType);
}

unittest {
  writeln("hasInterfaces ->", hasInterfaces("Entries", "Entry", "string"));
}
// #endregion hasInterfaces

// #region getInterfaces
string getInterfaces(string returntype, string plural, string singular, string keyType) {
  return `
    {returntype}[] get{plural}({keyType}[] keys...);
    {returntype}[] get{plural}({keyType}[] keys);

    {returntype} get{singular}({keyType} key);
  `
  .replace("{returntype}", returntype)
  .replace("{plural}", plural)
  .replace("{singular}", singular)
  .replace("{keyType}", keyType);
}

template GetInterfaces(string returntype, string plural, string singular, string keyType) {
  const char[] GetInterfaces = getInterfaces(returntype, plural, singular, keyType);
}

unittest {
  writeln("getInterfaces ->", getInterfaces("Json", "Entries", "Entry", "string"));
}
// #endregion getInterfaces

// #region shiftInterfaces
string shiftInterfaces(string returntype, string plural, string singular, string keyType) {
  return `
    {returntype}[] shift{plural}({keyType}[] keys...);
    {returntype}[] shift{plural}({keyType}[] keys);

    {returntype} shift{singular}({keyType} key);
  `
  .replace("{returntype}", returntype)
  .replace("{plural}", plural)
  .replace("{singular}", singular)
  .replace("{keyType}", keyType);
}

template ShiftInterfaces(string returntype, string plural, string singular, string keyType) {
  const char[] ShiftInterfaces = shiftInterfaces(returntype, plural, singular, keyType);
}

unittest {
  writeln("shiftInterfaces ->", shiftInterfaces("Json", "Entries", "Entry", "string"));
}
// #endregion shiftInterfaces

// #region changeInterfaces
string changeInterfaces(string returntype, string action, string plural, string singular, string keyType, string valueType) {
  return `
    {returntype} {action}{plural}({valueType}[{keyType}] values);

    {returntype} {action}{plural}({keyType} key, {valueType}[] values...);
    {returntype} {action}{plural}({keyType} key, {valueType}[] v{action}es);

    {returntype} {action}{singular}({keyType} key, {valueType} value);
  `
  .replace("{returntype}", returntype)
  .replace("{action}", action)
  .replace("{plural}", plural)
  .replace("{singular}", singular)
  .replace("{keyType}", keyType)
  .replace("{valueType}", valueType);
}
// #endregion changeInterfaces

// #region setInterfaces
template SetInterfaces(string returntype, string plural, string singular, string keyType, string valueType) {
  const char[] SetInterfaces = changeInterfaces(returntype, "set", plural, singular, keyType, valueType);
}

unittest {
  writeln("setInterfaces ->", changeInterfaces("void", "set", "Entries", "Entry", "string", "Json"));
}
// #endregion setInterfaces

// #region updateInterfaces
template UpdateInterfaces(string returntype, string plural, string singular, string keyType, string valueType) {
  const char[] UpdateInterfaces = changeInterfaces(returntype, "update", plural, singular, keyType, valueType);
}

unittest {
  writeln("updateInterfaces ->", changeInterfaces("void", "update", "Entries", "Entry", "string", "Json"));
}
// #endregion updateInterfaces

// #region mergeInterfaces
template MergeInterfaces(string returntype, string plural, string singular, string keyType, string valueType) {
  const char[] MergeInterfaces = changeInterfaces(returntype, "merge", plural, singular, keyType, valueType);
}

unittest {
  writeln("mergeInterfaces ->", changeInterfaces("void", "merge", "Entries", "Entry", "string", "Json"));
}
// #endregion mergeInterfaces

// #region removeInterfaces
string removeInterfaces(string returntype, string plural, string singular, string keyType) {
  return `
    {returntype} clear{plural}();

    {returntype} remove{plural}({keyType}[] keys...);
    {returntype} remove{plural}({keyType}[] keys);

    {returntype} remove{singular}({keyType} key);
  `
  .replace("{returntype}", returntype)
  .replace("{plural}", plural)
  .replace("{singular}", singular)
  .replace("{keyType}", keyType);
}

template RemoveInterfaces(string returntype, string plural, string singular, string keyType) {
  const char[] RemoveInterfaces = removeInterfaces(returntype, plural, singular, keyType);
}

unittest {
  writeln("removeInterfaces ->", removeInterfaces("void", "Entries", "Entry", "string"));
}
// #endregion removeInterfaces
