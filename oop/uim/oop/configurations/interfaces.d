module uim.oop.configurations.interfaces;

import uim.oop;

@safe:
interface IConfiguration : INamed {
    // #region default data
        Json[string] data(); 
        void data(Json[string] newData);
    // #endregion default data

    // #region default data
        Json[string] defaultData(); 
        IConfiguration defaultData(Json[string] newData);

        bool hasAnyDefaults(string[] keys);
        bool hasAllDefaults(string[] keys);
        bool hasDefault(string key);
        Json getDefault(string key);

        bool updateDefaults(Json[string] newData);
        bool updateDefault(string key, Json newData);

        bool mergeDefaults(Json[string] newData);
        bool mergeDefault(string key, Json newData);
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

        bool getBoolean(string key, bool nullValue = false);
        long getLong(string key, long nullValue = 0);
        double getDouble(string key, double nullValue = 0.0);
        string getString(string key, string nullValue = null);
        string[] getStringArray(string key, string[] nullValue = null);
        Json[] getArray(string key, Json[] nullValue = null);
        Json[string] getMap(string key, Json[string] nullValue = null);
        string[string] getStringMap(string key, string[string] nullValue = null);
    // #endregion get

    // #region set
        void opAssign(Json[string] data);

        bool set(STRINGAA values, string[] keys = null);
        bool set(Json[string] newData, string[] keys = null);

        bool set(string key, bool newValue);
        bool set(string key, long newValue);
        bool set(string key, double newValue);
        bool set(string key, string newValue);
        bool set(string key, Json newValue);
        bool set(string key, Json[] newValue);
        bool set(string key, Json[string] newValue);

        void opIndexAssign(bool newValue, string key);
        void opIndexAssign(long newValue, string key);
        void opIndexAssign(double newValue, string key);
        void opIndexAssign(string newValue, string key);
        void opIndexAssign(Json newValue, string key);
    // #endregion set

    bool updateKey(Json[string] newData, string[] validKeys = null);
    bool updateKey(string key, Json newValue);

    bool merge(Json[string] newData, string[] validKeys = null);
    bool merge(string key, Json newValue);

    bool removeByKey(string[] keys);
    bool removeItem(string keys);

    IConfiguration clear();
}
