module uim.logging.loggers.mixins;

import uim.logging;
@safe:

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
    this(string name, Json[string] initData = null) {
        super(name, initData);
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
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template LoggerCalls(string name) {
    const char[] LoggerCalls = loggerCalls(name);
}
