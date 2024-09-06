module uim.models.mixins.entity;

import uim.models;
@safe: 

// #region EntityThis
string entityThis(string name = null) {
  string fullName = `"` ~ name ~ "Entity" ~`"`;
  return objThis(fullName);
}

template EntityThis(string name = null) {
  const char[] EntityThis = entityThis(name);
}
// #endregion EntityThis

// #region EntityCalls
string entityCalls(string name) {
  string fullName = name ~ "Entity";
  return objCalls(fullName);
}

template EntityCalls(string name) {
  const char[] EntityCalls = entityCalls(name);
}
// #endregion EntityCalls
