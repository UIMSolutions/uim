module uim.commands.mixins.command;

string commandThis(string name) {
    string fullName = name ~ "Command";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(IData[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template CommandThis(string name) {
    const char[] CommandThis = commandThis(name);
}

string commandCalls(string name) {
    string fullName = name ~ "Command";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(IData[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template CommandCalls(string name) {
    const char[] CommandCalls = commandCalls(name);
}