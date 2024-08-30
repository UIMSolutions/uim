module uim.views.mixins.context;

string contextThis(string name) {
    string fullName = name ~ "Context";
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

template ContextThis(string name) {
    const char[] ContextThis = contextThis(name);
}

string contextCalls(string name) {
    string fullName = name ~ "Context";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template ContextCalls(string name) {
    const char[] ContextCalls = contextCalls(name);
}