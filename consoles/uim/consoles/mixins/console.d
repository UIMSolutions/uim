module uim.consoles.mixins.console;

string consoleThis(string name = null) {
    string fullName = name ~ "Console";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template ConsoleThis(string name = null) {
    const char[] ConsoleThis = consoleThis(name);
}

string consoleCalls(string name) {
    string fullName = name ~ "Console";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template ConsoleCalls(string name) {
    const char[] ConsoleCalls = consoleCalls(name);
}
