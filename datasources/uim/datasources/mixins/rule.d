module uim.datasources.mixins.rule;

import uim.datasources;

@safe:
string datasourceRuleThis(string name = null) {
    string fullName = name ~ "DatasourceRule";
    return objThis(fullName);
}

template DatasourceRuleThis(string name = null) {
    const char[] DatasourceRuleThis = datasourceRuleThis(name);
}

string datasourceruleCalls(string name) {
    string fullName = name ~ "DatasourceRule";
    return objCalls(fullName);
}

template DatasourceRuleCalls(string name) {
    const char[] DatasourceRuleCalls = datasourceRuleCalls(name);
}
