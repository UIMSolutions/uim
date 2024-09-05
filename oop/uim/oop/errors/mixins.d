module uim.oop.errors.mixins;

string errorThis(string name = null) {
    string fullName = `"` ~ name ~ "Error" ~ `"`;
    return objThis(fullName);
}

template ErrorThis(string name = null) {
    const char[] ErrorThis = errorThis(name);
}

string errorCalls(string name) {
    string fullName = name ~ "Error";
    return objCalls(fullName);
}

template ErrorCalls(string name) {
    const char[] ErrorCalls = errorCalls(name);
}