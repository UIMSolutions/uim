module uim.jsonbases.mixins.collection;

import uim.jsonbases;

@safe:
string jsonCollectionThis(string aclassname) {
  return `
this() { super(); this.classname("`~aclassname~`"); }
this(IJsonTenant aTenant) { this(); this.tenant(aTenant); }
this(string aName) { this(); this.name(aName); }

this(IJsonTenant aTenant, string aName) { this(aTenant); this.name(aName); }
  `;
}

template JsonCollectionThis(string aName) {
  const char[] JsonCollectionThis = jsonCollectionThis(aName);
}

string jsonCollectionCalls(string shortName, string classname = null) {
  string clName = classname.length > 0 ? classname : "D"~shortName;
  
  return `
auto `~shortName~`() { return new `~clName~`; }
auto `~shortName~`(IJsonTenant aTenant) { return new `~clName~`(aTenant); }
auto `~shortName~`(string aName) { return new `~clName~`(aName); }

auto `~shortName~`(IJsonTenant aTenant, string aName) { return new `~clName~`(aTenant, aName); }
  `;
}

template JsonCollectionCalls(string shortName, string classname = null) {
  const char[] JsonCollectionCalls = jsonCollectionCalls(shortName, classname);
}