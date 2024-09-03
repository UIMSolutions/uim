module uim.consoles.mixins.argument;

string argumentThis(string name = null) {
    string fullName = name ~ "Argument";
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

template ArgumentThis(string name = null) {
    const char[] ArgumentThis = argumentThis(name);
}

string argumentCalls(string name) {
    string fullName = name ~ "Argument";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template ArgumentCalls(string name) {
    const char[] ArgumentCalls = argumentCalls(name);
}