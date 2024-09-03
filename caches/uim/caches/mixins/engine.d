module uim.caches.mixins.engine;

string cacheEngineThis(string name = null) {
    string fullName = name ~ "CacheEngine";
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

template CacheEngineThis(string name = null) {
    const char[] CacheEngineThis = cacheEngineThis(name);
}

string cacheEngineCalls(string name) {
    string fullName = name ~ "CacheEngine";
  return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
  `;  
}

template CacheEngineCalls(string name) {
    const char[] CacheEngineCalls = cacheEngineCalls(name);
}