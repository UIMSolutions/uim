module uim.caches.mixins.cache;

string cacheThis(string name) {
    auto fullname = name~"Cache";
    return `
this() {
   super(); this.name("`~fullname~`"); 
}

this(Json[string] initData) {
    super(initData); this.name("`~fullname~`");
}
this(string name) {
    super(name);
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