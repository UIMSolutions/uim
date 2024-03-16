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
        if (configuration) {
            configuration.data(newData);
        }
    }

    // Set configuration data
    void updateConfiguration(IData[string] newData) {
        if (configuration) {
            configuration.update(newData);
        }
    }

    /* IData getConfigurationData(string key) {
        return _configuration ? _configuration.get(key) : null;
    }

    void setConfigurationData(string key, IData newData) {
        if (configuration) {
            configuration.set(key, newData);
        }
    } */
}