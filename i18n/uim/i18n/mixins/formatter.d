module uim.i18n.mixins.formatter;

string formatterThis(string name = null) {
    string fullName = `"` ~ name ~ "Formatter" ~ `"`;
    return objThis(fullName);
}

template FormatterThis(string name = null) {
    const char[] FormatterThis = formatterThis(name);
}

string formatterCalls(string name) {
    string fullName = name ~ "Formatter";
    return objCalls(fullName);
}

template FormatterCalls(string name) {
    const char[] FormatterCalls = formatterCalls(name);
}