/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.configurations.configuration;

import uim.oop;
@safe:

abstract class DConfiguration : IConfiguration {
    this() {}
    this(string name) { this(); this.name(name); }

  	bool initialize(Json[string] initData = null) {
        separator("/");
		return true;
	}

    mixin(TProperty!("string", "name"));
    mixin(TProperty!("string", "separator"));

    // #region defaultData
        Json[string] defaultData() {
            return null;
        }

        void defaultData(Json[string] newData) {
        }

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

        override void updateDefaults(Json[string] newData) {
            newData.byKeyValue
                .each!(kv => updateDefault(kv.key, kv.value));
        }

        abstract void updateDefault(string key, Json newData);

        override void mergeDefaults(Json[string] newData) {
            newData.byKeyValue
                .each!(kv => mergeDefault(kv.key, kv.value));
        }

        abstract void mergeDefault(string key, Json newData);
    // #endregion defaultData

    // #region data
        Json[string] data() {
            return null;
        }

        void data(Json[string] newData) {
        }
    // #endregion data

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
        bool hasAnyValues(string[] values...) {
            return hasAnyValues(values.dup);
        }

        bool hasAnyValues(string[] values) {
            return values.any!(value => hasValue(value));
        }

        bool hasAllValues(string[] values...) {
            return hasAllValues(values.dup);
        }

        bool hasAllValues(string[] values) {
            return values.all!(value => hasValue(value));
        }

        abstract bool hasValue(string value);

        abstract string[] values();
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

        Json get(string key, Json defaultValue = Json(null)) {
            return defaultValue;
        }

        int getInt(string key) {
            if (!hasKey(key)) {
                return 0;
            } 

            return get(key).get!int;
        }

        long getLong(string key) {
            return hasKey(key)
                ? get(key).get!long
                : 0;
        }

        float getFloat(string key) {
            return hasKey(key)
                ? get(key).get!float
                : 0.0;
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
                ? get(key).get!string
                : null;
        }

        string[] getStringArray(string key) {
            if (!hasKey(key)) {
                return null;
            }

            Json json = get(key);
            return json.isArray
                ? json.toStringArray
                : [json.to!string];
        }

        Json getJson(string key) {
            return get(key);
        }
    // #endregion get

    // #region set
        void set(STRINGAA values, string[] keys = null) {
            set(values.toJsonMap, keys);
        }

        void set(Json[string] newData, string[] keys = null) {
            if (keys.isNull) {
                keys.each!(key => set(key, newData[key]));
            }
            else {
                keys.filter!(key => key in newData)
                    .each!(key => set(key, newData[key]));
            }
        }

        abstract void set(string key, Json newData);

        void opIndexAssign(Json data, string key) {
            set(key, data);
        }
        
        void opAssign(Json[string] data) {
            set(data);
        }
    // #endregion set

    void update(Json[string] newData, string[] keys = null) {
        if (keys.isNull) {
            keys.each!(key => update(key, newData[key]));
        }
        else {
            keys.filter!(key => key in newData)
                .each!(key => update(key, newData[key]));
        }
    }

    abstract void update(string key, Json newData);
    abstract void update(string key, Json[string] newData);

    void merge(Json[string] newData, string[] validKeys = null) {
        if (validKeys.isNull) {
            newData.keys.each!(key => merge(key, newData[key]));
        }
        else {
            validKeys
                .filter!(key => key in newData)
                .each!(key => merge(key, newData[key]));
        }
    }

    abstract void merge(string key, Json newData);
    abstract void merge(string key, Json[string] newData);

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

