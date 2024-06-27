module uim.oop.consoles.mixin_;

import uim.oop;
@safe:

string consoleThis(string name) {
    string fullName = name ~ "Console";
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

template ConsoleThis(string name) {
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