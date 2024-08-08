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
                ? set(key, newValue)
                : this;
        }

        IConfiguration updateDefault(string key, long newValue) {
            return hasKey(key) 
                ? set(key, newValue)
                : this;
        }

        IConfiguration updateDefault(string key, double newValue) {
            return hasKey(key) 
                ? set(key, newValue)
                : this;
        }

        IConfiguration updateDefault(string key, string newValue) {
            return hasKey(key) 
                ? set(key, newValue)
                : this;
        }

        IConfiguration updateDefault(string key, Json newValue) {
            return hasKey(key) 
                ? set(key, newValue)
                : this;
        }

        IConfiguration updateDefault(string key, Json[] newValue) {
            return hasKey(key) 
                ? set(key, newValue)
                : this;
        }

        IConfiguration updateDefault(string key, Json[string] newValue) {
            return hasKey(key) 
                ? set(key, newValue)
                : this;
        }
    // #endregion updateDefault

    // #region setDefault
        IConfiguration setDefault(string[] keys, bool newValue) {
            keys.each!(key => setDefault(key, newValue));
            return this;
        }

        IConfiguration setDefault(string[] keys, long newValue) {
            keys.each!(key => setDefault(key, newValue));
            return this;
        }

        IConfiguration setDefault(string[] keys, double newValue) {
            keys.each!(key => setDefault(key, newValue));
            return this;
        }

        IConfiguration setDefault(string[] keys, string newValue) {
            keys.each!(key => setDefault(key, newValue));
            return this;
        }

        IConfiguration setDefault(string[] keys, Json newValue) {
            keys.each!(key => setDefault(key, newValue));
            return this;
        }

        IConfiguration setDefault(string[] keys, Json[] newValue) {
            keys.each!(key => setDefault(key, newValue));
            return this;
        }

        IConfiguration setDefault(string[] keys, Json[string] newValue) {
            keys.each!(key => setDefault(key, newValue));
            return this;
        }

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
        items.byKeyValue.each!(item => mergeDefault(item.key, item.value));
        return this;
    }

    IConfiguration mergeDefaults(T)(string[] keys, T value) {
        keys.each!(item => mergeDefault(item.key, item.value));
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

    //#region set
    IConfiguration set(STRINGAA data, string[] keys = null) {
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

    IConfiguration set(string[] keys, bool newValue) {
        keys.each!(key => set(key, newValue));
        return this;
    }

    IConfiguration set(string[] keys, long newValue) {
        keys.each!(key => set(key, newValue));
        return this;
    }

    IConfiguration set(string[] keys, double newValue) {
        keys.each!(key => set(key, newValue));
        return this;
    }

    IConfiguration set(string[] keys, string newValue) {
        keys.each!(key => set(key, newValue));
        return this;
    }

    IConfiguration set(string[] keys, Json newValue) {
        keys.each!(key => set(key, newValue));
        return this;
    }

    IConfiguration set(string[] keys, Json[] newValue) {
        keys.each!(key => set(key, newValue));
        return this;
    }

    IConfiguration set(string[] keys, Json[string] newValue) {
        keys.each!(key => set(key, newValue));
        return this;
    }

    IConfiguration set(string key, bool newValue) {
        return set(key, Json(newValue));
    }

    IConfiguration set(string key, long newValue) {
        return set(key, Json(newValue));
    }

    IConfiguration set(string key, double newValue) {
        return set(key, Json(newValue));
    }

    IConfiguration set(string key, string newValue) {
        return set(key, Json(newValue));
    }

    abstract IConfiguration set(string key, Json newValue);
    abstract IConfiguration set(string key, Json[] newValue);
    abstract IConfiguration set(string key, Json[string] newValue);

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
    //#endregion set

    // #region update
    IConfiguration update(Json[string] newItems, string[] validKeys = null) {
        validKeys.isNull
            ? newItems.byKeyValue.each!(item => update(item.key, item.value)) : newItems.byKeyValue
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
        remove(keys);
        return this;
    }

    IConfiguration remove(Json json) {
        if (json.isObject) {
            json.byKeyValue.each!(kv => remove(kv.key));
        } else if (json.isArray) {
            foreach (value; json.get!(Json[])) {
                remove(value.getString);
            }
        } else if (json.isString) {
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
