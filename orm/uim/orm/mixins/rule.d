module uim.orm.mixins.rule;

string ruleThis(string name) {
    string fullName = name ~ "Rule";
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

template RuleThis(string name) {
    const char[] RuleThis = ruleThis(name);
}

string ruleCalls(string name) {
    string fullName = name ~ "Rule";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template RuleCalls(string name) {
    const char[] RuleCalls = ruleCalls(name);
}