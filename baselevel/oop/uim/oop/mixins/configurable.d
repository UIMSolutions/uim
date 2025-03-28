/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.configurable;

mixin(Version!"test_uim_oop");

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

    // Get configuration entries
    Json[string] configurationEntries() {
        return configuration ? configuration.entries() : null;
    }

    // Set configuration entries
    void configurationEntries(Json[string] newEntries) {
        if (configuration) {
            configuration.entries(newEntries);
        }
    }

    // Set configuration entries
    /* void updateConfiguration(Json[string] newEntries) {
        if (configuration) {
            configuration.set(newEntries);
        }
    } */

    // TODO
    /* Json getConfigurationEntries(string key) {
        return _configuration ? _configuration.get(key) : null;
    }

    void setConfigurationEntries(string key, Json newEntries) {
        if (configuration) {
            configuration.set(key, newEntries);
        }
    } */
}