module uim.jsonbases.mixins.collection;

import uim.jsonbases;

@safe:
string jsonCollectionThis(string name = null) {
  string fullName = `"`~name ~ "JsonCollection"~`"`;
  return `
    this() {
        super(`~ fullName ~ `);
    }
    this(Json[string] initData) {
        super(`~ fullName ~ `, initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }`
    ~(name !is null
      ? `
        this(IJsonTenant aTenant, Json[string] initData = null) { this(initData); this.tenant(aTenant); }
        this(IJsonTenant aTenant, string name, Json[string] initData = null) { this(name, initData); ; this.tenant(aTenant); }`
      : ""); 
}

template JsonCollectionThis(string name = null) {
  const char[] JsonCollectionThis = jsonCollectionThis(name);
}

string jsonCollectionCalls(string name) {
  string fullName = name ~ "JsonCollection";
  
  return `
auto `~fullName~`() { return new D`~fullName~`; }
auto `~fullName~`(Json[string] initData) { return new D`~fullName~`(initData); }
auto `~fullName~`(string name, Json[string] initData = null) { return new D`~fullName~`(name, initData); }

auto `~fullName~`(IJsonTenant tenant, Json[string] initData = null) { return new D`~fullName~`(tenant, initData); }
auto `~fullName~`(IJsonTenant tenant, string name, Json[string] initData = null) { return new D`~fullName~`(tenant, name, initData); }
  `;
}

template JsonCollectionCalls(string name) {
  const char[] JsonCollectionCalls = jsonCollectionCalls(name);
}