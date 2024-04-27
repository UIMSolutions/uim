module uim.http.mixins.response;

string responseThis(string name) {
    string fullName = name ~ "Response";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
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
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template ResponseCalls(string name) {
    const char[] ResponseCalls = responseCalls(name);
}