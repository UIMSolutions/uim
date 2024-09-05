module uim.consoles.mixins.console;

string consoleThis(string name = null) {
    string fullName = `"` ~ name ~ "Console" ~ `"`;
    return objThis(fullName);
}

template ConsoleThis(string name = null) {
    const char[] ConsoleThis = consoleThis(name);
}

string consoleCalls(string name) {
    string fullName = name ~ "Console";
    return objCalls(fullName);
}

template ConsoleCalls(string name) {
    const char[] ConsoleCalls = consoleCalls(name);
}
