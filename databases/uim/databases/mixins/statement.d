module uim.databases.mixins.statement;

import uim.databases;

@safe:

string statementThis(string name) {
    auto fullname = name~"Statement";
    return `
this(IData[string] initData = null) {
    initialize(initData); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template StatementThis(string name) {
    const char[] StatementThis = statementThis(name);
}

string statementCalls(string name) {
    auto fullname = name~"Statement";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template StatementCalls(string name) {
    const char[] StatementCalls = statementCalls(name);
}