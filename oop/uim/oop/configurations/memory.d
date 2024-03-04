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

    protected IData[string] _data;

    IData[string] data() {
        return _data;
    }

    void data(IData[string] newData) {
        _data = newData;
    }

    bool hasAnyKeys(string[] keys...) {
        return hasAnyKeys(keys.dup);
    }

    bool hasAnyKeys(string[] keys) {
        return keys.any!(key => hasKey(key));
    }

    bool hasAllKeys(string[] keys...) {
        return hasAllKeys(keys.dup);
    }

    bool hasAllKeys(string[] keys) {
        return keys.all!(key => hasKey(key));
    }

    bool hasKey(string key) {
        return (key in _data);
    }

    bool hasValues(string[] values...) {
        return false;
    }

    bool hasValues(string[] values) {
        return false;
    }

    bool hasValue(string value) {
        return false;
    }

    IData get(string key) {
        return null;
    }

    IData[string] get(string[] keys);

    void set(string key, IData newData);
    void set(string[] keys, IData[string] newData);

    void update(IData[string] newData);

    void remove(string[] keys);
}

mixin(ConfigurationCalls!("Memory"));
