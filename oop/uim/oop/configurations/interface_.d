module uim.oop.configurations.interface_;

import uim.oop;

@safe:
interface IConfiguration : INamed {
    mixin(IProperty!("IData[string]", "data"));

    // #region defaults
        bool hasDefault(string key);

        void updateDefaults(IData[string] newData);
        void updateDefault(string key, IData newData);

        void mergeDefaults(IData[string] newData);
        void mergeDefault(string key, IData newData);
    // #endregion defaults

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

    void update(IData[string] newData, string[] validPaths = null);
    void update(string path, IData newData);

    void merge(IData[string] newData, string[] validPaths = null);
    void merge(string path, IData newData);

    void remove(string[] keys);
}