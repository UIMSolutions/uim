module uim.oop.configurations.memory;

import uim.oop;

@safe:

class DMemoryConfiguration : DConfiguration {
    mixin(ConfigurationThis!("Memory"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // #region defaultData
        protected Json[string] _defaultData;
        override Json[string] defaultData() {
            return _defaultData.dup;
        }

        override void defaultData(Json[string] newData) {
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

        override void updateDefaults(Json[string] dataArray) {
            dataArray.byKeyValue
                .each!(kv => updateDefault(kv.key, kv.value));
        }
        /// 
        unittest {
            IConfiguration config = MemoryConfiguration;
            // TODO
        }

        override void updateDefault(string key, Json data) {
            _defaultData[key] = data;
        }
        /// 
        unittest {
            IConfiguration config = MemoryConfiguration;
            // TODO
        }

        override void mergeDefaults(Json[string] dataArray) {
            dataArray.byKeyValue
                .each!(kv => mergeDefault(kv.key, kv.value));
        }
        /// 
        unittest {
            IConfiguration config = MemoryConfiguration;
            // TODO
        }

        override void mergeDefault(string key, Json data) {
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
    protected Json[string] _data;

    override Json[string] data() {
        return _data.dup;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void data(Json[string] newData) {
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
    
    override bool hasKey(string[] path) {
        if (path.length > 1) {
            return hasKey(path[0])
            ? hasKey(path[1..$])
            : false;
        }
        return path.length == 1
            ? hasKey(path[0])
            : false;
    }; 

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
            .any!(kv => kv.value.to!string == value);
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

    override Json[string] get(string[] selectKeys, bool compressMode = true) {
        Json[string] results;

        selectKeys.each!((key) {
            Json result = get(key);
            if (result is Json(null) && !compressMode) {
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

    alias get = DConfiguration.get; 
    override Json get(string key, Json defaultValue = Json(null)) {
        return _data.hasKey(key) 
            ? _data[key]
            : defaultValue;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void set(string key, Json data) {
        _data[key] = data;
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void update(string key, Json data) {
        set(key, data);
    }

    override void update(string key, Json[string] data) {
        set(key, data.toJsonObject);
    }
    /// 
    unittest {
        IConfiguration config = MemoryConfiguration;
        // TODO
    }

    override void merge(string key, Json[string] data) {
        set(key, data.toJsonObject);
    }

    override void merge(string key, Json data) {
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
