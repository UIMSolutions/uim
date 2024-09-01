module uim.i18n.mixins.translator;

string translatorThis(string name) {
    string fullName = name ~ "Translator";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    `;
}

template TranslatorThis(string name) {
    const char[] TranslatorThis = translatorThis(name);
}

string translatorCalls(string name) {
    string fullName = name ~ "Translator";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template TranslatorCalls(string name) {
    const char[] TranslatorCalls = translatorCalls(name);
}
