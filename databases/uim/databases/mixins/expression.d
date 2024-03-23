module uim.databases.mixins.expression;

import uim.databases;

@safe:

string expressionThis(string name) {
    auto fullname = name~"Expression";
    return `
this(IData[string] initData = null) {
    initialize(initData); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template ExpressionThis(string name) {
    const char[] ExpressionThis = expressionThis(name);
}

string expressionCalls(string name) {
    auto fullname = name~"Expression";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template ExpressionCalls(string name) {
    const char[] ExpressionCalls = expressionCalls(name);
}