/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.mixins.middleware;

import uim.i18n;

@safe:

string i18nMiddlewareThis(string name = null) {
    string fullName = name ~ "I18NMiddleware";
    return objThis(fullName);
}

template I18NMiddlewareThis(string name = null) {
    const char[] I18NMiddlewareThis = i18nMiddlewareThis(name);
}

string i18nMiddlewareCalls(string name) {
    string fullName = name ~ "I18NMiddleware";
    return objCalls(fullName);
}

template I18NMiddlewareCalls(string name) {
    const char[] I18NMiddlewareCalls = i18nMiddlewareCalls(name);
}
