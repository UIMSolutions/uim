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
		return true;
	}

    mixin(TProperty!("string", "name"));

    // #region defaultData
        protected IData[string] _defaultData;

        abstract void setDefault(string key, IData newData); 

        abstract void updateDefaults(IData[string] newData); 
    // #endregion defaultData

    IData[string] data() {
        return null;
    }

    void data(IData[string] newData) {
    }

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

    IData opIndex(string[] path) {
        return get(path.join("/"));
    }

    IData opIndex(string path) {
        return get(path);
    }

    IData get(string key) {
        return null;
    }

    IData[string] get(string[] keys, bool compressMode = true){
        return null; 
    }

    void set(string[] path, IData newData) {
        set(path.join("/"), newData);
    }

    void set(string path, IData newData) {
    }

    void set(string[] keys, IData[string] newData) {

    }

    void opIndexAssign(IData data, string path) {
        set(path, data);
    }
    
    void update(IData[string] newData) {

    }

    void remove(string[] keys) {}
}

