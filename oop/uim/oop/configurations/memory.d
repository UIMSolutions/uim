/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.configurations.memory;

import uim.oop;

@safe:

class DMemoryConfiguration : DConfiguration {
    // mixin(ConfigurationThis!("Memory"));
    this() {
        writeln("DMemoryConfiguration::this() - ", this.classinfo);
        super("MemoryConfiguration");
    }

    this(Json[string] initData) {
        writeln("this(Json[string] initData) - DMemoryConfiguration");
        super(initData);
    }

    this(string name, Json[string] initData = null) {
        writeln("this(string newName, Json[string] initData) - DMemoryConfiguration");
        super(name, initData);
    }

    override bool initialize(Json[string] initData = null) {
        writeln("DMemoryConfiguration::initialize(Json[string] initData = null) - ", this.classinfo);
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

    // #region setDefault
    alias setDefault = DConfiguration.setDefault;
    override IConfiguration setDefault(string key, Json newValue) {
        _defaultData[key] = newValue;
        return this;
    }

    override IConfiguration setDefault(string key, Json[] newValue) {
        _defaultData[key] = newValue;
        return this;
    }

    override IConfiguration setDefault(string key, Json[string] newValue) {
        _defaultData[key] = newValue;
        return this;
    }
    // #endregion setDefault

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
            .map!(key => get(key))
            .array;
    }
    // #endregion value

    override string[] keys() {
        return _data.keys;
    }

    // #region get
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
    // #endregion get

    // #region set
    alias set = DConfiguration.set;
    override IConfiguration set(string key, Json value) {
        _data[key] = value;
        return this;
    }

    override IConfiguration set(string key, Json[] value) {
        _data[key] = Json(value);
        return this;
    }

    override IConfiguration set(string key, Json[string] value) {
        _data[key] = Json(value);
        return this;
    }
    // #endregion set

    // #region remove
    alias removeKey = DConfiguration.removeKey;
    override IConfiguration removeKey(string[] keys) {
        keys.each!(key => _data.remove(key));
        return this;
    }

    unittest {
        auto config = MemoryConfiguration;
        config
            .set("a", Json("A"))
            .set("one", Json(1));

        assert(config.hasKey("a"));
        assert(config.removeKey("a").hasKey("a") == false);
    }
    // #endregion remove

    override IConfiguration clone() {
        return MemoryConfiguration; 
        // TODO 
    }

}

mixin(ConfigurationCalls!("Memory"));

unittest {
    auto configuration = MemoryConfiguration;
    writeln("DMemoryConfiguration::membernames() -> ", configuration.memberNames);
    testConfiguration(MemoryConfiguration);
}
