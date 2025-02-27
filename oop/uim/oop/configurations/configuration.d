/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.configurations.configuration;

import uim.oop;
@safe:

version (test_uim_oop) {
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

private alias KeyValue = Tuple!(string, "key", Json, "value");

// Configuration for handling config data = key: string / value: Json
class DConfiguration : UIMObject, IConfiguration {
    mixin(ConfigurationThis!("Configuration"));

    override bool initialize(Json[string] initData = null) {
        // writeln("DConfiguration::initialize(Json[string] initData = null) - ", this.classinfo);
        return true;
    }

    // #region defaultData
    abstract Json[string] defaultData();

    abstract IConfiguration defaultData(Json[string] newData);
    @property auto byKeyValue()
    @trusted {
        return data.byKeyValue.map!(kv => KeyValue(kv.key, kv.value)).array;
    }

    bool hasAnyDefaults(string[] keys) {
        return keys
            .filter!(key => key.length > 0)
            .any!(key => hasDefault(key));
    }

    bool hasAllDefaults(string[] keys) {
        return keys
            .filter!(key => key.length > 0)
            .all!(key => hasDefault(key));
    }

    abstract bool hasDefault(string key);
    abstract Json getDefault(string key);

    // #region updateDefault
    IConfiguration updateDefault(string[] keys, bool newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration updateDefault(string[] keys, long newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration updateDefault(string[] keys, double newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration updateDefault(string[] keys, string newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration updateDefault(string[] keys, Json newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration updateDefault(string[] keys, Json[] newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration updateDefault(string[] keys, Json[string] newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration updateDefault(string key, bool newValue) {
        return hasKey(key)
            ? set(key, newValue) : this;
    }

    IConfiguration updateDefault(string key, long newValue) {
        return hasKey(key)
            ? set(key, newValue) : this;
    }

    IConfiguration updateDefault(string key, double newValue) {
        return hasKey(key)
            ? set(key, newValue) : this;
    }

    IConfiguration updateDefault(string key, string newValue) {
        return hasKey(key)
            ? set(key, newValue) : this;
    }

    IConfiguration updateDefault(string key, Json newValue) {
        return hasKey(key)
            ? set(key, newValue) : this;
    }

    IConfiguration updateDefault(string key, Json[] newValue) {
        return hasKey(key)
            ? set(key, newValue) : this;
    }

    IConfiguration updateDefault(string key, Json[string] newValue) {
        return hasKey(key)
            ? set(key, newValue) : this;
    }
    // #endregion updateDefault

    // #region setDefaults
    IConfiguration setDefaults(string[] keys, bool newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration setDefaults(string[] keys, long newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration setDefaults(string[] keys, double newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration setDefaults(string[] keys, string newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration setDefaults(string[] keys, Json newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration setDefaults(string[] keys, Json[] newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }

    IConfiguration setDefaults(string[] keys, Json[string] newValue) {
        keys.each!(key => setDefault(key, newValue));
        return this;
    }
    // #endregion setDefaults

    // #region setDefault
    IConfiguration setDefault(string key, bool newValue) {
        return setDefault(key, Json(newValue));
    }

    IConfiguration setDefault(string key, long newValue) {
        return setDefault(key, Json(newValue));
    }

    IConfiguration setDefault(string key, double newValue) {
        return setDefault(key, Json(newValue));
    }

    IConfiguration setDefault(string key, string newValue) {
        return setDefault(key, Json(newValue));
    }

    abstract IConfiguration setDefault(string key, Json newValue);
    abstract IConfiguration setDefault(string key, Json[] newValue);
    abstract IConfiguration setDefault(string key, Json[string] newValue);
    // #endregion setDefaults

    // #region mergeDefault
    IConfiguration mergeDefaults(T)(T[string] items) {
        items.each!((key, value) => mergeDefault(key, value));
        return this;
    }

    IConfiguration mergeDefaults(T)(string[] keys, T value) {
        keys.each!((key, value) => mergeDefault(key, value));
        return this;
    }

    IConfiguration mergeDefaults(T)(string key, T value) {
        mergeDefault(key, Json(value));
        return this;
    }

    IConfiguration mergeDefault(string key, Json value) {
        if (!hasKey(key)) {
            setDefault(key, value);
        }
        return this;
    }
    // #endregion mergeDefault

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

    // #region hasValues
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

    // #region is
    bool isBoolean(string key) {
        return hasKey(key)
            ? get(key).isBoolean : false;
    }

    bool isLong(string key) {
        return hasKey(key)
            ? get(key).isLong : false;
    }

    bool isDouble(string key) {
        return hasKey(key)
            ? get(key).isDouble : false;
    }

    bool isString(string key) {
        return hasKey(key)
            ? get(key).isString : false;
    }

    bool isArray(string key) {
        return hasKey(key)
            ? get(key).isArray : false;
    }

    bool isMap(string key) {
        return hasKey(key)
            ? get(key).isMap : false;
    }
    // #endregion is

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

    bool getBoolean(string key, bool nullValue = false) {
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

    string[] getStrings(string key, string[] nullValue = null) {
        return getArray(key)
            .map!(item => item.getString).array;
    }

    Json[] getArray(string key) {
        writeln("DConfiguraton::Json[] getArray(string key) - ", this.classinfo);
        return hasKey(key) && isArray(key)
            ? get(key).getArray : null;
    }

    Json[string] getMap(string key) {
        return hasKey(key) && isMap(key)
            ? get(key).getMap : null;
    }

    string[string] getStringMap(string key) {
        string[string] result;
        getMap(key).each!((key, value) => result[key] = value.get!string);
        return result;
    }

    Json getJson(string key) {
        return get(key);
    }
    // #endregion get

    //#region set
    IConfiguration set(string[string] data, string[] keys = null) {
        Json[string] map;
        keys
            .filter!(key => key in data)
            .each!(key => map[key] = Json(data[key]));

        return set(map);
    }

    IConfiguration set(Json[string] newData, string[] keys = null) {
        keys.isNull
            ? keys.each!(key => set(key, newData[key])) : keys.filter!(key => key in newData)
            .each!(key => set(key, newData[key]));

        return this;
    }

    mixin(DataIndexAssign!());
    mixin(SetDataMulti!("IConfiguration"));
    mixin(SetDataSingle!("IConfiguration"));

    abstract IConfiguration set(string key, Json newValue);
    abstract IConfiguration set(string key, Json[] newValue);
    abstract IConfiguration set(string key, Json[string] newValue);
    //#endregion set

    // #region update
    IConfiguration update(Json[string] newItems, string[] validKeys = null) {
        validKeys.isNull
            ? newItems.each!((key, value) => update(key, value)) : newItems.byKeyValue
            .filter!(item => validKeys.has(item.key))
            .each!(item => update(item.key, item.value));

        return this;
    }

    IConfiguration update(string[] keys, bool newValue) {
        keys.each!(key => update(key, newValue));
        return this;
    }

    IConfiguration update(string[] keys, long newValue) {
        keys.each!(key => update(key, newValue));
        return this;
    }

    IConfiguration update(string[] keys, double newValue) {
        keys.each!(key => update(key, newValue));
        return this;
    }

    IConfiguration update(string[] keys, string newValue) {
        keys.each!(key => update(key, newValue));
        return this;
    }

    IConfiguration update(string[] keys, Json newValue) {
        keys.each!(key => update(key, newValue));
        return this;
    }

    IConfiguration update(string[] keys, Json[] newValue) {
        keys.each!(key => update(key, newValue));
        return this;
    }

    IConfiguration update(string[] keys, Json[string] newValue) {
        keys.each!(key => update(key, newValue));
        return this;
    }

    IConfiguration update(string key, bool newValue) {
        return update(key, Json(newValue));
    }

    IConfiguration update(string key, long newValue) {
        return update(key, Json(newValue));
    }

    IConfiguration update(string key, double newValue) {
        return update(key, Json(newValue));
    }

    IConfiguration update(string key, string newValue) {
        return update(key, Json(newValue));
    }

    IConfiguration update(string key, Json newValue) {
        return hasKey(key)
            ? set(key, newValue) : this;
    }

    IConfiguration update(string key, Json[] newValue) {
        return hasKey(key)
            ? set(key, newValue) : this;
    }

    IConfiguration update(string key, Json[string] newValue) {
        return hasKey(key)
            ? set(key, newValue) : this;
    }
    // #region update

    // #region merge
    IConfiguration merge(Json[string] newItems, string[] validKeys = null) {
        validKeys.isNull
            ? newItems.byKeyValue.each!(item => merge(item.key, item.value)) : newItems.byKeyValue
            .filter!(item => validKeys.has(item.key))
            .each!(item => merge(item.key, item.value));

        return this;
    }

    IConfiguration merge(string[] keys, bool newValue) {
        keys.each!(key => merge(key, newValue));
        return this;
    }

    IConfiguration merge(string[] keys, long newValue) {
        keys.each!(key => merge(key, newValue));
        return this;
    }

    IConfiguration merge(string[] keys, double newValue) {
        keys.each!(key => merge(key, newValue));
        return this;
    }

    IConfiguration merge(string[] keys, string newValue) {
        keys.each!(key => merge(key, newValue));
        return this;
    }

    IConfiguration merge(string[] keys, Json newValue) {
        keys.each!(key => merge(key, newValue));
        return this;
    }

    IConfiguration merge(string[] keys, Json[] newValue) {
        keys.each!(key => merge(key, newValue));
        return this;
    }

    IConfiguration merge(string[] keys, Json[string] newValue) {
        keys.each!(key => merge(key, newValue));
        return this;
    }

    IConfiguration merge(string key, bool newValue) {
        return merge(key, Json(newValue));
    }

    IConfiguration merge(string key, long newValue) {
        return merge(key, Json(newValue));
    }

    IConfiguration merge(string key, double newValue) {
        return merge(key, Json(newValue));
    }

    IConfiguration merge(string key, string newValue) {
        return merge(key, Json(newValue));
    }

    IConfiguration merge(string key, Json newValue) {
        return !hasKey(key)
            ? set(key, newValue) : this;
    }

    IConfiguration merge(string key, Json[] newValue) {
        return !hasKey(key)
            ? set(key, newValue) : this;
    }

    IConfiguration merge(string key, Json[string] newValue) {
        return !hasKey(key)
            ? set(key, newValue) : this;
    }
    // #endregion merge

    // #region remove - clear
    IConfiguration clear() {
        removeKey(keys);
        return this;
    }

    IConfiguration removeKey(Json json) {
        if (json.isObject) {
            json.byKeyValue.each!(kv => removeKey(kv.key));
        } else if (json.isArray) {
            foreach (value; json.get!(Json[])) {
                removeKey(value.getString);
            }
        } else if (json.isString) {
            removeKey(json.getString);
        }
        return this;
    }

    IConfiguration removeKey(Json[string] items) {
        removeKey(items.keys);
        return this;
    }

    IConfiguration removeKey(string[] keys...) {
        removeKey(keys.dup);
        return this;
    }

    abstract IConfiguration removeKey(string[] keys);
    // #region remove - clear

    IConfiguration clone() {
        return null;
    }

    Json shift(string key) {
        if (!hasKey(key)) {
            return Json(null);
        }

        auto value = get(key);
        removeKey(key);
        return value;
    }

}

unittest {
    auto config = new DConfiguration();
    assert(config !is null);
/*     assert(config is IConfiguration);
    assert(config is DConfiguration); */
    assert(config.initialize());
    assert(config.defaultData().length == 0);
    assert(config.data().length == 0);
    assert(config.keys().length == 0);
    assert(config.values().length == 0);
    assert(config.hasKey("test") == false);
    assert(config.hasValue(Json("test")) == false);
    assert(config.get("test") == Json(null));
    assert(config.get("test", Json("test")) == Json("test"));
    assert(config.get("test", Json(1)) == Json(1));
    assert(config.get("test", Json(1.0)) == Json(1.0));
    assert(config.get("test", Json(true)) == Json(true));
    assert(config.get("test", Json(false)) == Json(false));
    assert(config.get("test", Json([1, 2, 3])) == Json([1, 2, 3]));
    assert(config.get("test", Json(["a", "b", "c"])) == Json(["a", "b", "c"]));
    assert(config.get("test", Json(["a": 1, "b": 2, "c": 3])) == Json(["a": 1, "b": 2, "c": 3]));
    assert(config.get("test", Json(["a": "a", "b": "b", "c": "c"])) == Json(["a": "a", "b": "b", "c": "c"]));
    assert(config.get("test", Json(["a": true, "b": false, "c": true])) == Json(["a": true, "b": false, "c": true]));
    assert(config.get("test", Json(["a": 1, "b": 2, "c": 3])) == Json(["a": 1, "b": 2, "c": 3]));
    assert(config.get("test", Json(["a": 1.0, "b": 2.0, "c": 3.0])) == Json(["a": 1.0, "b": 2.0, "c": 3.0]));
    // assert(config.get("test", Json(["a": "a", "b": "b
}