module uim.orm.tests.locator;

import uim.orm;

@safe:

bool testLocator(IORMLocator locator) {
    assert(locator !is null, "In testLocator: locator is null");
    
    return true;
}