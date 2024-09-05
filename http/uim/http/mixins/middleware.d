module uim.http.mixins.middleware;

string middlewareThis(string name = null) {
    string fullName = `"` ~ name ~ "Middleware" ~ `"`;
    return objThis(fullName);
}

template MiddlewareThis(string name = null) {
    const char[] MiddlewareThis = middlewareThis(name);
}

string middlewareCalls(string name) {
    string fullName = name ~ "Middleware";
    return objCalls(fullName);
}

template MiddlewareCalls(string name) {
    const char[] MiddlewareCalls = middlewareCalls(name);
}