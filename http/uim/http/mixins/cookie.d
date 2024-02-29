module http.uim.http.mixins.cookie;

string cookieThis(string name) {
    auto fullname = name~"Cookie";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template CookieThis(string name) {
    const char[] CookieThis = cookieThis(name);
}

string cookieCalls(string name) {
    auto fullname = name~"Cookie";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template CookieCalls(string name) {
    const char[] CookieThis = cookieCalls(name);
}