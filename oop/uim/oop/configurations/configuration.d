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
    abstract Json getDefault(string key);

    override IConfiguration updateDefaults(Json[string] newData) {
        newData.byKeyValue
            .each!(kv => updateDefault(kv.key, kv.value));
        return this;
    }

    abstract IConfiguration updateDefault(string key, Json newValue);

    override bool mergeDefaults(Json[string] newData) {
        newData.byKeyValue
            .each!(kv => mergeDefault(kv.key, kv.value));
        return this;
    }

    abstract bool mergeDefault(string key, Json newValue);
    // #endregion defaultData

    // #region data
    abstract Json[string] data();

    abstract IConfiguration data(Json[string] newData);

    void opAssign(Json[string] newData) {
        data(newData);
    }
    // #endregion data

    // #region keys
    bool hasAnyKeys(string[] keys...) {
        return hasAnyKeys(keys.dup);
    }

    bool hasAnyKeys(string[] keys) {
        return keys.any!(key => hasKey(key));
    }

    bool hasKeys(string[] keys...) {
        return hasKeys(keys.dup);
    }

    bool hasKeys(string[] keys) {
        return keys.all!(key => hasKey(key));
    }

    abstract bool hasKey(string key);

    abstract string[] keys();
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

    abstract Json[] values(string[] includedKeys = null);
    // #endregion Values

    // #region get
    Json opIndex(string key) {
        return get(key);
    }

    Json[string] get(string[] keys, bool compressMode = false) {
        Json[string] results;

        keys
            .filter!(key => !compressMode || !isNull(key))
            .each!(key => results[key] = get(key));

        return results;
    }

    Json get(string key, Json defaultValue = Json(null)) {
        return defaultValue;
    }

    int getInt(string key) {
        Json result = get(key);
        return result != Json(null)
            ? result.get!int : 0;
    }

    long getLong(string key) {
        Json result = get(key);
        return result != Json(null)
            ? result.get!long : 0;
    }

    float getFloat(string key) {
        Json result = get(key);
        return result != Json(null)
            ? result.get!float : 0.0;
    }

    double getDouble(string key) {
        Json result = get(key);
        return result != Json(null)
            ? result.get!double : 0.0;
    }

    string getString(string key) {
        Json result = get(key);
        return result != Json(null)
            ? result.get!string : null;
    }

    string[] getStringArray(string key) {
        Json json = get(key);
        return !json.isNull && json.isArray
            ? json.toStringArray : [getString(key)];
    }

    Json getJson(string key) {
        return get(key);
    }
    // #endregion get

    // #region set
    bool set(STRINGAA data, string[] keys = null) {
        set(data.toJsonMap, keys);
        return this;
    }

    bool set(Json[string] newData, string[] keys = null) {
        if (keys.isNull) {
            keys.each!(key => set(key, newData[key]));
        } else {
            keys.filter!(key => key in newData)
                .each!(key => set(key, newData[key]));
        }
        return this;
    }

    abstract bool set(string key, Json newValue);

    void opIndexAssign(Json value, string key) {
        set(key, value);
    }
    // #endregion set

    // #region update
        IConfiguration update(Json[string] newData, string[] includedKeys = null) {
            if (keys.isNull) {
                includedKeys.each!(key => update(key, newData[key]));
            } else {
                includedKeys.filter!(key => key in newData)
                    .each!(key => update(key, newData[key]));
            }
            return this;
        }

        abstract IConfiguration update(string key, Json newValue);
    // #region update

    // #region merge
    bool merge(Json[string] newData, string[] includedKeys = null) {
        if (includedKeys.isNull) {
            newData.keys.each!(key => merge(key, newData[key]));
        } else {
            includedKeys
                .filter!(key => key in newData)
                .each!(key => merge(key, newData[key]));
        }
        return this;
    }

    abstract bool merge(string key, Json newValue);
    // #endregion merge

    // #region remove - clear
    bool clear() {
        return remove(keys);
    }

    bool remove(string[] keys) {
        return keys.all!(key => remove(key));
    }

    abstract bool remove(string key);
    // #region remove - clear
}
