/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.configurations.configuration;

import uim.oop;

@safe:

// Configuration for handling config data = key: string / value: Json
abstract class DConfiguration : IConfiguration {
    this() {
    }

    this(string name) {
        this();
        this.name(name);
    }

    bool initialize(Json[string] initValue = null) {
        return true;
    }

    mixin(TProperty!("string", "name"));

    // #region defaultData
    abstract Json[string] defaultData(); 

    abstract IConfiguration defaultData(Json[string] newData); 

    bool hasAnyDefaults(string[] keys) {
        return keys
            .filter!(key => !key.isEmpty)
            .any!(key => hasDefault(key));
    }

    bool hasAllDefaults(string[] keys) {
        return keys
            .filter!(key => !key.isEmpty)
            .all!(key => hasDefault(key));
    }

    abstract bool hasDefault(string key);

    override IConfiguration updateDefaults(Json[string] newData) {
        newData.byKeyValue
            .each!(kv => updateDefault(kv.key, kv.value));
        return this;
    }

    abstract IConfiguration updateDefault(string key, Json newValue);

    override IConfiguration mergeDefaults(Json[string] newData) {
        newData.byKeyValue
            .each!(kv => mergeDefault(kv.key, kv.value));
        return this;
    }

    abstract IConfiguration mergeDefault(string key, Json newValue);
    // #endregion defaultData

    // #region value
    abstract Json[string] value(); 

    abstract IConfiguration value(Json[string] newData); 
    // #endregion value

    // #region keys
    bool hasAnyKeys(string[] keys...) {
        return hasAnyKeys(keys.dup);
    }

    bool hasAnyKeys(string[] keys) {
        return keys.any!(key => hasKey(key));
    }

    bool hasAllKeys(string[] keys...) {
        return hasAllKeys(keys.dup);
    }

    bool hasAllKeys(string[] keys) {
        return keys.all!(key => hasKey(key));
    }

    abstract bool hasKey(string key);

    abstract string[] allKeys();
    // #endregion keys

    // #region Values
    bool hasAnyValues(Json[] values...) {
        return hasAnyValues(values.dup);
    }

    bool hasAnyValues(Json[] values) {
        return values.any!(value => hasValue(value));
    }

    bool hasAllValues(Json[] values...) {
        return hasAllValues(values.dup);
    }

    bool hasAllValues(Json[] values) {
        return values.all!(value => hasValue(value));
    }

    abstract bool hasValue(Json value);

    abstract Json[] values();
    // #endregion Values

    // #region get
    Json opIndex(string key) {
        return get(key);
    }

    Json[string] get(string[] keys, bool compressMode = false) {
        Json[string] results;

        keys
            .map!(key => key.strip)
            .filter!(key => key.length > 0)
            .filter!(key => !compressMode || !isNull(key))
            .each!(key => results[key] = get(key));

        return results;
    }

    Json get(string key, Json defaultData = Json(null)) {
        return defaultData;
    }

    int getInt(string key) {
        if (!hasKey(key)) {
            return 0;
        }

        return get(key).get!int;
    }

    long getLong(string key) {
        return hasKey(key)
            ? get(key).get!long : 0;
    }

    float getFloat(string key) {
        return hasKey(key)
            ? get(key).get!float : 0.0;
    }

    double getDouble(string key) {
        if (!hasKey(key)) {
            return 0;
        }

        return get(key).get!double;
    }

    string getString(string key) {
        writeln("key = ", key);
        writeln("hasKey = ", hasKey(key));
        return hasKey(key)
            ? get(key).get!string : null;
    }

    string[] getStringArray(string key) {
        if (!hasKey(key)) {
            return null;
        }

        Json json = get(key);
        return json.isArray
            ? json.toStringArray : [json.to!string];
    }

    Json getJson(string key) {
        return get(key);
    }
    // #endregion get

    // #region set
    IConfiguration set(STRINGAA data, string[] keys = null) {
        set(data.toJsonMap, keys);
        return this;
    }

    IConfiguration set(Json[string] newData, string[] keys = null) {
        if (keys.isNull) {
            keys.each!(key => set(key, newData[key]));
        } else {
            keys.filter!(key => key in newData)
                .each!(key => set(key, newData[key]));
        }
        return this;
    }

    abstract IConfiguration set(string key, Json newValue);

    void opIndexAssign(Json value, string key) {
        set(key, value);
    }

    void opAssign(Json[string] value) {
        set(value);
    }
    // #endregion set

    IConfiguration update(Json[string] newData, string[] includedKeys = null) {
        if (keys.isNull) {
            includedKeys.each!(key => update(key, newData[key]));
        } else {
            includedKeys.filter!(key => key in newData)
                .each!(key => update(key, newData[key]));
        }
        return this;
    }

    IConfiguration update(string key, Json[string] newData) {
        return update(key, newData.toJsonObject);
    }
    abstract IConfiguration update(string key, Json newValue);

    IConfiguration merge(Json[string] newData, string[] includedKeys = null) {
        if (includedKeys.isNull) {
            newData.keys.each!(key => merge(key, newValue[key]));
        } else {
            includedKeys
                .filter!(key => key in newData)
                .each!(key => merge(key, newData[key]));
        }
        return this;
    }

    IConfiguration merge(string key, Json[string] newData) {
        return merge(key, newData.toJsonObject);
    }    

    abstract IConfiguration merge(string key, Json newValue);

    IConfiguration clear() {
        remove(allKeys);
        return this;
    }

    IConfiguration remove(string[] keys) {
        keys.each!(key => remove(key));
        return this;
    }

    abstract IConfiguration remove(string key);
}
