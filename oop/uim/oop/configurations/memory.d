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

    // #region update
        override IConfiguration update(string key, Json value) {
            if (hasKey(key)) {
                set(key, value);
            }
            return this;
        }

        unittest {
            auto config = MemoryConfiguration;
            config
                .set("a", Json("A"))
                .set("one", Json(1));

            assert(config.getString("a") == "A");
            assert(config.update("a", "B").getString("a") == "B");
            assert(config.update("x", "X").hasKey("x") == false);
        }
    // #endregion update

    // #region merge
    override IConfiguration merge(string key, Json value) {
        if (!hasKey(key)) {
            set(key, value);
        }
        return this;
    }

    unittest {
        auto config = MemoryConfiguration;
        config
            .set("a", Json("A"))
            .set("one", Json(1));

        assert(config.getString("a") == "A");
        assert(config.merge("a", "B").getString("a") == "A");
        assert(config.merge("x", "X").hasKey("x"));
    }
    // #endregion merge

    // #region remove
    alias remove = DConfiguration.remove;
    override IConfiguration remove(string[] keys) {
        keys.each!(key => _data.remove(key));
        return this;
    }

    unittest {
        auto config = MemoryConfiguration;
        config
            .set("a", Json("A"))
            .set("one", Json(1));

        assert(config.hasKey("a"));
        assert(config.remove("a").hasKey("a") == false);
    }
    // #endregion remove
}

mixin(ConfigurationCalls!("Memory"));

unittest {
    testConfiguration(MemoryConfiguration);
}
