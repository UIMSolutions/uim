/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.mixins.cookie;

import uim.http;
@safe:

string cookieThis(string name = null) {
    string fullName = name ~ "Cookie";
    return objThis(fullName);
}

template CookieThis(string name = null) {
    const char[] CookieThis = cookieThis(name);
}

string cookieCalls(string name) {
    string fullName = name ~ "Cookie";
    return objCalls(fullName);
}

template CookieCalls(string name) {
    const char[] CookieCalls = cookieCalls(name);
}
