/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.mixins.middleware;

import uim.http;
@safe: 

string httpMiddlewareThis(string name = null) {
    string fullName = name ~ "HTTPMiddleware";
    return objThis(fullName);
}

template HTTPMiddlewareThis(string name = null) {
    const char[] HTTPMiddlewareThis = httpMiddlewareThis(name);
}

string httpMiddlewareCalls(string name) {
    string fullName = name ~ "HTTPMiddleware";
    return objCalls(fullName);
}

template HTTPMiddlewareCalls(string name) {
    const char[] HTTPMiddlewareCalls = httpMiddlewareCalls(name);
}