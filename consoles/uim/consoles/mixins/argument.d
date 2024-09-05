module uim.consoles.mixins.argument;

string argumentThis(string name = null) {
    string fullName = `"` ~ name ~ "Argument" ~ `"`;
    return objThis(fullName);
}

template ArgumentThis(string name = null) {
    const char[] ArgumentThis = argumentThis(name);
}

string argumentCalls(string name) {
    string fullName = name ~ "Argument";
    return objCalls(fullName);
}

template ArgumentCalls(string name) {
    const char[] ArgumentCalls = argumentCalls(name);
}