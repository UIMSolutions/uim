module uim.logging.mixins.engine;

import uim.logging;
@safe:

string logEngineThis(string name) {
    string fullName = name ~ "LogEngine";
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

template LogEngineThis(string name) {
    const char[] LogEngineThis = logEngineThis(name);
}

string logEngineCalls(string name) {
    string fullName = name ~ "LogEngine";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template LogEngineCalls(string name) {
    const char[] LogEngineCalls = logEngineCalls(name);
}