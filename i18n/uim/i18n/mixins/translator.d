module uim.i18n.mixins.translator;

string translatorThis(string name = null) {
    string fullName = `"`~ name ~ "Translator" ~ `"`;
    return objThis(fullName);
}

template TranslatorThis(string name = null) {
    const char[] TranslatorThis = translatorThis(name);
}

string translatorCalls(string name) {
    string fullName = name ~ "Translator";
    return objCalls(fullName);
}

template TranslatorCalls(string name) {
    const char[] TranslatorCalls = translatorCalls(name);
}
