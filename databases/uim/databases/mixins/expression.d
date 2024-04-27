module uim.databases.mixins.expression;

string expressionThis(string name) {
    string fullName = name ~ "Expression";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template ExpressionThis(string name) {
    const char[] ExpressionThis = expressionThis(name);
}

string expressionCalls(string name) {
    string fullName = name ~ "Expression";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template ExpressionCalls(string name) {
    const char[] ExpressionCalls = expressionCalls(name);
}