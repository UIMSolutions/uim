module uim.oop.mixins.configurable;

import uim.oop;

@safe:

mixin template TConfigurable() {
    protected IConfiguration _configuration;
    @property IConfiguration configuration() {
        return _configuration;
    }
    @property void configuration(IConfiguration newConfiguration) {
        _configuration = newConfiguration;
    }

    void setConfiguration(IData[string] newData) {
        newData.byKeyValue
            .each!(kv => _configuration.data(kv.key, kv.value));
    }

    void setConfiguration(string key, IData newData) {
        if (_configuration) {
            _configuration.data(key, newData);
        }
    }

    IData getConfiguration(string key) {
        return _configuration ? _configuration.data(key) : null;
    }
}