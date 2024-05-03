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

    Json[string] data() {
        return null;
    }

    void data(Json[string] newData) {
    }

    // #region keys
        bool hasAnyKeys(string[] keys...) {
            return hasAnyKeys(keys.dup);
        }

        bool hasAnyKeys(string[] keys) {
            return false;
        }

        bool hasAllKeys(string[] keys...) {
            return hasAllKeys(keys.dup);
        }

        bool hasAllKeys(string[] keys) {
            return false;
        }

        bool hasKey(string key) {
            return false;
        }

        abstract string[] allKeys();
    // #endregion keys

    // #region Values
        bool hasAnyValues(string[] values...) {
            return hasAnyValues(values.dup);
        }

        bool hasAnyValues(string[] values) {
            return false;
        }

        bool hasAllValues(string[] values...) {
            return hasAllValues(values.dup);
        }

        bool hasAllValues(string[] values) {
            return false;
        }

        bool hasValue(string value) {
            return false;
        }
    // #endregion Values

    // #region get
        Json opIndex(string key) {
            return get(key);
        }

        Json get(string key) {
            return Json(null);
        }

        Json[string] get(string[] keys, bool compressMode = true){
            return null; 
        }

        int getInt(string key) {
            if (!hasKey(key)) {
                return 0;
            } 

            return get(key).to!int;
        }

        long getLong(string key) {
            if (!hasKey(key)) {
                return 0;
            } 

            return get(key).to!long;
        }

        float getFloat(string key) {
            if (!hasKey(key)) {
                return 0;
            } 

            return get(key).to!float;
        }

        double getDouble(string key) {
            if (!hasKey(key)) {
                return 0;
            } 

            return get(key).to!double;
        }

        string getString(string key) {
            if (!hasKey(key)) {
                return null;
            } 

            return get(key).to!string;
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
            if (keys is null) {
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
        if (keys is null) {
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
        if (validKeys is null) {
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

