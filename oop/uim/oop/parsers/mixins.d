module uim.oop.parsers.mixins;

string parserThis(string name = null) {
    string fullName = `"` ~ name ~ "Parser" ~ `"`;
    return objThis(fullName);
}

template ParserThis(string name = null) {
    const char[] ParserThis = parserThis(name);
}

string parserCalls(string name) {
    string fullName = name ~ "Parser";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template ParserCalls(string name) {
    const char[] ParserCalls = parserCalls(name);
}