module uim.css.tests.css;

import uim.css;

@safe:

bool testCss(ICss cssToTest) {
    assert(cssToTest !is null, "In testCss: cssToTest is null");
    
    return true;
}