module uim.orm.mixins.association;

string associationThis(string name) {
    string fullName = name ~ "Association";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template AssociationThis(string name) {
    const char[] AssociationThis = associationThis(name);
}

string associationCalls(string name) {
    string fullName = name ~ "Association";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template AssociationCalls(string name) {
    const char[] AssociationCalls = associationCalls(name);
}