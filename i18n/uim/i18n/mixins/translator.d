module uim.i18n.mixins.translator;

string translatorThis(string name) {
    string fullName = name ~ "Translator";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template TranslatorThis(string name) {
    const char[] TranslatorThis = translatorThis(name);
}

string translatorCalls(string name) {
    string fullName = name ~ "Translator";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template TranslatorCalls(string name) {
    const char[] TranslatorCalls = translatorCalls(name);
}
