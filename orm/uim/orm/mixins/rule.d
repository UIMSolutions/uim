module uim.orm.mixins.rule;

string ruleThis(string name) {
    auto fullname = name~"Rule";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template RuleThis(string name) {
    const char[] RuleThis = ruleThis(name);
}

string ruleCalls(string name) {
    auto fullname = name~"Rule";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template RuleCalls(string name) {
    const char[] RuleCalls = ruleCalls(name);
}