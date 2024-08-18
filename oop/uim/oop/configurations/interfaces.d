module uim.oop.configurations.interfaces;

import uim.oop;

@safe:
interface IConfiguration : INamed {
    // #region default data
        Json[string] data(); 
        void data(Json[string] items);
    // #endregion default data

    // #region default data
        Json[string] defaultData(); 
        IConfiguration defaultData(Json[string] items);

        bool hasAnyDefaults(string[] keys);
        bool hasAllDefaults(string[] keys);
        bool hasDefault(string key);
        Json getDefault(string key);

        IConfiguration set(STRINGAA values, string[] keys = null);
        IConfiguration set(Json[string] items, string[] keys = null);

        IConfiguration setDefault(string[] keys, bool newValue);
        IConfiguration setDefault(string[] keys, long newValue);
        IConfiguration setDefault(string[] keys, double newValue);
        IConfiguration setDefault(string[] keys, string newValue);
        IConfiguration setDefault(string[] keys, Json newValue);
        IConfiguration setDefault(string[] keys, Json[] newValue);
        IConfiguration setDefault(string[] keys, Json[string] newValue);

        IConfiguration setDefault(string key, bool newValue);
        IConfiguration setDefault(string key, long newValue);
        IConfiguration setDefault(string key, double newValue);
        IConfiguration setDefault(string key, string newValue);
        IConfiguration setDefault(string key, Json newValue);
        IConfiguration setDefault(string key, Json[] newValue);
        IConfiguration setDefault(string key, Json[string] newValue);

        IConfiguration updateDefault(string[] keys, bool newValue);
        IConfiguration updateDefault(string[] keys, long newValue);
        IConfiguration updateDefault(string[] keys, double newValue);
        IConfiguration updateDefault(string[] keys, string newValue);
        IConfiguration updateDefault(string[] keys, Json newValue);
        IConfiguration updateDefault(string[] keys, Json[] newValue);
        IConfiguration updateDefault(string[] keys, Json[string] newValue);

        IConfiguration updateDefault(string key, bool newValue);
        IConfiguration updateDefault(string key, long newValue);
        IConfiguration updateDefault(string key, double newValue);
        IConfiguration updateDefault(string key, string newValue);
        IConfiguration updateDefault(string key, Json newValue);
        IConfiguration updateDefault(string key, Json[] newValue);
        IConfiguration updateDefault(string key, Json[string] newValue);

        IConfiguration mergeDefaults(T)(T[string] items);
        IConfiguration mergeDefaults(T)(string[] keys, T value);
        IConfiguration mergeDefault(T)(string key, T value);
        IConfiguration mergeDefault(string key, Json items);
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

        IConfiguration set(STRINGAA values, string[] keys = null);
        IConfiguration set(Json[string] items, string[] keys = null);

        IConfiguration set(string[] keys, bool newValue);
        IConfiguration set(string[] keys, long newValue);
        IConfiguration set(string[] keys, double newValue);
        IConfiguration set(string[] keys, string newValue);
        IConfiguration set(string[] keys, Json newValue);
        IConfiguration set(string[] keys, Json[] newValue);
        IConfiguration set(string[] keys, Json[string] newValue);

        IConfiguration set(string key, bool newValue);
        IConfiguration set(string key, long newValue);
        IConfiguration set(string key, double newValue);
        IConfiguration set(string key, string newValue);
        IConfiguration set(string key, Json newValue);
        IConfiguration set(string key, Json[] newValue);
        IConfiguration set(string key, Json[string] newValue);

        void opIndexAssign(bool newValue, string key);
        void opIndexAssign(long newValue, string key);
        void opIndexAssign(double newValue, string key);
        void opIndexAssign(string newValue, string key);
        void opIndexAssign(Json newValue, string key);
        void opIndexAssign(Json[] newValue, string key);
        void opIndexAssign(Json[string] newValue, string key);
    // #endregion set

    //#region update
        IConfiguration update(Json[string] items, string[] validKeys = null);

        IConfiguration update(string[] keys, bool newValue);
        IConfiguration update(string[] keys, long newValue);
        IConfiguration update(string[] keys, double newValue);
        IConfiguration update(string[] keys, string newValue);
        IConfiguration update(string[] keys, Json newValue);
        IConfiguration update(string[] keys, Json[] newValue);
        IConfiguration update(string[] keys, Json[string] newValue);

        IConfiguration update(string key, bool newValue);
        IConfiguration update(string key, long newValue);
        IConfiguration update(string key, double newValue);
        IConfiguration update(string key, string newValue);
        IConfiguration update(string key, Json newValue);        
        IConfiguration update(string key, Json[] newValue);
        IConfiguration update(string key, Json[string] newValue);
    //#endregion update

    //#region update
        IConfiguration merge(Json[string] items, string[] validKeys = null);

        IConfiguration merge(string[] keys, bool newValue);
        IConfiguration merge(string[] keys, long newValue);
        IConfiguration merge(string[] keys, double newValue);
        IConfiguration merge(string[] keys, string newValue);
        IConfiguration merge(string[] keys, Json newValue);
        IConfiguration merge(string[] keys, Json[] newValue);
        IConfiguration merge(string[] keys, Json[string] newValue);

        IConfiguration merge(string key, bool newValue);
        IConfiguration merge(string key, long newValue);
        IConfiguration merge(string key, double newValue);
        IConfiguration merge(string key, string newValue);
        IConfiguration merge(string key, Json newValue);        
        IConfiguration merge(string key, Json[] newValue);
        IConfiguration merge(string key, Json[string] newValue);
    //#endregion update

/*     IConfiguration removeKey(Json jsonObj);
    IConfiguration removeKey(Json[string] items);
 */    
    IConfiguration removeKey(string[] keys...);
    IConfiguration removeKey(string[] keys);

    IConfiguration clear();
}
