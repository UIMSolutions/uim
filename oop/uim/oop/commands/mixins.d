module uim.oop.commands.mixins;

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
    this(string name, Json[string] initData = null) {
        super(name, initData);
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
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template CommandCalls(string name) {
    const char[] CommandCalls = commandCalls(name);
}