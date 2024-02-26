module uim.commands.mixins.command;

string commandThis(string name) {
    auto fullname = name~"Command";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template CommandThis(string name) {
    const char[] CommandThis = commandThis(name);
}

string commandCalls(string name) {
    auto fullname = name~"Command";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template CommandCalls(string name) {
    const char[] CommandThis = commandCalls(name);
}