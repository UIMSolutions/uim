module uim.oop.configurations.interface_;

import uim.oop;

@safe:
interface IConfiguration : INamed {
    mixin(IProperty!("Json[string]", "data"));

    // #region default data
        mixin(IProperty!("Json[string]", "defaultData"));

        bool hasDefault(string key);

        void updateDefaults(Json[string] newData);
        void updateDefault(string key, Json newData);

        void mergeDefaults(Json[string] newData);
        void mergeDefault(string key, Json newData);
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
        Json opIndex(string key);
        Json get(string key);
        Json[string] get(string[] keys, bool compressMode = true);
    // #endregion get

    // void set(string key, Json newData);
    // void set(string[] keys, Json[string] newData);

    void update(Json[string] newData, string[] validKeys = null);
    void update(string key, Json newData);
    void update(string key, Json[string] newData);

    void merge(Json[string] newData, string[] validKeys = null);
    void merge(string key, Json newData);
    void merge(string key, Json[string] newData);

    IConfiguration remove(string[] keys);
    IConfiguration remove(string keys);

    IConfiguration clear();
}
