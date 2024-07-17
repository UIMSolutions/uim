module uim.caches.interfaces.engine;

import uim.caches;

@safe:

interface ICacheEngine : INamed {
    void groupName(string name);
    string groupName();

    void items(Json[string] newItems, long timeToLive = 0);
    Json[string] items(string[] keys);

    string[] keys();

    bool merge(Json[string] newItems, long timeToLive = 0);
    bool merge(string key, Json value, long timeToLive = 0);

    bool update(Json[string] newItems, long timeToLive = 0);
    bool update(string key, Json value, long timeToLive = 0);

    Json[] read(string key, Json defaultValue = null);
    Json read(string key, Json defaultValue = null);

    long increment(string key, int incValue = 1);
    long decrement(string key, int decValue = 1);

    bool removeByKey(string[] keys);
    bool removeByKey(string key);

    bool clear();
    bool clearGroup(string groupName);
}
