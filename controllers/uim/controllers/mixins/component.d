module uim.components.mixins.component;

string componentThis(string name) {
    string fullName = name ~ "Component";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
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
