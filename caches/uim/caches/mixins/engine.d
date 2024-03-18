module uim.caches.mixins.engine;

string cacheEngineThis(string name) {
    auto fullname = name~"CacheEngine";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template CacheEngineThis(string name) {
    const char[] CacheEngineThis = cacheEngineThis(name);
}

string cacheEngineCalls(string name) {
    auto fullname = name~"CacheEngine";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template CacheEngineCalls(string name) {
    const char[] CacheEngineCalls = cacheEngineCalls(name);
}