module uim.http.mixins.cookie;

string cookieThis(string name = null) {
    string fullName = `"` ~ name ~ "Cookie" ~`"`;
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

template CookieThis(string name = null) {
    const char[] CookieThis = cookieThis(name);
}

string cookieCalls(string name) {
    string fullName = name ~ "Cookie";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template CookieCalls(string name) {
    const char[] CookieCalls = cookieCalls(name);
}