module uim.oop.configurations.mixin_;

string configurationThis(string name) {
    string fullName = name ~ "Configuration";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    this(Json[string] values) {
        super(); this.data(values);
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