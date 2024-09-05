module uim.views.mixins.context;

string contextThis(string name = null) {
    string fullName = `"` ~ name ~ "Context"~ `"`;
    return objThis(fullName);
}

template ContextThis(string name = null) {
    const char[] ContextThis = contextThis(name);
}

string contextCalls(string name) {
    string fullName = name ~ "Context";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template ContextCalls(string name) {
    const char[] ContextCalls = contextCalls(name);
}