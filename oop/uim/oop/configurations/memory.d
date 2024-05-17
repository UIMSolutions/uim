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
    }

    // override bool hasDefault(string key)
    override bool hasDefault(string key) {
        return (key in _defaultData) ? true : false;
    }

    override IConfiguration updateDefaults(Json[string] updateData) {
        updateData.byKeyValue
            .each!(kv => updateDefault(kv.key, kv.value));
        return this;
    }

    override IConfiguration updateDefault(string key, Json value) {
        _defaultData[key] = value;
        return this;
    }

    override IConfiguration mergeDefaults(Json[string] valueMap) {
        valueMap.byKeyValue
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
        _data = newValue.dup;
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
        return key in _values ? true : false;
    }
    // #endregion key

    alias hasAnyValues = DConfiguration.hasAnyValues;
    override bool hasAnyValues(string[] values) {
        return values.any!(value => hasValue(value));
    }

    alias hasAllValues = DConfiguration.hasAllValues;
    override bool hasAllValues(string[] values) {
        return values.all!(value => hasValue(value));
    }
    // #region value

    override bool hasValue(Json value) {
        return _values.byKeyValue
            .any!(kv => kv.value == value);
    }

    override string[] allKeys() {
        return _values.keys;
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

    override Json get(string key, Json defaultData = Json(null)) {
        debug writeln("key = ", key);
        if (key.strip.length == 0) {
            return Json(null);
        }
        Json result = _values.hasKey(key) 
            ? _values[key]
            : Json(null);
        debug writeln("result = ", result);

        if (result == Json(null)) {
            result = defaultData != Json(null)
            ? defaultData
            : _defaultData.get(key, Json(null));
        }
        debug writeln("result = ", result);

        return result; 
    }

    override IConfiguration set(string key, Json value) {
        _values[key] = value;
    }

    override IConfiguration update(string key, Json value) {
        set(key, value);
    }

    unittest {
        writeln(__MODULE__, " in ", __LINE__);
        IConfiguration config = MemoryConfiguration(["a": Json(1)]);
        config.update("a", Json(2));
        assert(config.get("a").to!int == 2);
    }

    override IConfiguration update(string key, Json[string] value) {
        set(key, value.toJsonObject);
        return this;
    }

    override IConfiguration merge(string key, Json[string] value) {
        set(key, value.toJsonObject);
        return this;
    }

    override IConfiguration merge(string key, Json value) {
        if (hasKey(key)) {
            return;
        }

        set(key, value);
        return this;
    }
    /// 
    unittest {
        writeln(__MODULE__, " in ", __LINE__);
        IConfiguration config = MemoryConfiguration(["a": Json(1)]);
        config.merge("a", Json(2));
        assert(config.get("a").to!int == 1);
        config.merge("b", Json(2));
        assert(config.get("b").to!int == 2);
    }

    override IConfiguration remove(string key) {
        _values.remove(key);
        return this;
    }
}

mixin(ConfigurationCalls!("Memory"));

unittest {
    testConfiguration(MemoryConfiguration);
}
