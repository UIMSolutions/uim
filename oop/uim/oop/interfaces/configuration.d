module uim.oop.interfaces.configuration;

import uim.oop;

@safe:
interface IConfiguration : INamed {
    mixin(IProperty!("IData[string]", "data"));

    bool hasAnyKeys(string[] keys...);
    bool hasAnyKeys(string[] keys);

    bool hasAllKeys(string[] keys...);
    bool hasAllKeys(string[] keys);
    
    bool hasKey(string key);

    bool hasAnyValues(string[] values...);
    bool hasAnyValues(string[] values);
    
    bool hasAllValues(string[] values...);
    bool hasAllValues(string[] values);
    
    bool hasValue(string value);

    // IData get(string key);
    // IData[string] get(string[] keys, bool compressMode = true);

    // void set(string key, IData newData);
    // void set(string[] keys, IData[string] newData);

    // void update(IData[string] newData);

    void remove(string[] keys);
}