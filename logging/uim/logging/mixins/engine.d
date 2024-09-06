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
    return objCalls(fullName);
}

template LogEngineCalls(string name) {
    const char[] LogEngineCalls = logEngineCalls(name);
}