module uim.i18n.mixins.formatter;

string formatterThis(string name = null) {
    string fullName = `"` ~ name ~ "Formatter" ~ `"`;
    return `
    this() {
        super(`~ fullName ~ `);
    }
    this(Json[string] initData) {
        super(`~ fullName ~ `, initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template FormatterThis(string name = null) {
    const char[] FormatterThis = formatterThis(name);
}

string formatterCalls(string name) {
    string fullName = name ~ "Formatter";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template FormatterCalls(string name) {
    const char[] FormatterCalls = formatterCalls(name);
}