module uim.jsonbases.mixins.tenant;

import uim.jsonbases;

@safe:
string jsonTenantThis(string name = null) {
  string fullName = name ~ "JsonTenant";
  return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }`
    ~(name !is null
      ? `
        this(IJsonBase base, Json[string] initData = null) { super(base, initData); }
        this(IJsonBase base, string name, Json[string] initData = null) { super(base, name, initData); }`
      : ``);
}

template JsonTenantThis(string name) {
  const char[] JsonTenantThis = jsonTenantThis(name);
}

string jsonTenantCalls(string shortName, string classname = null) {
  string clName = classname.length > 0 ? classname : "D" ~ shortName;

  return `
auto `~shortName~`() { return new `~clName~`; }
auto `~shortName~`(Json[string] initData) { return new `~clName~`(initData); }
auto `~shortName~`(string name, Json[string] initData = null) { return new `~clName~`(name, initData); }
auto `~shortName~`(IJsonBase base, Json[string] initData = null) { return new `~clName~`(base, initData); }
auto `~shortName~`(IJsonBase base, string name, Json[string] initData = null) { return new `~clName~`(base, name,initData); }
  `;
}

template JsonTenantCalls(string shortName, string classname = null) {
  const char[] JsonTenantCalls = jsonTenantCalls(shortName, classname);
}
