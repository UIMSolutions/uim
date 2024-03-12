module uim.consoles.mixins.command;

string consoleCommandThis(string name) {
    string fullName = name ~ "ConsoleCommand";
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

template ConsoleCommandThis(string name) {
    const char[] ConsoleCommandThis = consoleCommandThis(name);
}

string consoleCommandCalls(string name) {
    string fullName = name ~ "ConsoleCommand";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template ConsoleCommandCalls(string name) {
    const char[] ConsoleCommandCalls = consoleCommandCalls(name);
}
