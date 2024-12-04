module uim.orm.tests.rule;

import uim.orm;

@safe:

bool testRule(IRule rule) {
    assert(rule !is null, "In testRule: rule is null");
    
    return true;
}