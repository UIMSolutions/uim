/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.actions;

import uim.oop;
@safe:

version (test_uim_oop) {
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

string doAction(string returnType, string action, string plural, string singular, string valueType, string parameter) {
  return `
  {returnType} {action}{criteria}({valueType}[] {parameter}...) {
    {action}{criteria}({parameter}.dup);
    return this;
  }

  {returnType} {action}{criteria}({valueType}[] {parameter}) {
    {parameter}.each!(value => {action}{singular}(value));
    return this;
  }
  `
  .replace("{returnType}", returnType)
  .replace("{action}", action)
  .replace("{criteria}", plural)
  .replace("{singular}", singular)
  .replace("{valueType}", valueType)
  .replace("{parameter}", parameter);
}

template DoAction(string returnType, string action, string plural, string singular, string valueType, string parameter) {
  const char[] DoAction = doAction(returnType, action, plural, singular, valueType, parameter);
}

unittest {
  writeln(doAction("DStringContents", "remove", "Templates", "Template", "string", "names"));
}

string removeAction(string returnType, string plural, string singular, string valueType, string parameter) {
  return doAction(returnType, "remove", plural, singular, valueType, parameter);
}

template RemoveAction(string returnType, string plural, string singular, string valueType, string parameter) {
  const char[] RemoveAction = removeAction(returnType, plural, singular, valueType, parameter);
}

unittest {
  writeln(removeAction("DStringContents", "Templates", "Template", "string", "names"));
}

string changeAction(string returnType, string action, string plural, string singular, string keyType, string valueType, string parameter) {
  return `
  {returnType} {action}{criteria}({valueType}[{keyType}] {parameter}, {keyType}[] keys = null) {
    if (keys.isNull) {
      {parameter}.each!((key, value) => {action}{singular}(key, value));
    }
    else {
      keys
        .filter!(key => {parameter}.hasKey(key))
        .each!(key => {action}{singular}(key, {parameter}[key]));
    }

    return this;
  }

  {returnType} {action}{criteria}({keyType}[] keys, {valueType} value) {
    keys.each!(key => {action}{singular}(key, value));
    return this;
  }
  `
  .replace("{returnType}", returnType)
  .replace("{action}", action)
  .replace("{criteria}", plural)
  .replace("{singular}", singular)
  .replace("{valueType}", valueType)
  .replace("{keyType}", keyType)
  .replace("{parameter}", parameter);
}

template ChangeAction(string returnType, string action, string plural, string singular, string keyType, string valueType, string parameter = "values") {
  const char[] ChangeAction = changeAction(returnType, action, plural, singular, keyType, valueType, parameter);
}

template SetAction(string returnType, string plural, string singular, string keyType, string valueType, string parameter = "values") {
  const char[] SetAction = changeAction(returnType, "set", plural, singular, keyType, valueType, parameter);
}

template MergeAction(string returnType, string plural, string singular, string keyType, string valueType, string parameter = "values") {
  const char[] MergeAction = changeAction(returnType, "merge", plural, singular, keyType, valueType, parameter);
}

template UpdateAction(string returnType, string plural, string singular, string keyType, string valueType, string parameter = "values") {
  const char[] UpdateAction = changeAction(returnType, "update", plural, singular, keyType, valueType, parameter);
}

unittest {
  writeln(changeAction("ITest", "set", "Entries", "Entry", "string", "Json", "map"));
  writeln(changeAction("ITest", "merge", "Entries", "Entry", "string", "Json", "map"));
  writeln(changeAction("ITest", "update", "Entries", "Entry", "string", "Json", "map"));
}

string checkAction(string action, string criteria, string plural, string singular, string keyType, string parameter) {
  return `
  bool {action}All{criteria}{plural}({keyType}[] {parameter}...) {
    return {action}All{criteria}{plural}({parameter}.dup);
  }

  bool {action}All{criteria}{plural}({keyType}[] {parameter}) {
    return {parameter}.all!(value => {action}{criteria}{singular}(value));
  }

  bool {action}Any{criteria}{plural}({keyType}[] {parameter}...) {
    return {action}Any{criteria}{plural}({parameter}.dup);
  }

  bool {action}Any{criteria}{plural}({keyType}[] {parameter}) {
    return {parameter}.any!(value => {action}{criteria}{singular}(value));
  }
  `
  .replace("{action}", action)
  .replace("{criteria}", criteria)
  .replace("{plural}", plural)
  .replace("{singular}", singular)
  .replace("{keyType}", keyType)
  .replace("{parameter}", parameter);
}

unittest {
  writeln(checkAction("is", "Boolean", "Entries", "Entry", "string", "keys"));
  writeln(checkAction("has", "", "Entries", "Entry", "string", "keys"));
}

template IsAction(string criteria, string plural, string singular, string keyType, string parameter) {
  const char[] IsAction = checkAction("is", criteria, plural, singular, keyType, parameter);
}

template HasAction(string plural, string singular, string keyType, string parameter) {
  const char[] HasAction = checkAction("has", "", plural, singular, keyType, parameter);
}