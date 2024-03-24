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
        protected IData[string] _defaultData;

        abstract void setDefault(string path, IData newData); 

        abstract void updateDefaults(IData[string] newData); 
    // #endregion defaultData

    IData[string] data() {
        return null;
    }

    void data(IData[string] newData) {
    }

    bool hasAnyPaths(string[] paths...) {
        return hasAnyPaths(paths.dup);
    }

    bool hasAnyPaths(string[] paths) {
        return false;
    }

    bool hasAllPaths(string[] paths...) {
        return hasAllPaths(paths.dup);
    }

    bool hasAllPaths(string[] paths) {
        return false;
    }

    bool hasPath(string path) {
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

    abstract string[] allPaths();

    IData opIndex(string path) {
        return get(path);
    }

    IData get(string path) {
        return null;
    }

    IData[string] get(string[] paths, bool compressMode = true){
        return null; 
    }

    void set(string[string] values, string[] paths = null) {
        set(values.toData, paths);
    }

    void set(IData[string] newData, string[] paths = null) {
        if (paths is null) {
            paths.each!(path => set(path, newData[path]));
        }
        else {
            paths.filter!(path => path in newData)
                .each!(path => set(path, newData[path]));
        }
    }

    abstract void set(string path, IData newData);

    void opIndexAssign(IData data, string path) {
        set(path, data);
    }
    
    void update(IData[string] newData, string[] paths = null) {
        if (paths is null) {
            paths.each!(path => update(path, newData[path]));
        }
        else {
            paths.filter!(path => path in newData)
                .each!(path => update(path, newData[path]));
        }
    }

    abstract void update(string path, IData newData);

    void merge(IData[string] newData, string[] paths = null) {
        if (paths is null) {
            paths.each!(path => merge(path, newData[path]));
        }
        else {
            paths.filter!(path => path in newData)
                .each!(path => merge(path, newData[path]));
        }
    }

    abstract void merge(string path, IData newData);

    void clear() {
        remove(allPaths);        
    }

    void remove(string[] paths) {
        paths.each!(path => remove(path));
    }

    abstract void remove(string path);
}

