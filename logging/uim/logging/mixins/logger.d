module uim.logging.mixins.logger;

string loggerThis(string name) {
    string fullName = name ~ "Logger";
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

template LoggerThis(string name) {
    const char[] LoggerThis = loggerThis(name);
}

string loggerCalls(string name) {
    string fullName = name ~ "Logger";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template LoggerCalls(string name) {
    const char[] LoggerCalls = loggerCalls(name);
}