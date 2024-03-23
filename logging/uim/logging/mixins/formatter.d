module uim.logging.mixins.formatter;

string formatterThis(string name) {
    auto fullname = name~"Formatter";
    return `
this(IData[string] initData = null) {
    initialize(initData); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template FormatterThis(string name) {
    const char[] FormatterThis = formatterThis(name);
}

string formatterCalls(string name) {
    auto fullname = name~"Formatter";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template FormatterCalls(string name) {
    const char[] FormatterCalls = formatterCalls(name);
}