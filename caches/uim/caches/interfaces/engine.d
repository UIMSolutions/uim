module uim.caches.interfaces.engine;

import uim.caches;

@safe:

interface ICacheEngine : INamed {
    bool set(string itemKey, Json valueToSet, long timeToLive = 0);
    bool set(Json[string] valuesToSet, long timeToLive = 0);
    Json get(string itemKey, Json defaultValue = null);
    Json[string] cacheItems(string[] itemKeys, Json defaultValue = null);
    int increment(string itemKey, int incValue = 1);
    int decrement(string itemKey, int decValue = 1);
    bool removeKey(string itemKey);
    bool removeKeys(string[] itemKeys);
    bool clear();
    bool clearGroup(string groupName);
}
