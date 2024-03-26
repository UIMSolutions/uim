module uim.databases.mixins.statement;

string statementThis(string name) {
    string fullName = name ~ "Statement";
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

template StatementThis(string name) {
    const char[] StatementThis = statementThis(name);
}

string statementCalls(string name) {
    string fullName = name ~ "Statement";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(IData[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template StatementCalls(string name) {
    const char[] StatementCalls = statementCalls(name);
}