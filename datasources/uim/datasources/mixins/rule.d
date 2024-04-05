module uim.datasources.mixins.rule;

import uim.datasources;

@safe:

string datasourceRuleThis(string name) {
    string fullName = name ~ "DatasourceRule";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template DatasourceRuleThis(string name) {
    const char[] DatasourceRuleThis = datasourceRuleThis(name);
}

string datasourceRuleCalls(string name) {
    string fullName = name ~ "DatasourceRule";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template DatasourceRuleCalls(string name) {
    const char[] DatasourceRuleCalls = datasourceRuleCalls(name);
}