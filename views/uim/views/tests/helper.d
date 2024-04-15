module uim.views.tests.helper;

import uim.views;

@safe:

bool testHelper(IFormHelper helperToTest) {
    assert(helperToTest !is null, "In testHelper: helperToTest is null");
    
    return true;
}