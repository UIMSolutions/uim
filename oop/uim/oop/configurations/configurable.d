module uim.oop.configurations.configurable;

import uim.oop;

@safe:

mixin template TConfigurable() {
    protected IConfiguration _configuration;

    // Get configuration
    @property IConfiguration configuration() {
        return _configuration;
    }

    // Set configuration
    @property void configuration(IConfiguration newConfiguration) {
        _configuration = newConfiguration;
    }

    // Get configuration data
    IData[string] configurationData() {
        return _configuration ? _configuration.data() : null;
    }

    // Set configuration data
    void configurationData(IData[string] newData) {
        if (_configuration) {
            _configuration.data(newData);
        }
    }


    /* IData getConfiguration(string key) {
        return _configuration ? _configuration.get(key) : null;
    }

    void setConfiguration(string key, IData newData) {
        if (_configuration) {
            _configuration.set(key, newData);
        }
    } */
}