module uim.jsonbases.mixins.collection;

import uim.jsonbases;

@safe:
string jsonCollectionThis(string aclassname) {
  return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }this(IJsonTenant aTenant) { this(); this.tenant(aTenant); }
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