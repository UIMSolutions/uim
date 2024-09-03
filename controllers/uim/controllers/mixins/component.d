module uim.controllers.mixins.component;

string componentThis(string name = null) {
    string fullName = name ~ "Component";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template ComponentThis(string name = null) {
    const char[] ComponentThis = componentThis(name);
}

string componentCalls(string name) {
    string fullName = name ~ "Component";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template ComponentCalls(string name) {
    const char[] ComponentCalls = componentCalls(name);
}
