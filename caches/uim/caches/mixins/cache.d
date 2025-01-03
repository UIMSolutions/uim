/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.caches.mixins.cache;

import uim.caches;

@safe:
string cacheThis(string name = null) {
    string fullName = name ~ "Cache";
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
