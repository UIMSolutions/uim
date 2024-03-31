module uim.oop.configurations.memory;

import uim.oop;

@safe:

class DMemoryConfiguration : DConfiguration {
    mixin(ConfigurationThis!("Memory"));

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // #region defaultData
    protected IData[string] _defaultData;

    /** 
     * override bool hasDefault(string path)
     * Params:
     *   path = name or path to data object. Could be nested
     * Returns: true if has data or false if not
     */
    override bool hasDefault(string path) {
        return (path in _defaultData) ? true : false;
    }
    /// 

    override void updateDefaults(IData[string] dataArray) {
        dataArray.byKeyValue
            .each!(kv => updateDefault(kv.key, kv.value));
    }

    override void updateDefault(string path, IData data) {
        _defaultData[path] = data;
    }

    override void mergeDefaults(IData[string] dataArray) {
        dataArray.byKeyValue
            .each!(kv => mergeDefault(kv.key, kv.value));
    }

    override void mergeDefault(string path, IData data) {
        if (!hasDefault(path)) {
            _defaultData[path] = data;
        }
    }
    // #endregion defaultData

    // #region Data
    protected IData[string] _data;

    override IData[string] data() {
        return _data;
    }

    override void data(IData[string] dataArray) {
        _data = dataArray;
    }

    alias hasAnyPaths = DConfiguration.hasAnyPaths;
    override bool hasAnyPaths(string[] paths) {
        return paths.any!(path => hasPath(path));
    }

    alias hasAllPaths = DConfiguration.hasAllPaths;
    override bool hasAllPaths(string[] paths) {
        return paths.all!(path => hasPath(path));
    }

    override bool hasPath(string path) {
        return path in _data ? true : false;
    }

    alias hasAnyValues = DConfiguration.hasAnyValues;
    override bool hasAnyValues(string[] values) {
        return values.any!(value => hasValue(value));
    }

    alias hasAllValues = DConfiguration.hasAllValues;
    override bool hasAllValues(string[] values) {
        return values.all!(value => hasValue(value));
    }
    // #region Data

    override bool hasValue(string value) {
        return _data.byKeyValue
            .any!(kv => kv.value.isEqual(value));
    }

    override string[] allPaths() {
        return _data.keys;
    }

    override IData[string] get(string[] paths, bool compressMode = true) {
        IData[string] results;

        paths.each!((path) {
            auto result = get(path);
            if (result is null && !compressMode) {
                results[path] = result;
            } else { // compressmode => no nulls
                results[path] = result;
            }
        });

        return results;
    }

    override IData get(string path) {
        return _data.get(path, _defaultData.get(path, null));
    }

    override void set(string path, IData data) {
        _data[path] = data;
    }

    override void update(string path, IData data) {
        set(path, data);
    }

    override void merge(string path, IData data) {
        if (hasPath(path)) {
            return;
        }

        set(path, data);
    }

    override IConfiguration remove(string path) {
        _data.remove(path);
        return this;
    }
}

mixin(ConfigurationCalls!("Memory"));

unittest {
    IConfiguration config = new DMemoryConfiguration;
    // config["test"] = StringData("stringdata");
    // config.data("data", StringData("string-data"));
}
