/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.mixins.base;

import uim.jsonbases;

@safe:

string jsonBaseThis(string name = null) {
  string fullName = name ~ "JsonBase";
  return objThis(fullName);
}

template JsonBaseThis(string name = null) {
  const char[] JsonBaseThis = jsonBaseThis(name);
}

string jsonBaseCalls(string name) {
  string fullName = name ~ "JsonBase";
  return objCalls(fullName);
}

template JsonBaseCalls(string name) {
  const char[] JsonBaseCalls = jsonBaseCalls(name);
}
