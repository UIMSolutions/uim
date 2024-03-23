module uim.logging.mixins.engine;

import uim.logging;

@safe:

string logEngineThis(string name) {
    auto fullname = name ~ "LogEngine";
    return `
this(IData[string] initData = null) {
    initialize(initData); 
    this.name("`
        ~ fullname ~ `");
}

this(string name) {
    this(); 
    this.name(name);
}
    `;
}

template LogEngineThis(string name) {
    const char[] LogEngineThis = logEngineThis(name);
}

string logEngineCalls(string name) {
    auto fullname = name ~ "LogEngine";
    return `
auto `
        ~ fullname ~ `() { return new D` ~ fullname ~ `(); }
auto `
        ~ fullname ~ `(string name) { return new D` ~ fullname ~ `(name); }
    `;
}

template LogEngineCalls(string name) {
    const char[] LogEngineCalls = logEngineCalls(name);
}
