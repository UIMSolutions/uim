module uim.i18n.mixins.middleware;

string middlewareThis(string name) {
    string fullName = name ~ "Middleware";
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

template MiddlewareThis(string name) {
    const char[] MiddlewareThis = middlewareThis(name);
}

string middlewareCalls(string name) {
    string fullName = name ~ "Middleware";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template MiddlewareCalls(string name) {
    const char[] MiddlewareCalls = middlewareCalls(name);
}