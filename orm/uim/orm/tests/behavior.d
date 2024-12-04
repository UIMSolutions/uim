module uim.orm.tests.behavior;

import uim.orm;

@safe:

bool testBehavior(IORMBehavior behavior) {
    assert(behavior !is null, "testBehavior: behavior is null");
    
    return true;
}