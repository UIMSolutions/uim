module uim.oop.formatters.mixins;

string FormatterThis(string name) {
    string fullName = name ~ "Formatter";
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

template FormatterThis(string name) {
    const char[] FormatterThis = FormatterThis(name);
}

string FormatterCalls(string name) {
    string fullName = name ~ "Formatter";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template FormatterCalls(string name) {
    const char[] FormatterCalls = FormatterCalls(name);
}