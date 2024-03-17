module uim.caches.mixins.cache;

string cacheThis(string name) {
    auto fullname = name~"Cache";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template CacheThis(string name) {
    const char[] CacheThis = cacheThis(name);
}

string cacheCalls(string name) {
    auto fullname = name~"Cache";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template CacheCalls(string name) {
    const char[] CacheCalls = cacheCalls(name);
}