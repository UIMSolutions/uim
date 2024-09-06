module uim.http.mixins.cookie;

string cookieThis(string name = null) {
    string fullName = `"` ~ name ~ "Cookie" ~ `"`;
    return objThis(fullName);
}

template CookieThis(string name = null) {
    const char[] CookieThis = cookieThis(name);
}

string cookieCalls(string name) {
    string fullName = name ~ "Cookie";
    return objCalls(fullName);
}

template CookieCalls(string name) {
    const char[] CookieCalls = cookieCalls(name);
}
