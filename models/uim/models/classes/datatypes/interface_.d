module uim.models.datatypes.interface_;

import uim.models;

@safe:
interface IData {
    IData[] values();

    // is data empty  
    // TODO bool isEmpty(string key);

    bool isNumeric();
    bool isString();
    // IAttribute attribute();

    bool isBoolean();
    bool toBoolean();

    bool isBoolean();
    bool isInteger();
    int toInteger();
    long toLong();

    bool isNumber();
    float toFloat();
    double toDouble();

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

    string typeName();

    Json toJson();
    string toString();
    string[] toStringArray();
    size_t length();

    // Check is equal
    bool isEqual(IData[string] checkData);
    bool isEqual(IData data);
    bool isEqual(string value);
    bool isEqual(Json value);

    IData at(size_t pos);

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

    IData value(string key, IData defaultData);

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