module uim.http.mixins.session;

string sessionThis(string name = null) {
    string fullName = `"` ~ name ~ "Session" ~ `"`;
    return `
    this() {
        super(`~ fullName ~ `);
    }
    this(Json[string] initData) {
        super(`~ fullName ~ `, initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template SessionThis(string name = null) {
    const char[] SessionThis = sessionThis(name);
}

string sessionCalls(string name) {
    string fullName = name ~ "Session";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template SessionCalls(string name) {
    const char[] SessionCalls = sessionCalls(name);
}