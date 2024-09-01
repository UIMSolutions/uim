module uim.http.mixins.response;

string responseThis(string name) {
    string fullName = name ~ "Response";
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

template ResponseThis(string name) {
    const char[] ResponseThis = responseThis(name);
}

string responseCalls(string name) {
    string fullName = name ~ "Response";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template ResponseCalls(string name) {
    const char[] ResponseCalls = responseCalls(name);
}