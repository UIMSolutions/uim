module uim.caches.mixins.cache;

string cacheThis(string name = null) {
    string fullName = `"` ~ name ~ "Cache" + `"`;
    return objThis(fullName);
}

template CacheThis(string name = null) {
    const char[] CacheThis = cacheThis(name);
}

string cacheCalls(string name) {
    string fullName = name ~ "Cache";
    return objCalls(fullName);
}

template CacheCalls(string name) {
    const char[] CacheCalls = cacheCalls(name);
}
