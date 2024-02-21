module uim.consoles.mixins.console;

string consoleThis(string name) {
    string fullName = name ~ "Console";
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

template ConsoleThis(string name) {
    const char[] ConsoleThis = consoleThis(name);
}

string consoleCalls(string name) {
    string fullName = name ~ "Console";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template ConsoleCalls(string name) {
    const char[] ConsoleCalls = consoleCalls(name);
}
