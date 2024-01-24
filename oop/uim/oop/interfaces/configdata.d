module uim.oop.interfaces.configdata;

import uim.oop;

@safe:
interface IConfigData {
    string[] keys();
    IConfigData[] values();

	bool isEqual(IConfigData data);

    bool hasPaths(string[] paths);
    bool hasPath(string path);

    bool hasKeys(string[] keys, bool deepSearch = false);
    bool hasKey(string key, bool deepSearch = false);

    bool hasData(IConfigData[] data, bool deepSearch = false);
    bool hasData(IConfigData data, bool deepSearch = false);

	IConfigData get(string key, IConfigData defaultData);
    
    IConfigData data(string key);
    IConfigData opIndex(string key);

    IConfigData data(string key, IConfigData data);
    IConfigData opAssignIndex(IConfigData data, string key);

    string toString();
}