module uim.i18n.mixins.formatter;

string formatterThis(string name) {
    string fullName = name ~ "Formatter";
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

template FormatterThis(string name) {
    const char[] FormatterThis = formatterThis(name);
}

string formatterCalls(string name) {
    string fullName = name ~ "Formatter";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template FormatterCalls(string name) {
    const char[] FormatterCalls = formatterCalls(name);
}