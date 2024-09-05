module uim.logging.mixins.engine;

import uim.logging;
@safe:

string logEngineThis(string name = null) {
    string fullName = `"` ~ name ~ "LogEngine" ~ `"`;
    return objThis(fullName);
}

template LogEngineThis(string name = null) {
    const char[] LogEngineThis = logEngineThis(name);
}

string logEngineCalls(string name) {
    string fullName = name ~ "LogEngine";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template LogEngineCalls(string name) {
    const char[] LogEngineCalls = logEngineCalls(name);
}