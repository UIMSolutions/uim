module uim.logging.mixins.logger;

import uim.logging;
@safe:

string loggerThis(string name = null) {
    string fullName = `"` ~ name ~ "Logger" ~ `"`;
    return objThis(fullName);
}

template LoggerThis(string name = null) {
    const char[] LoggerThis = loggerThis(name);
}

string loggerCalls(string name) {
    string fullName = name ~ "Logger";
    return objCalls(fullName);
}

template LoggerCalls(string name) {
    const char[] LoggerCalls = loggerCalls(name);
}
