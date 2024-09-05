module uim.http.mixins.session;

string sessionThis(string name = null) {
    string fullName = `"` ~ name ~ "Session" ~ `"`;
    return objThis(fullName);
}

template SessionThis(string name = null) {
    const char[] SessionThis = sessionThis(name);
}

string sessionCalls(string name) {
    string fullName = name ~ "Session";
    return objCalls(fullName);
}

template SessionCalls(string name) {
    const char[] SessionCalls = sessionCalls(name);
}