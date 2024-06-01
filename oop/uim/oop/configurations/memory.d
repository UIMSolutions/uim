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
    
    override IConfiguration updateDefaults(Json[string] newDefaults) {
        newDefaults.byKeyValue
            .each!(kv => updateDefault(kv.key, kv.value));
        return this;
    }

    override IConfiguration updateDefault(string key, Json value) {
        _defaultData[key] = value;
        return this;
    }

    override IConfiguration mergeDefaults(Json[string] newData) {
        newData.byKeyValue
            .each!(kv => mergeDefault(kv.key, kv.value));
        return this;
    }

    override IConfiguration mergeDefault(string key, Json value) {
        if (!hasDefault(key)) {
            _defaultData[key] = value;
        }
        return this;
    }
    // #endregion defaultData

    // #region data
    protected Json[string] _data;

    override Json[string] data() {
        return _data.dup;
    }

    override IConfiguration data(Json[string] newData) {
        _data = newData.dup;
        return this;
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

    override IConfiguration set(string key, Json value) {
        _data[key] = value;
        return this;
    }

    override IConfiguration update(string key, Json value) {
        return set(key, value);
    }

    override IConfiguration merge(string key, Json value) {
        return hasKey(key)
            ? this : set(key, value);
    }

    override bool remove(string key) {
        _data.remove(key);
        return this;
    }
}

mixin(ConfigurationCalls!("Memory"));

unittest {
    testConfiguration(MemoryConfiguration);
}
