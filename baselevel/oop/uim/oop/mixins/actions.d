/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.actions;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

string getInterfaceAction(string returnType, string action, string plural, string singular, string keyType) {
  return `
  {returnType}[] {action}{plural}({keyType}[] keys...); 
  {returnType}[] {action}{plural}({keyType}[] keys); 
  {returnType} {action}{singular}({keyType} key); 
  `
  .replace("{returnType}", returnType)
  .replace("{action}", action)
  .replace("{plural}", plural)
  .replace("{singular}", singular)
  .replace("{keyType}", keyType);
}

template GetInterfaceAction(string returnType, string action, string plural, string singular, string keyType) {
  const char[] GetInterfaceAction = getInterfaceAction(returnType, action, plural, singular, keyType);
}

template ReadInterfaceAction(string returnType, string plural, string singular, string keyType) {
  const char[] ReadInterfaceAction = GetInterfaceAction(returnType, "", plural, singular, keyType);
}

string getAction(string returnType, string action, string plural, string singular, string keyType) {
  return `
  {returnType}[] {action}{plural}({keyType}[] keys...) {
    return {action}{plural}(keys.dup);
  }

  {returnType}[] {action}{plural}({keyType}[] keys) {
    return keys.map!(key => {action}{singular}(key)).array;
  }
  `
  .replace("{returnType}", returnType)
  .replace("{action}", action)
  .replace("{plural}", plural)
  .replace("{singular}", singular)
  .replace("{keyType}", keyType);
}

template GetAction(string returnType, string action, string plural, string singular, string keyType) {
  const char[] GetAction = getAction(returnType, action, plural, singular, keyType);
}

template ReadAction(string returnType, string plural, string singular, string keyType) {
  const char[] ReadAction = getAction(returnType, "", plural, singular, keyType);
}

string doInterfaceAction(string returnType, string action, string plural, string singular, string valueType) {
  return `
  {returnType} {action}{criteria}({valueType}[] values...);
  {returnType} {action}{criteria}({valueType}[] values);
  `
  .replace("{returnType}", returnType)
  .replace("{action}", action)
  .replace("{criteria}", plural)
  .replace("{singular}", singular)
  .replace("{valueType}", valueType);
}

template DoInterfaceAction(string returnType, string action, string plural, string singular, string valueType) {
  const char[] DoInterfaceAction = doInterfaceAction(returnType, action, plural, singular, valueType);
}

string doAction(string returnType, string action, string plural, string singular, string valueType) {
  return `
  {returnType} {action}{criteria}({valueType}[] values...) {
    {action}{criteria}(values.dup);
    return this;
  }

  {returnType} {action}{criteria}({valueType}[] values) {
    values.each!(value => {action}{singular}(value));
    return this;
  }
  `
  .replace("{returnType}", returnType)
  .replace("{action}", action)
  .replace("{criteria}", plural)
  .replace("{singular}", singular)
  .replace("{valueType}", valueType);
}

template DoAction(string returnType, string action, string plural, string singular, string valueType) {
  const char[] DoAction = doAction(returnType, action, plural, singular, valueType, parameter);
}

unittest {
  writeln(doAction("DStringContents", "remove", "Templates", "Template", "string"));
}

string removeAction(string returnType, string plural, string singular, string valueType) {
  return doAction(returnType, "remove", plural, singular, valueType);
}

template RemoveAction(string returnType, string plural, string singular, string valueType) {
  const char[] RemoveAction = removeAction(returnType, plural, singular, valueType);
}

unittest {
  writeln(removeAction("DStringContents", "Templates", "Template", "string"));
}

string changeInterfaceAction(string returnType, string action, string plural, string singular, string keyType, string valueType) {
  return `
  {returnType} {action}{criteria}({valueType}[{keyType}] values, {keyType}[] keys = null);
  {returnType} {action}{criteria}({keyType}[] keys, {valueType} value);
  {returnType} {action}{criteria}({keyType} key, {valueType} value);
  `
  .replace("{returnType}", returnType)
  .replace("{action}", action)
  .replace("{criteria}", plural)
  .replace("{singular}", singular)
  .replace("{valueType}", valueType)
  .replace("{keyType}", keyType);
}

