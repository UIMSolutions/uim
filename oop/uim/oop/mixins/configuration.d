module uim.oop.mixins.configuration;

string configurationThis(string name = null) {
    string fullName = `"` ~ name ~ "Configuration" ~ `"`;
    return objThis(fullName);
}

template ConfigurationThis(string name = null) {
    const char[] ConfigurationThis = configurationThis(name);
}

string configurationCalls(string name) {
    string fullName = name ~ "Configuration";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template ConfigurationCalls(string name) {
    const char[] ConfigurationCalls = configurationCalls(name);
}

mixin template TConfiguration() {

}