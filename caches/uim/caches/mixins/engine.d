module uim.caches.mixins.engine;

string cacheEngineThis(string name) {
    string fullName = name ~ "CacheEngine";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        this().name(name);
    }
    `;
}

template CacheEngineThis(string name) {
    const char[] CacheEngineThis = cacheEngineThis(name);
}

string cacheEngineCalls(string name) {
    string fullName = name ~ "CacheEngine";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template CacheEngineCalls(string name) {
    const char[] CacheEngineCalls = cacheEngineCalls(name);
}