module uim.logging.mixins.logger;

import uim.logging;
@safe:

string loggerThis(string name = null) {
    string fullName = `"` ~ name ~ "Logger" ~ `"`;
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

template LoggerThis(string name = null) {
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
