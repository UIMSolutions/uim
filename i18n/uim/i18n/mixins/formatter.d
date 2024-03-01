module uim.i18n.mixins.formatteratter;

string formatterThis(string name) {
    string fullName = name ~ "Formatter";
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

template FormatterThis(string name) {
    const char[] FormatterThis = formatterThis(name);
}

string formatterCalls(string name) {
    string fullName = name ~ "Formatter";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template FormatterCalls(string name) {
    const char[] FormatterCalls = formatterCalls(name);
}