template ChangeInterfaceAction(string returnType, string action, string plural, string singular, string keyType, string valueType) {
  const char[] ChangeInterfaceAction = changeInterfaceAction(returnType, action, plural, singular, keyType, valueType);
}

template SetInterfaceAction(string returnType, string plural, string singular, string keyType, string valueType) {
  const char[] SetInterfaceAction = changeInterfaceAction(returnType, "set", plural, singular, keyType, valueType);
}

template MergeInterfaceAction(string returnType, string plural, string singular, string keyType, string valueType) {
  const char[] MergeInterfaceAction = changeInterfaceAction(returnType, "merge", plural, singular, keyType, valueType);
}

template UpdateInterfaceAction(string returnType, string plural, string singular, string keyType, string valueType) {
  const char[] UpdateInterfaceAction = changeInterfaceAction(returnType, "update", plural, singular, keyType, valueType);
}

string changeAction(string returnType, string action, string plural, string singular, string keyType, string valueType) {
  return `
  {returnType} {action}{plural}({valueType}[{keyType}] values, {keyType}[] keys = null) {
    if (keys.isNull) {
      values.each!((key, value) => {action}{singular}(key, value));
    }
    else {
      keys
        .filter!(key => values.hasKey(key))
        .each!(key => {action}{singular}(key, values[key]));
    }

    return this;
  }

  {returnType} {action}{plural}({keyType}[] keys, {valueType} value) {
    keys.each!(key => {action}{singular}(key, value));
    return this;
  }
  `
  .replace("{returnType}", returnType)
  .replace("{action}", action)
  .replace("{plural}", plural)
  .replace("{singular}", singular)
  .replace("{valueType}", valueType)
  .replace("{keyType}", keyType);
}

template ChangeAction(string returnType, string action, string plural, string singular, string keyType, string valueType) {
  const char[] ChangeAction = changeAction(returnType, action, plural, singular, keyType, valueType);
}

template SetAction(string returnType, string plural, string singular, string keyType, string valueType) {
  const char[] SetAction = changeAction(returnType, "set", plural, singular, keyType, valueType);
}

template MergeAction(string returnType, string plural, string singular, string keyType, string valueType) {
  const char[] MergeAction = changeAction(returnType, "merge", plural, singular, keyType, valueType);
}

template UpdateAction(string returnType, string plural, string singular, string keyType, string valueType) {
  const char[] UpdateAction = changeAction(returnType, "update", plural, singular, keyType, valueType);
}

unittest {
  writeln(changeAction("ITest", "set", "Entries", "Entry", "string", "Json"));
  writeln(changeAction("ITest", "merge", "Entries", "Entry", "string", "Json"));
  writeln(changeAction("ITest", "update", "Entries", "Entry", "string", "Json"));
}

string checkAction(string action, string criteria, string plural, string singular, string keyType) {
  return `
  bool {action}All{criteria}{plural}({keyType}[] keys...) {
    return {action}All{criteria}{plural}(keys.dup);
  }

  bool {action}All{criteria}{plural}({keyType}[] keys) {
    return keys.all!(value => {action}{criteria}{singular}(value));
  }

  bool {action}Any{criteria}{plural}({keyType}[] keys...) {
    return {action}Any{criteria}{plural}(keys.dup);
  }

  bool {action}Any{criteria}{plural}({keyType}[] keys) {
    return keys.any!(value => {action}{criteria}{singular}(value));
  }
  `
  .replace("{action}", action)
  .replace("{criteria}", criteria)
  .replace("{plural}", plural)
  .replace("{singular}", singular)
  .replace("{keyType}", keyType);
}

unittest {
  writeln(checkAction("is", "Boolean", "Entries", "Entry", "string"));
  writeln(checkAction("has", "", "Entries", "Entry", "string"));
}

template IsAction(string criteria, string plural, string singular, string keyType) {
  const char[] IsAction = checkAction("is", criteria, plural, singular, keyType);
}

template HasAction(string plural, string singular, string keyType) {
  const char[] HasAction = checkAction("has", "", plural, singular, keyType);
}