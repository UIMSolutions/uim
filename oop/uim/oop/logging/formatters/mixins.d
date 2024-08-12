module uim.oop.logging.formatters.mixins;

string logFormatterThis(string name) {
    string fullName = name ~ "LogFormatter";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template LogFormatterThis(string name) {
    const char[] LogFormatterThis = logFormatterThis(name);
}

string logFormatterCalls(string name) {
    string fullName = name ~ "LogFormatter";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template LogFormatterCalls(string name) {
    const char[] LogFormatterCalls = logFormatterCalls(name);
}