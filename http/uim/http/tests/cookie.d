module uim.http.tests.cookie;

import uim.http;

@safe:

bool testCookie(ICookie cookieToTest) {
    assert(!cookieToTest.isNull, "In testCookie: cookieToTest is null");
    
    return true;
}