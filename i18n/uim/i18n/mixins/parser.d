module uim.i18n.mixins.parser;

string parserThis(string name) {
    string fullName = name ~ "Parser";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template ParserThis(string name) {
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