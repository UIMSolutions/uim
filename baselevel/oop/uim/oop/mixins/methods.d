/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.methods;

import uim.oop;

@safe:

// #region isMethods
// This mixin is used to generate methods for the classes that implement the methods.
string isMethods(string plural, string singular, string keyType) {
  return `
    bool isAll{plural}({keyType}[] keys...) {
      return isAll{plural}(keys.dup);
    }

    bool isAll{plural}({keyType}[] keys) {
      return keys.all!(key => is{singular}(key));
    }

    bool isAny{plural}({keyType}[] keys...) {
      return isAny{plural}(keys.dup);
    }

    bool isAny{plural}({keyType}[] keys) {
      return keys.any!(key => is{singular}(key));
    }
  `
    .replace("{plural}", plural)
    .replace("{singular}", singular)
    .replace("{keyType}", keyType);
}

template IsMethods(string plural, string singular, string keyType) {
  const char[] IsMethods = isMethods(plural, singular, keyType);
}

unittest {
  // writeln("isMethods ->", isMethods("Empty", "Empty", "string"));
}
// #endregion isMethods

// #region hasMethods
string hasMethods(string plural, string singular, string keyType) {
  return `
    bool hasAll{plural}({keyType}[] keys...) {
      return hasAll{plural}(keys.dup);
    }

    bool hasAll{plural}({keyType}[] keys) {
      return keys.all!(key => has{singular}(key));
    }

    bool hasAny{plural}({keyType}[] keys...) {
      return hasAny{plural}(keys.dup);
    }
    
    bool hasAny{plural}({keyType}[] keys) {
      return keys.any!(key => has{singular}(key));
    }
  `
    .replace("{plural}", plural)
    .replace("{singular}", singular)
    .replace("{keyType}", keyType);
}

template HasMethods(string plural, string singular, string keyType) {
  const char[] HasMethods = hasMethods(plural, singular, keyType);
}

unittest {
  // writeln("hasMethods ->", hasMethods("Entries", "Entry", "string"));
}
// #endregion hasMethods

// #region getMethods
string getMethods(string returntype, string plural, string singular, string keyType) {
  return `
    {returntype}[] get{plural}({keyType}[] keys...) {
      return get{plural}(keys.dup);
    }
    
    {returntype}[] get{plural}({keyType}[] keys) {
      return keys.map!(key => get{singular}(key)).array;
    }
  `
    .replace("{returntype}", returntype)
    .replace("{plural}", plural)
    .replace("{singular}", singular)
    .replace("{keyType}", keyType);
}

template GetMethods(string returntype, string plural, string singular, string keyType) {
  const char[] GetMethods = getMethods(returntype, plural, singular, keyType);
}

unittest {
  // writeln("getMethods ->", getMethods("Json", "Entries", "Entry", "string"));
}
// #endregion getMethods

// #region shiftMethods
string shiftMethods(string returntype, string plural, string singular, string keyType) {
  return `
    {returntype}[] shift{plural}({keyType}[] keys...) {
      return shift{plural}(keys.dup);
    }
    
    {returntype}[] shift{plural}({keyType}[] keys) {
      return keys.map!(key => shift{singular}(key)).array;
    }
  `
    .replace("{returntype}", returntype)
    .replace("{plural}", plural)
    .replace("{singular}", singular)
    .replace("{keyType}", keyType);
}

template ShiftMethods(string returntype, string plural, string singular, string keyType) {
  const char[] ShiftMethods = shiftMethods(returntype, plural, singular, keyType);
}

unittest {
  // writeln("shiftMethods ->", shiftMethods("Json", "Entries", "Entry", "string"));
}
// #endregion shiftMethods

// #region changeMethods
string changeMethods(string returntype, string action, string plural, string singular, string keyType, string valueType) {
  return `
    {returntype} {action}{plural}({valueType}[{keyType}] values) {
      values.each!((key, value) => {action}{singular}(key, value));
      return this;
    }

    {returntype} {action}{plural}({keyType}[] keys, {valueType} value) {
      keys.each!(key => {action}{singular}(key, value));
      return this;
    }    
  `
    .replace("{returntype}", returntype)
    .replace("{action}", action)
    .replace("{plural}", plural)
    .replace("{singular}", singular)
    .replace("{keyType}", keyType)
    .replace("{valueType}", valueType);
}
// #endregion changeMethods

// #region setMethods
template SetMethods(string returntype, string plural, string singular, string keyType, string valueType) {
  const char[] SetMethods = changeMethods(returntype, "set", plural, singular, keyType, valueType);
}

unittest {
  // writeln("setMethods ->", changeMethods("void", "set", "Entries", "Entry", "string", "Json"));
} 
// #endregion setMethods

// #region updateMethods
template UpdateMethods(string returntype, string plural, string singular, string keyType, string valueType) {
  const char[] UpdateMethods = changeMethods(returntype, "update", plural, singular, keyType, valueType);
}

unittest {
  // writeln("updateMethods ->", changeMethods("void", "update","Entries", "Entry", "string", "Json"));
}
// #endregion updateMethods

// #region mergeMethods
template MergeMethods(string returntype, string plural, string singular, string keyType, string valueType) {
  const char[] MergeMethods = changeMethods(returntype, "merge", plural, singular, keyType, valueType);
}

unittest {
  // writeln("mergeMethods ->", changeMethods("void", "merge", "Entries", "Entry", "string", "Json"));
}
// #endregion mergeMethods

// #region removeMethods
string removeMethods(string returntype, string plural, string singular, string keyType) {
  return `
    {returntype} remove{plural}({keyType}[] keys...) {
      return remove{plural}(keys.dup);
    }
    
    {returntype} remove{plural}({keyType}[] keys) {
      keys.each!(key => remove{singular}(key));
      return this;
    }
  `
    .replace("{returntype}", returntype)
    .replace("{plural}", plural)
    .replace("{singular}", singular)
    .replace("{keyType}", keyType);
}

template RemoveMethods(string returntype, string plural, string singular, string keyType) {
  const char[] RemoveMethods = removeMethods(returntype, plural, singular, keyType);
}

unittest {
  // writeln("removeMethods ->", removeMethods("void", "Entries", "Entry", "string"));
}
// #endregion removeMethods
