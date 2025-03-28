/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.configuration;

import uim.oop;
@safe: 

string configurationThis(string name) {
    return `
        this() {
            super("`~ name ~ `Configuration");
        }
        this(Json[string] initData) {
            super("`~ name ~ `Configuration", initData);
        }
        this(string name, Json[string] initData = null) {
            super(name, initData);
        }
        string[] memberNames() {
            return [__traits(allMembers, typeof(this))];
        }
    `;
}

template ConfigurationThis(string name) {
    const char[] ConfigurationThis = configurationThis(name);
}

string configurationCalls(string name) {
    return `
        auto `~ name ~ `Configuration() { return new D` ~ name ~ `Configuration(); }
        auto `~ name ~ `Configuration(Json[string] initData) { return new D` ~ name ~ `Configuration(initData); }
        auto `~ name ~ `Configuration(string name, Json[string] initData = null) { return new D` ~ name ~ `Configuration(name, initData); }
    `;
}

template ConfigurationCalls(string name) {
    const char[] ConfigurationCalls = configurationCalls(name);
}

mixin template TConfiguration() {

}