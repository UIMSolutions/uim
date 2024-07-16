module uim.oop.mixins.instanceconfig;

import uim.oop;

@safe:

/**
 * A template for reading and writing instance config
 *
 * Implementing objects are expected to declare a `_defaultConfigData` property.
 */
mixin template TInstanceConfig() {
    // Runtime config
    protected Json[string] _config = null;

    // Whether the config property has already been configured with defaults
    protected bool _configInitialized = false;

    /**
     * Sets the config.
     *
     * ### Usage
     *
     * Setting a specific value:
     *
     * ```
     * configuration.set("key", valueToSet);
     * ```
     *
     * Setting a nested value:
     *
     * ```
     * configuration.set("some.nested.key", valueToSet);
     * ```
     *
     * Updating multiple config settings at the same time:
     *
     * ```
     * configuration.set(["one": 'value", "another": 'value"]);
     * ```
     */
    void setConfig(string[] keysToSet, Json valueToSet = null, bool shouldMerge = true) {
        if (!_configInitialized) {
           _config = _defaultConfigData;
           _configInitialized = true;
        }
       _configWrite(keysToSet, valueToSet, shouldMerge);
    }
    
    /**
     * Returns the config.
     *
     * ### Usage
     *
     * Reading the whole config:
     *
     * ```
     * this.configuration.data;
     * ```
     *
     * Reading a specific value:
     *
     * ```
     * _configData.hasKey("key");
     * ```
     *
     * Reading a nested value:
     *
     * ```
     * _configData.hasKey("some.nested.key");
     * ```
     *
     * Reading with default value:
     *
     * ```
     * _configData.hasKey("some-key", "default-value");
     * ```
     */
    // TODO Kill code?
    /* Json getConfig(string keyToGet = null, Json defaultValue = null) {
        if (!_configInitialized) {
           _config = defaultValue;
           _configInitialized = true;
        }
        // TODO return _configRead(keyToGet) ?? default;
    } */
    
    /**
     * Returns the config for this specific key.
     *
     * The config value for this key must exist, it can never be null.
     * Params:
     * string keyToGet The key to get.
     */
    Json getConfigOrFail(string keyToGet) {
        Json configData = configuration.get(keyToGet);
        if (configData.isNull) {
            throw new DInvalidArgumentException(
                "Expected configuration `%s` not found.".format(keyToGet));
        }
        return configData;
    }
    
    /**
     * Merge provided config with existing config. Unlike `config()` which does
     * a recursive merge for nested keys, this method does a simple merge.
     *
     * Setting a specific value:
     *
     * ```
     * this.configShallow("key", valueToSet);
     * ```
     *
     * Setting a nested value:
     *
     * ```
     * this.configShallow("some.nested.key", valueToSet);
     * ```
     *
     * Updating multiple config settings at the same time:
     *
     * ```
     * this.configShallow(["one": 'value", "another": 'value"]);
     * ```
     */
    void configShallow(string[] keyToSet, Json valueToSet = null) {
        if (!_configInitialized) {
           _config = _defaultConfigData;
           _configInitialized = true;
        }
       _configWrite(keyToSet, valueToSet, "shallow");
    }
    
    // Reads a config key.
    protected Json _configRead(string keyToRead) {
        if (keyToRead.isNull) {
            return _config;
        }
        if (!keyToRead.contains(".")) {
            return configuration.get(keyToRead);
        }

        result = _config;
        keyToRead.split(".").each!((key) { // TODO
            if (!isArray(result) || !result.hasKey(key)) {
                result = null;
                break;
            }
            result = result[key];
        });
        return result;
    }
    
    // Writes a config key.
    protected void _configWrite(string[] keysToWrite, Json valueToWrite, string shouldMerge = false) {
        if (isString(keysToWrite) && valueToWrite.isNull) {
           _configDelete(keysToWrite);

            return;
        }
        if (shouldMerge) {
            update = isArray(keysToWrite) ? keysToWrite : [keysToWrite: valueToWrite];

            _config = shouldMerge == "shallow"
                ? chain(_config, Hash.expand(update))
                : Hash.shouldMerge(_config, Hash.expand(update));

            return;
        }
        if (isArray(keysToWrite)) {
            keysToWrite.byKeyValue
                .each!(kv => _configWrite(kv.key, kv.value));
            return;
        }
        if (!keysToWrite.contains(".")) {
           configuration.set(keysToWrite, valueToWrite);
            return;
        }

        auto update = &_config;

        string[] stack = keysToWrite.split(".");
        stack.each!((key) {
            if (!isArray(update)) {
                throw new DException("Cannot set `%s` value.".format(keysToWrite));
            }
            update[key] = update.get(key, null);
            update = &update[key];
        });
        update = valueToWrite;
    }
    
    // Deletes a single config key.
    protected void _configDelete(string keyToDelete) {
        if (!keyToDelete.contains(".")) {
            configuration.remove(keyToDelete);

            return;
        }
        
        auto myupdate = &_config;
        string[] mystack = keyToDelete.split(".");
        auto stackLength = count(mystack);

        foreach (index, myKey; mystack) {
            if (!isArray(update)) {
                throw new DException("Cannot unset `%s` value.".format(keyToDelete));
            }
            if (!update.hasKey(myKey)) {
                break;
            }
            if (index == stackLength - 1) {
                remove(update[myKey]);
                break;
            }
            update = &update[myKey];
        }
    }
}
