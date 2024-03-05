module uim.oop.datatypes.mixin_;

string dataThis(string name) {
    string fullName = name ~ "Data";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    `;
}

template DataThis(string name) {
    const char[] DataThis = dataThis(name);
}

string dataCalls(string name) {
    string fullName = name ~ "Data";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    `;
}

template DataCalls(string name) {
    const char[] DataCalls = dataCalls(name);
}
