module uim.views.tests.context;

import uim.views;

@safe:

bool testFormContext(IFormContext formContextToTest) {
    assert(formContextToTest !is null, "In testFormContext: formContextToTest is null");
    
    return true;
}