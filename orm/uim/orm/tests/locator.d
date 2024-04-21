module uim.orm.tests.locator;

import uim.orm;

@safe:

bool testLocator(ILocator locatorToTest) {
    assert(locatorToTest !is null, "In testLocator: locatorToTest is null");
    
    return true;
}