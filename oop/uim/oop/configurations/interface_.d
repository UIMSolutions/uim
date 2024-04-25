module uim.oop.configurations.interface_;

import uim.oop;

@safe:
interface IConfiguration : INamed {
    mixin(IProperty!("IData[string]", "data"));

    // #region default data
        mixin(IProperty!("IData[string]", "defaultData"));

        bool hasDefault(string key);

        void updateDefaults(IData[string] newData);
        void updateDefault(string key, IData newData);

        void mergeDefaults(IData[string] newData);
        void mergeDefault(string key, IData newData);
    // #endregion default data

    // #region keys
        string[] keys();

        bool hasAnyKeys(string[] keys...);
        bool hasAnyKeys(string[] keys);

        bool hasAllKeys(string[] keys...);
        bool hasAllKeys(string[] keys);

        bool has(string key); // Short of hasKey
        bool hasKey(string key);
    // #endregion keys

    // #region values
        bool hasAnyValues(string[] values...);
        bool hasAnyValues(string[] values);

        bool hasAllValues(string[] values...);
        bool hasAllValues(string[] values);

        bool hasValue(string value);
    // #endregion values

    // #region get
        IData opIndex(string key);
        IData get(string key);
        IData[string] get(string[] keys, bool compressMode = true);
    // #endregion get

    // void set(string key, IData newData);
    // void set(string[] keys, IData[string] newData);

    void update(IData[string] newData, string[] validKeys = null);
    void update(string key, IData newData);
    void update(string key, IData[string] newData);

    void merge(IData[string] newData, string[] validKeys = null);
    void merge(string key, IData newData);
    void merge(string key, IData[string] newData);

    IConfiguration remove(string[] keys);
    IConfiguration remove(string keys);

    IConfiguration clear();
}
