/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.keys;

import uim.oop;
@safe:

string doAction(string returnType, string action, string plural, string singular, string valueType,  string parameter) {
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

template DoAction(string returnType, string action, string plural, string singular, string valueType,  string parameter) {
  const char[] DoAction = doAction(returnType, action, plural, singular, valueType,  parameter);
}

unittest {
  writeln(doAction("DStringContents", "remove", "Templates", "Template", "string", "names"));
}

string removeAction(string returnType, string plural, string singular, string valueType,  string parameter) {
  return doAction(returnType, "remove", plural, singular, valueType,  parameter);
}

template RemoveAction(string returnType, string plural, string singular, string valueType,  string parameter) {
  const char[] RemoveAction = removeAction(returnType, plural, singular, valueType, parameter);
}

unittest {
  writeln(removeAction("DStringContents", "Templates", "Template", "string", "names"));
}
