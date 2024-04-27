module uim.http.mixins.cookie;

string cookieThis(string name) {
    string fullName = name ~ "Cookie";
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

template CookieThis(string name) {
    const char[] CookieThis = cookieThis(name);
}

string cookieCalls(string name) {
    string fullName = name ~ "Cookie";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template CookieCalls(string name) {
    const char[] CookieCalls = cookieCalls(name);
}