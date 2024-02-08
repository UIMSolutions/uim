module uim.models.interfaces.data;

import uim.models;

@safe:
interface IData {
    string[] keys();
    IData[] values();

    // is data empty  
    // TODO bool isEmpty(string key);

    bool isNumeric();
    bool isString();
    IAttribute attribute();

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

    bool hasKeys(string[])
    Json toJson();
    string toString();
    size_t length();

    bool isEqual(IData[string] checkData);
    bool isEqual(IData data);

    bool hasPaths(string[] paths, string separator = "/");
    bool hasPath(string path, string separator = "/");

    bool hasKeys(string[] keys, bool deepSearch = false);
    bool hasKey(string key, bool deepSearch = false);

    bool hasData(IData[string] checkData, bool deepSearch = false);
    bool hasData(IData[] data, bool deepSearch = false);
    bool hasData(IData data, bool deepSearch = false);

    IData get(string key, IData defaultData);

    IData data(string key);
    IData opIndex(string key);

    void data(string key, IData data);
    void opAssignIndex(IData data, string key);

    string toString();
    Json toJson(string[] selectedKeys = null);
}
