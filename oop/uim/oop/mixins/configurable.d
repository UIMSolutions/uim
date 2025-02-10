/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.configurable;

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
    Json[string] getConfigurationData() {
        return configuration ? configuration.data() : null;
    }

    // Set configuration data
    void setConfigurationData(Json[string] newData) {
        if (configuration) {
            configuration.data(newData);
        }
    }

    // Set configuration data
    /* void updateConfiguration(Json[string] newData) {
        if (configuration) {
            configuration.set(newData);
        }
    } */

    // TODO
    /* Json getConfigurationData(string key) {
        return _configuration ? _configuration.get(key) : null;
    }

    void setConfigurationData(string key, Json newData) {
        if (configuration) {
            configuration.set(key, newData);
        }
    } */
}