module uim.oop.formatters.mixins;

string FormatterThis(string name) {
    string fullName = name ~ "Formatter";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(string name) {
        super(name);
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template FormatterThis(string name) {
    const char[] FormatterThis = FormatterThis(name);
}

string FormatterCalls(string name) {
    string fullName = name ~ "Formatter";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template FormatterCalls(string name) {
    const char[] FormatterCalls = FormatterCalls(name);
}