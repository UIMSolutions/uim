module uim.logging.mixins.formatter;

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
    this(string name) {
        super(); this.name(name);
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
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template LogFormatterCalls(string name) {
    const char[] LogFormatterCalls = logFormatterCalls(name);
}