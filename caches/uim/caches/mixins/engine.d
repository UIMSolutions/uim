module uim.caches.mixins.engine;

string cacheEngineThis(string name = null) {
    string fullName = name ~ "CacheEngine";
    return objThis(fullName);
}

template CacheEngineThis(string name = null) {
    const char[] CacheEngineThis = cacheEngineThis(name);
}

string cacheEngineCalls(string name) {
    string fullName = name ~ "CacheEngine";
    return objCalls(fullName);
}

template CacheEngineCalls(string name) {
    const char[] CacheEngineCalls = cacheEngineCalls(name);
}