module uim.views.tests.context;

import uim.views;

@safe:

bool testFormContext(IContext formContextToTest) {
    assert(formContextToTest !is null, "In testFormContext: formContextToTest is null");
    
    return true;
}