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
     * configuration.update("key", aValue);
     * ```
     *
     * Setting a nested value:
     *
     * ```
     * configuration.update("some.nested.key", aValue);
     * ```
     *
     * Updating multiple config settings at the same time:
     *
     * ```
     * configuration.update(["one": 'value", "another": 'value"]);
     * ```
     * Params:
     * Json[string]|string keyToSet The key to set, or a complete array of configs.
     * @param mixed|null aValue The value to set.
     * @param bool merge Whether to recursively merge or overwrite existing config, defaults to true.
     */
    void setConfig(string[] keyToSet, Json aValue = null, bool shouldMerge = true) {
        if (!_configInitialized) {
           _config = _defaultConfigData;
           _configInitialized = true;
        }
       _configWrite(keyToSet, aValue, shouldMerge);
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
     * _configData.isSet("key");
     * ```
     *
     * Reading a nested value:
     *
     * ```
     * _configData.isSet("some.nested.key");
     * ```
     *
     * Reading with default value:
     *
     * ```
     * _configData.isSet("some-key", "default-value");
     * ```
     * Params:
     * @param Json defaultValue The return value when the key does not exist.
     */
    Json getConfig(string keyToGet = null, Json defaultData = null) {
        if (!_configInitialized) {
           _config = _defaultConfigData;
           _configInitialized = true;
        }
        return _configRead(keyToGet) ?? default;
    }
    
    /**
     * Returns the config for this specific key.
     *
     * The config value for this key must exist, it can never be null.
     * Params:
     * string keyToGet The key to get.
     */
    Json getConfigOrFail(string keyToGet) {
        configData = configuration.get(keyToGet);
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
     * this.configShallow("key", aValue);
     * ```
     *
     * Setting a nested value:
     *
     * ```
     * this.configShallow("some.nested.key", aValue);
     * ```
     *
     * Updating multiple config settings at the same time:
     *
     * ```
     * this.configShallow(["one": 'value", "another": 'value"]);
     * ```
     * Params:
     * Json[string]|string keyToSet The key to set, or a complete array of configs.
     * @param mixed|null aValue The value to set.
     */
    void configShallow(string[] keyToSet, Json aValue = null) {
        if (!_configInitialized) {
           _config = _defaultConfigData;
           _configInitialized = true;
        }
       _configWrite(keyToSet, aValue, "shallow");
    }
    
    // Reads a config key.
    protected Json _configRead(string keyToRead) {
        if (keyToRead.isNull) {
            return _config;
        }
        if (!keyToRead.has(".")) {
            return configuration.data(keyToRead] ?? null;
        }
        result = _config;

        foreach (myKey; keyToRead.split(".")) {
            if (!isArray(result) || !isSet(result[myKey])) {
                result = null;
                break;
            }
            result = result[myKey];
        }
        return result;
    }
    
    /**
     * Writes a config key.
     * Params:
     * Json[string]|string keyToWrite Key to write to.
     * @param Json aValue Value to write.
     * @param string merge True to merge recursively, "shallow' for simple merge,
     * false to overwrite, defaults to false.
     * @throws \UIM\Core\Exception\UimException if attempting to clobber existing config
     */
    protected void _configWrite(string[] keyToWrite, Json aValue, string merge = false) {
        if (isString(keyToWrite) && aValue.isNull) {
           _configDelete(keyToWrite);

            return;
        }
        if (merge) {
            update = isArray(keyToWrite) ? keyToWrite : [keyToWrite: aValue];

            _config = merge == "shallow"
                ? chain(_config, Hash.expand(update))
                : Hash.merge(_config, Hash.expand(update));

            return;
        }
        if (isArray(keyToWrite)) {
            keyToWrite.byKeyValue
                .each!(kv => _configWrite(kv.key, kv.value));
            return;
        }
        if (!keyToWrite.has(".")) {
           configuration.data(keyToWrite] = aValue;e

            return;
        }
        update = &_config;
        string[] stack = keyToWrite.split(".");

        foreach (myKey; stack) {
            if (!isArray(update)) {
                throw new UimException("Cannot set `%s` value.".format(keyToWrite));
            }
            update[myKey] = update.get(myKey, null);
            update = &update[myKey];
        }
        update = aValue;
    }
    
    /**
     * Deletes a single config key.
     * Params:
     * string keyToDelete Key to delete.
     * @throws \UIM\Core\Exception\UimException if attempting to clobber existing config
     */
    protected void _configDelete(string keyToDelete) {
        if (!keyToDelete.has(".")) {
            configuration.remove(keyToDelete);

            return;
        }
        
        auto myupdate = &_config;
        string[] mystack = keyToDelete.split(".");
        auto stackLength = count(mystack);

        foreach (index, myKey; mystack) {
            if (!isArray(update)) {
                throw new UimException("Cannot unset `%s` value.".format(keyToDelete));
            }
            if (!update.isSet(myKey)) {
                break;
            }
            if (index == stackLength - 1) {
                unset(update[myKey]);
                break;
            }
            update = &update[myKey];
        }
    }
}
