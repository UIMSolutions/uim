module uim.orm.mixins.association;

import uim.orm;

@safe:

module uim.logging.mixins.logger;

string loggerThis(string name) {
    auto fullname = name~"Logger";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template LoggerThis(string name) {
    const char[] LoggerThis = loggerThis(name);
}

string loggerCalls(string name) {
    auto fullname = name~"Logger";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template LoggerCalls(string name) {
    const char[] LoggerThis = loggerCalls(name);
}