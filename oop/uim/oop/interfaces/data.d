module oop.uim.oop.interfaces.data;

import uim.oop;

@safe:
interface IData {
    string[] keys();
    IData[] values();

	bool isEqual(IData data);

    bool hasPaths(string[] paths);
    bool hasPath(string path);

    bool hasKeys(string[] keys, bool deepSearch = false);
    bool hasKey(string key, bool deepSearch = false);

    bool hasData(IData[] data, bool deepSearch = false);
    bool hasData(IData data, bool deepSearch = false);

	IData get(string key, IData defaultData);
    
    IData data(string key);
    IData opIndex(string key);

    IData data(string key, IData data);
    IData opAssignIndex(IData data, string key);

    string toString();
}