module uim.datasources.classes.rules.rule;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

class DDatasourceRule : UIMObject, IDatasourceRule {
    mixin(DatasourceRuleThis!());
}

unittest {
    // TODO
}