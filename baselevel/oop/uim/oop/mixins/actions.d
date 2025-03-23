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
  {returnType} {action}{plural}({valueType}[] {parameter}...) {
    {action}{plural}({parameter}.dup);
    return this;
  }

  {returnType} {action}{plural}({valueType}[] {parameter}) {
    {parameter}.each!(value => {action}{singular}(value));
    return this;
  }
  `
  .replace("{returnType}", returnType)
  .replace("{action}", action)
  .replace("{plural}", plural)
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
  {returnType} {action}{plural}({valueType}[{keyType}] {parameter}) {
    {parameter}.each!((key, value) => {action}{singular}(key, value));
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
  .replace("{keyType}", keyType)
  .replace("{parameter}", parameter);
}

template ChangeAction(string returnType, string action, string plural, string singular, string keyType, string valueType, string parameter) {
  const char[] ChangeAction = changeAction(returnType, action, plural, singular, keyType, valueType, parameter);
}

unittest {
  writeln(changeAction("ITest", "set", "Entries", "Entry", "string", "Json", "map"));
  writeln(changeAction("ITest", "merge", "Entries", "Entry", "string", "Json", "map"));
  writeln(changeAction("ITest", "update", "Entries", "Entry", "string", "Json", "map"));
}