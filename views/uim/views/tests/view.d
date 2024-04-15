module uim.views.tests.view;

import uim.views;

@safe:

bool testView(IView viewToTest) {
    assert(viewToTest !is null, "In testView: viewToTest is null");
    
    return true;
}