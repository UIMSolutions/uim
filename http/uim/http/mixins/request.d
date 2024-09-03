module uim.http.mixins.request;

string requestThis(string name = null) {
    string fullName = name ~ "Request";
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

template RequestThis(string name = null) {
    const char[] RequestThis = requestThis(name);
}

string requestCalls(string name) {
    string fullName = name ~ "Request";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template RequestCalls(string name) {
    const char[] RequestCalls = requestCalls(name);
}