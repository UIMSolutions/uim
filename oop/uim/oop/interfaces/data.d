module uim.oop.interfaces.data;

import uim.oop;

@safe:
interface IData {
    string[] keys();
    IData[] values();

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