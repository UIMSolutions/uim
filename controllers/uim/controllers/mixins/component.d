module uim.controllers.mixins.component;

string componentThis(string name) {
    string fullName = name ~ "Component";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(string name) {
        super(name);
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template ComponentThis(string name) {
    const char[] ComponentThis = componentThis(name);
}

string componentCalls(string name) {
    string fullName = name ~ "Component";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template ComponentCalls(string name) {
    const char[] ComponentCalls = componentCalls(name);
}
