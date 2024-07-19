/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
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

    override bool updateDefaults(Json[string] newData) {
        return newData.byKeyValue
            .all!(kv => updateDefault(kv.key, kv.value));
    }

    abstract bool updateDefault(string key, Json newValue);

    override bool mergeDefaults(Json[string] newData) {
        return newData.byKeyValue
            .all!(kv => mergeDefault(kv.key, kv.value));
    }

    abstract bool mergeDefault(string key, Json newValue);
    // #endregion defaultData

    // #region data
    abstract Json[string] data();

    abstract void data(Json[string] newData);

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
            .filter!(key => !compressMode || !key.isNull)
            .each!(key => results[key] = get(key));

        return results;
    }

    abstract Json get(string key, Json nullValue = Json(null));

    long getBoolean(string key, bool nullValue = false) {
        return hasKey(key) ? get(key).getBoolean : nullValue;
    }

    long getLong(string key, long nullValue = 0) {
        return hasKey(key) ? get(key).getLong : nullValue;
    }

    double getDouble(string key, double nullValue = 0.0) {
        return hasKey(key) ? get(key).getDouble : nullValue;
    }

    string getString(string key, string nullValue = null) {
        return hasKey(key) ? get(key).getString : nullValue;
    }

    string[] getStringArray(string key, string[] nullValue = null) {
        return getArray(key)
            .map!(item => item.getString).array;
    }

    Json[] getArray(string key) {
        return get(key).getArray;
    }

    Json[string] getMap(string key) {
        return get(key).getMap;
    }

    string[string] getStringMap(string key) {
        string[string] result;
        getMap(key).byKeyValue.each!(kv => result[kv.key] = kv.value.get!string);
        return result;
    }

    Json getJson(string key) {
        return get(key);
    }
    // #endregion get

    // #region set
    bool set(STRINGAA data, string[] keys = null) {
        return set(data.toJsonMap, keys);
    }

    bool set(Json[string] newData, string[] keys = null) {
        if (keys.isNull) {
            keys.each!(key => set(key, newData[key]));
        } else {
            keys.filter!(key => key in newData)
                .each!(key => set(key, newData[key]));
        }
        return true;
    }

    bool set(string key, bool newValue) {
        return set(key, Json(newValue));
    }

    bool set(string key, long newValue) {
        return set(key, Json(newValue));
    }

    bool set(string key, double newValue) {
        return set(key, Json(newValue));
    }

    bool set(string key, string newValue) {
        return set(key, Json(newValue));
    }

    abstract bool set(string key, Json newValue);
    abstract bool set(string key, Json[] newValue);
    abstract bool set(string key, Json[string] newValue);

    void opIndexAssign(bool newValue, string key) {
        set(key, newValue);
    }

    void opIndexAssign(long newValue, string key) {
        set(key, newValue);
    }

    void opIndexAssign(double newValue, string key) {
        set(key, newValue);
    }

    void opIndexAssign(string newValue, string key) {
        set(key, newValue);
    }

    void opIndexAssign(Json newValue, string key) {
        set(key, newValue);
    }
    // #endregion set

    // #region update
    bool updateKey(Json[string] newData, string[] includedKeys = null) {
        return keys.isNull
            ? includedKeys.all!(key => updateKey(key, newData[key])) : includedKeys.filter!(
                key => key in newData)
            .all!(key => updateKey(key, newData[key]));
    }

    abstract bool updateKey(string key, Json newValue);
    // #region update

    // #region merge
    bool merge(Json[string] newData, string[] includedKeys = null) {
        return includedKeys.isNull
            ? newData.keys.all!(key => merge(key, newData[key])) : includedKeys
            .filter!(key => key in newData)
            .all!(key => merge(key, newData[key]));
    }

    abstract bool merge(string key, Json newValue);
    // #endregion merge

    // #region remove - clear
        IConfiguration clear() {
            remove(keys);
            return this;
        }

        IConfiguration remove(Json json) {
            if (json.isObject) {
                json.byKeyValue.each!(kv => remove(kv.key));
            }
            else if (json.isArray) {
                foreach(value; json.get!(Json[])) {
                    remove(value.getString);
                }
            }
            else if (json.isString) {
                remove(json.getString);
            }
            return this;
        }

        IConfiguration remove(Json[string] items) {
            remove(items.keys);
            return this;
        }

        IConfiguration remove(string[] keys...) {
            remove(keys.dup);
            return this;
        }

        abstract IConfiguration remove(string[] keys);
    // #region remove - clear
}
