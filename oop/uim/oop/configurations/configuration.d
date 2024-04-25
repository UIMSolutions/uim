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

  	bool initialize(IData[string] initData = null) {
        separator("/");
		return true;
	}

    mixin(TProperty!("string", "name"));
    mixin(TProperty!("string", "separator"));

    // #region defaultData
        IData[string] defaultData() {
            return null;
        }

        void defaultData(IData[string] newData) {
        }

        abstract bool hasDefault(string key);

        override void updateDefaults(IData[string] newData) {
            newData.byKeyValue
                .each!(kv => updateDefault(kv.key, kv.value));
        }

        abstract void updateDefault(string key, IData newData);

        override void mergeDefaults(IData[string] newData) {
            newData.byKeyValue
                .each!(kv => mergeDefault(kv.key, kv.value));
        }

        abstract void mergeDefault(string key, IData newData);
    // #endregion defaultData

    IData[string] data() {
        return null;
    }

    void data(IData[string] newData) {
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


    IData opIndex(string key) {
        return get(key);
    }

    IData get(string key) {
        return null;
    }

    IData[string] get(string[] keys, bool compressMode = true){
        return null; 
    }

    void set(STRINGAA values, string[] keys = null) {
        set(values.toData, keys);
    }

    void set(IData[string] newData, string[] keys = null) {
        if (keys is null) {
            keys.each!(key => set(key, newData[key]));
        }
        else {
            keys.filter!(key => key in newData)
                .each!(key => set(key, newData[key]));
        }
    }

    abstract void set(string key, IData newData);

    void opIndexAssign(IData data, string key) {
        set(key, data);
    }
    
    void update(IData[string] newData, string[] keys = null) {
        if (keys is null) {
            keys.each!(key => update(key, newData[key]));
        }
        else {
            keys.filter!(key => key in newData)
                .each!(key => update(key, newData[key]));
        }
    }

    abstract void update(string key, IData newData);
    abstract void update(string key, IData[string] newData);

    void merge(IData[string] newData, string[] validKeys = null) {
        if (validKeys is null) {
            newData.keys.each!(key => merge(key, newData[key]));
        }
        else {
            validKeys
                .filter!(key => key in newData)
                .each!(key => merge(key, newData[key]));
        }
    }

    abstract void merge(string key, IData newData);
    abstract void merge(string key, IData[string] newData);

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

