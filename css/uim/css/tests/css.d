module uim.css.tests.css;

import uim.css;

@safe:

bool testCss(ICss cssToTest) {
    assert(!cssToTest.isNull, "In testCss: cssToTest is null");
    
    return true;
}