module uim.orm.tests.rule;

import uim.orm;

@safe:

bool testRule(IRule ruleToTest) {
    assert(ruleToTest !is null, "In testRule: ruleToTest is null");
    
    return true;
}