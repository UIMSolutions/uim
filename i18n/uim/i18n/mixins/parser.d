module uim.i18n.mixins.parser;

import uim.i18n;
@safe:

string parserThis(string name = null) {
    string fullName = `"` ~ name ~ "Parser"~`"`;
    return objThis(fullName);
}

template ParserThis(string name = null) {
    const char[] ParserThis = parserThis(name);
}

string parserCalls(string name) {
    string fullName = name ~ "Parser";
    return objCalls(fullName);
}

template ParserCalls(string name) {
    const char[] ParserCalls = parserCalls(name);
}