module uim.oop.configurations.memory;

import uim.oop;

@safe:

class DMemoryConfiguration : DConfiguration {
    mixin(ConfigurationThis!("Memory"));

    override bool initialize(Json[string] initvalue = null) {
        if (!super.initialize(initvalue)) {
            return false;
        }

        return true;
    }

    // #region defaultData
    protected Json[string] _defaultData;
    override Json[string] defaultData() {
        return _defaultData.dup;
    }

    override IConfiguration defaultData(Json[string] newValue) {
        _defaultData = newValue.dup;
        return this;
    }

    // override bool hasDefault(string key)
    override bool hasDefault(string key) {
        return (key in _defaultData) ? true : false;
    }
    
    override Json getDefault(string key) {
        return (key in _defaultData) ? _defaultData[key] : Json(null);
    }
    
    override bool updateDefaults(Json[string] newDefaults) {
        return newDefaults.byKeyValue
            .all!(kv => updateDefault(kv.key, kv.value));
    }

    override bool updateDefault(string key, Json value) {
        _defaultData[key] = value;
        return true;
    }

    override bool mergeDefaults(Json[string] newData) {
        return newData.byKeyValue
            .all!(kv => mergeDefault(kv.key, kv.value));
    }

    override bool mergeDefault(string key, Json value) {
        if (!hasDefault(key)) {
            _defaultData[key] = value;
            return true; 
        }
        return false; 
    }
    // #endregion defaultData

    // #region data
    // Set and get data
    protected Json[string] _data;

    override Json[string] data() {
        return _data.dup;
    }

    override void data(Json[string] newData) {
        _data = newData.dup;
    }
    // #endregion data

    // #region key
    alias hasAnyKeys = DConfiguration.hasAnyKeys;
    override bool hasAnyKeys(string[] keys) {
        return keys.any!(key => hasKey(key));
    }

    alias hasAllKeys = DConfiguration.hasAllKeys;
    override bool hasAllKeys(string[] keys) {
        return keys.all!(key => hasKey(key));
    }

    override bool hasKey(string key) {
        return (key in _data) || hasDefault(key) ? true : false;
    }
    // #endregion key

    // #region value
    alias hasAnyValues = DConfiguration.hasAnyValues;
    override bool hasAnyValues(Json[] values) {
        return values.any!(value => hasValue(value));
    }

    alias hasAllValues = DConfiguration.hasAllValues;
    override bool hasAllValues(Json[] values) {
        return values.all!(value => hasValue(value));
    }

    override bool hasValue(Json value) {
        return _data.byKeyValue
            .any!(kv => kv.value == value);
    }

    override Json[] values(string[] includedKeys = null) {
        return includedKeys.length == 0
            ? _data.values : includedKeys
            .filter!(key => hasKey(key))
            .map!(key => get(key)).array;
    }
    // #endregion value

    override string[] keys() {
        return _data.keys;
    }

    override Json[string] get(string[] selectKeys, bool compressMode = true) {
        Json[string] results;

        selectKeys.each!((key) {
            Json result = get(key);
            if (result is Json(null) && !compressMode) {
                results[key] = result;
            }
        });

        return results;
    }

    override Json get(string key, Json defaultValue = Json(null)) {
        if (key.length == 0) {
            return Json(null);
        }

        if (key in _data) {
            return _data[key];
        }

        return defaultValue.isNull
            ? getDefault(key) : defaultValue;
    }

    alias set = DConfiguration.set;
    override bool set(string key, Json value) {
        _data.set(key, value);
        return true;
    }
    override bool set(string key, Json[] value) {
        _data.set(key, value);
        return true;
    }
    override bool set(string key, Json[string] value) {
        _data.set(key, value);
        return true;
    }

    override bool updateKey(string key, Json value) {
        return set(key, value);
    }

    override bool merge(string key, Json value) {
        return hasKey(key)
            ? false : set(key, value);
    }

    alias remove = DConfiguration.remove;
    override IConfiguration remove(string[] keys) {
        keys.each!(key => _data.remove(key));
        return this;
    }
}

mixin(ConfigurationCalls!("Memory"));

unittest {
    testConfiguration(MemoryConfiguration);
}
