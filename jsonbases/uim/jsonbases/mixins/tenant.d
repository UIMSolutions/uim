module uim.jsonbases.mixins.tenant;

import uim.jsonbases;

@safe:
string jsonTenantThis(string aName) {
  return `
this() { super(); this.className("`~aName~`"); }
this(IJsonBase aBase) { this(); this.base(aBase); }
this(string aName) { this(); this.name(aName); }

this(IJsonBase aBase, string aName) { this(aBase); this.name(aName); }
  `;
}

template JsonTenantThis(string aName) {
  const char[] JsonTenantThis = jsonTenantThis(aName);
}

string jsonTenantCalls(string shortName, string className = null) {
  string clName = className.length > 0 ? className : "D" ~ shortName;

  return `
auto `~shortName~`() { return new `~clName~`; }
auto `~shortName~`(IJsonBase aBase) { return new `~clName~`(aBase); }
auto `~shortName~`(string aName) { return new `~clName~`(aName); }
auto `~shortName~`(IJsonBase aBase, string aName) { return new `~clName~`(aBase, aName); }
  `;
}

template JsonTenantCalls(string shortName, string className = null) {
  const char[] JsonTenantCalls = jsonTenantCalls(shortName, className);
}
