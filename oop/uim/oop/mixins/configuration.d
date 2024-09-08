module uim.oop.mixins.configuration;

import uim.oop;
@safe: 

string configurationThis(string name = null) {
    string fullName = name ~ "Configuration";
    return objThis(fullName);
}

template ConfigurationThis(string name = null) {
    const char[] ConfigurationThis = configurationThis(name);
}

string configurationCalls(string name) {
    string fullName = name ~ "Configuration";
    return objCalls(fullName);
}

template ConfigurationCalls(string name) {
    const char[] ConfigurationCalls = configurationCalls(name);
}

mixin template TConfiguration() {

}