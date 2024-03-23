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

        override void setDefault(string key, IData newData) {
            _defaultData[key] = newData;
        }

        override void updateDefaults(IData[string] newData) {
            newData.byKeyValue
                .each!(kv => setDefault(kv.key, kv.value));
        }
    // #endregion defaultData

    // #region Data
        protected IData[string] _data;

        override IData[string] data() {
            return _data;
        }
        override void data(IData[string] newData) {
            _data = newData;
        }

        alias hasAnyKeys = DConfiguration.hasAnyKeys;
        override bool hasAnyKeys(string[] keys) {
            return keys.any!(key => hasKey(key));
        }

        alias hasAllKeys = DConfiguration.hasAllKeys;
        override bool hasAllKeys(string[] keys) {
            return keys.all!(key => hasKey(key));
        }

        override bool hasKey(string key) {
            return key in _data ? true : false;
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

    override IData[string] get(string[] keys, bool compressMode = true) {
        IData[string] results;
        
        keys.each!((key) {
            auto result = get(key);
            if (result is null && !compressMode) {
                results[key] = result;
            }
            else { // compressmode => no nulls
                results[key] = result;
            }
        });

        return results;
    }

    override IData get(string path) {
        return _data.get(path, _defaultData.get(path, null));
    }

    override void set(string key, IData newData) {
        _data[key] = newData;
    }

    override void update(string path, IData newData) {
        set(path, newData);
    }

    override void merge(string path, IData newData) {
        if (hasPath(path)) { return; }

        set(path, newData);
    }

    override void remove(string path) {
        _data.remove(path);
    }
}

mixin(ConfigurationCalls!("Memory"));

unittest {
    IConfiguration config = new DMemoryConfiguration;
    // config["test"] = StringData("stringdata");
    // config.data("data", StringData("string-data"));
}
