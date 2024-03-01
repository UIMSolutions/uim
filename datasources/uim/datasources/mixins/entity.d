module uim.datasources.mixins.entity;

string entityThis(string name) {
    string fullName = name ~ "Entity";
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

template EntityThis(string name) {
    const char[] EntityThis = entityThis(name);
}

string entityCalls(string name) {
    string fullName = name ~ "Entity";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template EntityCalls(string name) {
    const char[] EntityCalls = entityCalls(name);
}
