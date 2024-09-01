module uim.oop.errors.mixins;

string errorThis(string name) {
    string fullName = name ~ "Error";
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

template ErrorThis(string name) {
    const char[] ErrorThis = errorThis(name);
}

string errorCalls(string name) {
    string fullName = name ~ "Error";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template ErrorCalls(string name) {
    const char[] ErrorCalls = errorCalls(name);
}