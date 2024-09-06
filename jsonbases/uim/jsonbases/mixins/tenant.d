module uim.jsonbases.mixins.tenant;

import uim.jsonbases;

@safe:
string jsonTenantThis(string name = null) {
  string fullName = `"` ~ name ~ "JsonTenant" ~ `"`;
  return objThis(fullName)
  ~(name !is null
      ? `
        this(IJsonBase base, Json[string] initData = null) { super(base, initData); }
        this(IJsonBase base, string name, Json[string] initData = null) { super(base, name, initData); }`
      : ``);
}

template JsonTenantThis(string name = null) {
  const char[] JsonTenantThis = jsonTenantThis(name);
}

string jsonTenantCalls(string name) {
  string fullName = name ~ "JsonTenant";
  return objCalls(fullName) ~
    `auto ` ~ fullName ~ `(IJsonBase base, Json[string] initData = null) { return new D` ~ fullName ~ `(base, initData); }
auto `
    ~ fullName ~ `(IJsonBase base, string name, Json[string] initData = null) { return new D` ~ fullName ~ `(base, name,initData); }
  `;
}

template JsonTenantCalls(string name) {
  const char[] JsonTenantCalls = jsonTenantCalls(name);
}
