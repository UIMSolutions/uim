module uim.views.tests.widget;

import uim.views;

@safe:

bool testWidget(IWidget widgetToTest) {
    assert(widgetToTest !is null, "In testWidget: widgetToTest is null");
    
    return true;
}