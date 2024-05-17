module uim.oop.tests.configuration;

import uim.oop;

@safe:

bool testConfiguration(IConfiguration aConfig) {
    // in case of - writeln(__MODULE__, " in ", __LINE__);
    aConfig.data([
        "a": Json("A"),
        "b": Json("B"),
        "1": Json(1),
        "1.1": Json(1.1),
        "true": Json(true),
        "false": Json(false),
        "null": Json(null)
    ]);

    aConfig.defaultData([
        "a": Json("A"),
        "c": Json("C")
    ]);

    assert(aConfig.defaultData.getString("c") == "C", aConfig.name~": "~`aConfig.defaultData.getString("c") == "C"`);

    assert(aConfig.data["a"].to!string == "A", aConfig.name);
    assert(aConfig.data.getString("a") == "A", aConfig.name);
    assert(aConfig.getString("b") == "B", aConfig.name);
    
    assert(aConfig.getString("c") == "C", aConfig.name);
    assert(aConfig.getString("c") != "X", aConfig.name);

    assert(aConfig.defaultData["a"].to!string == "A", aConfig.name);
    assert(aConfig.defaultData.getString("c") == "C", aConfig.name);

    assert(aConfig.hasAnyDefaults(["a", "x"]), aConfig.name);
    assert(!aConfig.hasAnyDefaults(["x", "y"]), aConfig.name);

    assert(aConfig.hasAllDefaults(["a", "c"]));
    assert(!aConfig.hasAllDefaults(["a", "x"]));

// TODO
/*
    assert(aConfig.hasDefault("a"));
    assert(!aConfig.hasDefault("x"));
        bool (string[] keys);
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
        bool hasKey(string[] path); // for a path as key
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
        void set(STRINGAA values, string[] keys = null);
        void set(Json[string] newData, string[] keys = null);
        void set(string key, Json newData);
    // #endregion set

    void update(Json[string] newData, string[] validKeys = null);
    void update(string key, Json newData);
    void update(string key, Json[string] newData);

    void merge(Json[string] newData, string[] validKeys = null);
    void merge(string key, Json newData);
    void merge(string key, Json[string] newData);

    IConfiguration remove(string[] keys);
    IConfiguration remove(string keys);

    IConfiguration clear();
*/

    return true;
}