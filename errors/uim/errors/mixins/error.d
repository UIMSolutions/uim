module uim.errors.mixins.error;

string errorThis(string name) {
    string fullName = name ~ "Error";
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

template ErrorThis(string name) {
    const char[] ErrorThis = errorThis(name);
}

string errorCalls(string name) {
    string fullName = name ~ "Error";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template ErrorCalls(string name) {
    const char[] ErrorCalls = errorCalls(name);
}
