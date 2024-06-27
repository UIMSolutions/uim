module uim.commands.mixins.command;

string commandThis(string name) {
    string fullName = name ~ "Command";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        super(name);
    }
    this(string name, Json[string] initData) {
        this(name, initData);
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
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    auto `~ fullName ~ `(string name, Json[string] initData) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template CommandCalls(string name) {
    const char[] CommandCalls = commandCalls(name);
}