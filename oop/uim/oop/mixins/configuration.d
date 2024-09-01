module uim.oop.mixins.configuration;

string configurationThis(string name) {
    string fullName = name ~ "Configuration";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }    `;
}

template ConfigurationThis(string name) {
    const char[] ConfigurationThis = configurationThis(name);
}

string configurationCalls(string name) {
    string fullName = name ~ "Configuration";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    auto `~ fullName ~ `(Json[string] values) { return new D` ~ fullName ~ `(values); }
    `;
}

template ConfigurationCalls(string name) {
    const char[] ConfigurationCalls = configurationCalls(name);
}

mixin template TConfiguration() {

}