module uim.caches.mixins.cache;

string cacheThis(string name) {
    string fullName = name ~ "Cache";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
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
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
  `;  
}

template CacheCalls(string name) {
    const char[] CacheCalls = cacheCalls(name);
}
