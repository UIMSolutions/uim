module uim.oop.interfaces.configuration;

import uim.oop;

@safe:
interface IConfiguration : INamed {
    mixin(IProperty!("Json[string]", "data"));

    // #region default data
        mixin(IProperty!("Json[string]", "defaultData"));

        bool hasAnyDefaults(string[] keys);
        bool hasAllDefaults(string[] keys);
        bool hasDefault(string key);

        IConfiguration updateDefaults(Json[string] newData);
        IConfiguration updateDefault(string key, Json newData);

        IConfiguration mergeDefaults(Json[string] newData);
        IConfiguration mergeDefault(string key, Json newData);
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
        string[] keys(); 
        Json[] values(string[] includedKeys = null); 

        Json opIndex(string key);
        Json get(string key, Json defaultValue = Json(null));
        Json[string] get(string[] keys, bool compressMode = false);

        int getInt(string key);
        long getLong(string key);
        float getFloat(string key);
        double getDouble(string key);
        string getString(string key);
        string[] getStringArray(string key);
        Json getJson(string key);
    // #endregion get

    // #region set
        void opIndexAssign(Json data, string key);
        void opAssign(Json[string] data);

        IConfiguration set(STRINGAA values, string[] keys = null);
        IConfiguration set(Json[string] newData, string[] keys = null);
        IConfiguration set(string key, Json newData);
    // #endregion set

    IConfiguration update(Json newData, string[] validKeys = null);
    IConfiguration update(Json[string] newData, string[] validKeys = null);
    IConfiguration update(string key, Json[string] newData);
    IConfiguration update(string key, Json newData);

    IConfiguration merge(Json newData, string[] validKeys = null);
    IConfiguration merge(Json[string] newData, string[] validKeys = null);
    IConfiguration merge(string key, Json[string] newData);
    IConfiguration merge(string key, Json newData);

    IConfiguration remove(string[] keys);
    IConfiguration remove(string keys);

    IConfiguration clear();
}
