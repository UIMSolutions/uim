module databases.uim.databases.mixins.expression;

import uim.databases;

@safe:

string expressionThis(string name) {
    string fullName = name~"Expression";
    return `
this() { super(); this.name("`~fullName~`"); }
    `;
}

template ExpressionThis(string name) {
    const char[] ExpressionThis = expressionThis(name);
}

string expressionCalls(string name) {
    string fullName = name~"Expression";
    return `
auto `~fullname~`() { return new D`~fullName~`(); }
    `;
}

template ExpressionCalls(string name) {
    const char[] ExpressionCalls = expressionCalls(name);
}