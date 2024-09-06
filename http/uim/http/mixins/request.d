module uim.http.mixins.request;

string requestThis(string name = null) {
    string fullName = `"` ~ name ~ "Request" ~ `"`;
    return objThis(fullName);
}

template RequestThis(string name = null) {
    const char[] RequestThis = requestThis(name);
}

string requestCalls(string name) {
    string fullName = name ~ "Request";
    return objCalls(fullName);
}

template RequestCalls(string name) {
    const char[] RequestCalls = requestCalls(name);
}
