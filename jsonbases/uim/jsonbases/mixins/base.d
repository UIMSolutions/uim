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
  string fullName = name ~ "JsonTenant";
  return objCalls(fullName);
}

template JsonBaseCalls(string name) {
  const char[] JsonBaseCalls = jsonBaseCalls(name);
}
