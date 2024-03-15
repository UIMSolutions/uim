module uim.orm.mixins.association;

string associationThis(string name) {
    auto fullname = name~"Association";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template AssociationThis(string name) {
    const char[] AssociationThis = associationThis(name);
}

string associationCalls(string name) {
    auto fullname = name~"Association";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template AssociationCalls(string name) {
    const char[] AssociationCalls = associationCalls(name);
}