module uim.caches.interfaces.engine;

import uim.caches;

@safe:

interface ICacheEngine : INamed {
    void groupName(string name);
    string groupName();

    void items(Json[string] itemData);
    Json[string] items(string[] keys);

    string[] keys();
    Json[] values();

    bool merge(Json[string] itemData, long timeToLive = 0);
    bool merge(string key, Json value, long timeToLive = 0);

    bool update(Json[string] itemData, long timeToLive = 0);
    bool update(string key, Json value, long timeToLive = 0);

    Json[] get(string key, Json defaultValue = null);
    Json get(string key, Json defaultValue = null);

    long increment(string key, int incValue = 1);
    long decrement(string key, int decValue = 1);

    bool remove(string[] keys);
    bool remove(string key);

    bool clear();
    bool clearGroup(string groupName);
}
