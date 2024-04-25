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
    override IData[string] defaultData() {
        return _defaultData.dup;
    }

    override void defaultData(IData[string] newData) {
        _defaultData = newData.dup;
    }

    /** 
     * override bool hasDefault(string key)
     * Params:
     *   key = name or key to data object. Could be nested
     * Returns: true if has data or false if not
     */
    override bool hasDefault(string key) {
        return (key in _defaultData) ? true : false;
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

    override void updateDefault(string key, IData data) {
        _defaultData[key] = data;
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

    override void mergeDefault(string key, IData data) {
        if (!hasDefault(key)) {
            _defaultData[key] = data;
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
        return _data.dup;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void data(IData[string] newData) {
        _data = newData.dup;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    alias hasAnyKeys = DConfiguration.hasAnyKeys;
    override bool hasAnyKeys(string[] keys) {
        return keys.any!(key => hasKey(key));
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    alias hasAllKeys = DConfiguration.hasAllKeys;
    override bool hasAllKeys(string[] keys) {
        return keys.all!(key => hasKey(key));
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override bool hasKey(string key) {
        return key in _data ? true : false;
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

    override string[] allKeys() {
        return _data.keys;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override IData[string] get(string[] keys, bool compressMode = true) {
        IData[string] results;

        keys.each!((key) {
            auto result = get(key);
            if (result is null && !compressMode) {
                results[key] = result;
            } else { // compressmode => no nulls
                results[key] = result;
            }
        });

        return results;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override IData get(string key) {
        return _data.get(key, _defaultData.get(key, null));
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void set(string key, IData data) {
        _data[key] = data;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void update(string key, IData data) {
        set(key, data);
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void merge(string key, IData data) {
        if (hasKey(key)) {
            return;
        }

        set(key, data);
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override IConfiguration remove(string key) {
        _data.remove(key);
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
