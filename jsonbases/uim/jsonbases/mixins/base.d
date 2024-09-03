module uim.jsonbases.mixins.base;

import uim.jsonbases;

@safe:
string jsonBaseThis(string name = null) {
  string fullName = `"`~name ~ "JsonBase"~`"`;
  return `
    this() {
        super(`~ fullName ~ `);
    }
    this(Json[string] initData) {
        super(`~ fullName ~ `, initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
  `;
}

template JsonBaseThis(string name = null) {
  const char[] JsonBaseThis = jsonBaseThis(name);
}

string jsonBaseCalls(string name) {
  string fullName = name ~ "JsonTenant";

  return `
auto `~fullName~`() { return new D`~fullName~`; }
auto `~fullName~`(Json[string] initData) { return new D`~fullName~`(initData); }
auto `~fullName~`(string name, Json[string] initData = null) { return new D`~fullName~`(name, initData); }
  `;
}

template JsonBaseCalls(string name) {
  const char[] JsonBaseCalls = jsonBaseCalls(name);
}
