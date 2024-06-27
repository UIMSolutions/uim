module uim.caches.mixins.cache;

string cacheThis(string name) {
    string fullName = name ~ "Cache";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`
        ~ fullName ~ `");
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template CacheThis(string name) {
    const char[] CacheThis = cacheThis(name);
}

string cacheCalls(string name) {
  string fullName = name ~ "Cache";
  return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
  `;  
}

template CacheCalls(string name) {
    const char[] CacheCalls = cacheCalls(name);
}
