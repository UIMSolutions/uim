module uim.core.interfaces.data;

import uim.core;

@safe:
interface IData {
    IData[] values();

    // is data empty  
    // TODO bool isEmpty(string key);

    bool isNumeric();
    bool isString();
    // IAttribute attribute();

    bool isBoolean();
    bool isInteger();
    bool isDouble();
    bool isLong();
    bool isTime();
    bool isDate();
    bool isDatetime();
    bool isTimestamp();

    bool isScalar();
    bool isArray();
    bool isObject();
    bool isEntity();
    bool isUUID();

    bool isNullable();
    bool isNull();
    bool isReadOnly();

    Json toJson();
    string toString();
    size_t length();

    // Check is equal
    bool isEqual(IData[string] checkData);
    bool isEqual(IData data);
    bool isEqual(string value);
    bool isEqual(Json value);

    bool hasPaths(string[] paths, string separator = "/");
    bool hasPath(string path, string separator = "/");

    bool hasKey(); // One single key
    string key();
    void key(string newKey);

    bool hasAllKeys(string[]); // Has many keys , one or more 
    string[] keys();

    bool hasAllKeys(string[] keys, bool deepSearch = false);
    bool hasKey(string key, bool deepSearch = false);

    bool hasData(IData[string] checkData, bool deepSearch = false);
    bool hasData(IData[] data, bool deepSearch = false);
    bool hasData(IData data, bool deepSearch = false);

    IData get(string key, IData defaultData);

    IData[string] data(string[] keys);
    IData data(string key);
    IData opIndex(string key);

    void data(string key, IData data);
    void opAssignIndex(IData data, string key);

    void set(string newValue);
    void set(Json newValue);

    string toString();
    Json toJson(string[] selectedKeys = null);
}
