module uim.logging.mixins.formatter;

import uim.logging;
@safe:

string logFormatterThis(string name = null) {
    string fullName = `"` ~ name ~ "LogFormatter" ~ `"`;
    return objThis(fullName);
}

template LogFormatterThis(string name = null) {
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