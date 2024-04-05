module uim.orm.tests.rule;

import uim.orm;

@safe:

bool testRule(IRule ruleToTest) {
    assert(!ruleToTest.isNull, "In testRule: ruleToTest is null");
    
    return true;
}