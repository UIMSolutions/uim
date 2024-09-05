module uim.oop.formatters.mixins;

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
    return objCalls(fullName);
}

template FormatterCalls(string name) {
    const char[] FormatterCalls = formatterCalls(name);
}