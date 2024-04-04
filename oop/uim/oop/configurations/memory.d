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
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void updateDefaults(IData[string] dataArray) {
        dataArray.byKeyValue
            .each!(kv => updateDefault(kv.key, kv.value));
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void updateDefault(string path, IData data) {
        _defaultData[path] = data;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void mergeDefaults(IData[string] dataArray) {
        dataArray.byKeyValue
            .each!(kv => mergeDefault(kv.key, kv.value));
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void mergeDefault(string path, IData data) {
        if (!hasDefault(path)) {
            _defaultData[path] = data;
        }
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }
    // #endregion defaultData

    // #region Data
    protected IData[string] _data;

    override IData[string] data() {
        return _data;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void data(IData[string] dataArray) {
        _data = dataArray;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    alias hasAnyPaths = DConfiguration.hasAnyPaths;
    override bool hasAnyPaths(string[] paths) {
        return paths.any!(path => hasPath(path));
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    alias hasAllPaths = DConfiguration.hasAllPaths;
    override bool hasAllPaths(string[] paths) {
        return paths.all!(path => hasPath(path));
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override bool hasPath(string path) {
        return path in _data ? true : false;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    alias hasAnyValues = DConfiguration.hasAnyValues;
    override bool hasAnyValues(string[] values) {
        return values.any!(value => hasValue(value));
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    alias hasAllValues = DConfiguration.hasAllValues;
    override bool hasAllValues(string[] values) {
        return values.all!(value => hasValue(value));
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }
    // #region Data

    override bool hasValue(string value) {
        return _data.byKeyValue
            .any!(kv => kv.value.isEqual(value));
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override string[] allPaths() {
        return _data.keys;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
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
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override IData get(string path) {
        return _data.get(path, _defaultData.get(path, null));
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void set(string path, IData data) {
        _data[path] = data;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void update(string path, IData data) {
        set(path, data);
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void merge(string path, IData data) {
        if (hasPath(path)) {
            return;
        }

        set(path, data);
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override IConfiguration remove(string path) {
        _data.remove(path);
        return this;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }
}

mixin(ConfigurationCalls!("Memory"));

unittest {
    testConfiguration(MemoryConfiguration);
}
