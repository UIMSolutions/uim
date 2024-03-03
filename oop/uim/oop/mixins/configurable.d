module uim.oop.mixins.configurable;

import uim.oop;

@safe:

mixin template TConfigurable() {
    protected IConfiguration configurationuration;
    @property IConfiguration configuration() {
        return configurationuration;
    }
    @property void configuration(IConfiguration newConfiguration) {
        configurationuration = newConfiguration;
    }

    void setConfiguration(Json newData) {
        newData.byKeyValue
            .each!(kv => configurationuration.data(kv.key, kv.value));
    }

    void setConfiguration(string key, IData newData) {
        if (configurationuration) {
            configurationuration.data(key, newData);
        }
    }

    IData getConfiguration(string key) {
        return configurationuration ? configurationuration.data(key) : null;
    }
}