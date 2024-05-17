module uim.oop.interfaces.configuration;

import uim.oop;

@safe:
interface IConfiguration : INamed {
    // #region default data
        Json[string] data(); 
        IConfiguration data(Json[string] newData);
    // #endregion default data

    // #region default data
        Json[string] defaultData(); 
        IConfiguration defaultData(Json[string] newData);

        bool hasAnyDefaults(string[] keys);
        bool hasAllDefaults(string[] keys);
        bool hasDefault(string key);
        Json getDefault(string key);

        IConfiguration updateDefaults(Json[string] newData);
        IConfiguration updateDefault(string key, Json newData);

        IConfiguration mergeDefaults(Json[string] newData);
        IConfiguration mergeDefault(string key, Json newData);
    // #endregion default data

    // #region keys
        bool hasAnyKeys(string[] keys...);
        bool hasAnyKeys(string[] keys);

        bool hasAllKeys(string[] keys...);
        bool hasAllKeys(string[] keys);

        bool has(string key); // Short of hasKey
        bool hasKey(string key);

        string[] keys();
    // #endregion keys

    // #region values
        bool hasAnyValues(string[] values...);
        bool hasAnyValues(string[] values);

        bool hasAllValues(string[] values...);
        bool hasAllValues(string[] values);

        bool hasValue(string value);
        Json[] values(string[] includedKeys = null); 
    // #endregion values

    // #region get
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
        IConfiguration set(string key, Json newValue);
    // #endregion set

    IConfiguration update(Json[string] newData, string[] validKeys = null);
    IConfiguration update(string key, Json newValue);

    IConfiguration merge(Json[string] newData, string[] validKeys = null);
    IConfiguration merge(string key, Json newValue);

    IConfiguration remove(string[] keys);
    IConfiguration remove(string keys);

    IConfiguration clear();
}
