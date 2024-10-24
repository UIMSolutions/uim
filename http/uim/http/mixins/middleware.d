/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.mixins.middleware;

import uim.http;
@safe: 

string middlewareThis(string name = null) {
    string fullName = name ~ "Middleware";
    return objThis(fullName);
}

template MiddlewareThis(string name = null) {
    const char[] MiddlewareThis = middlewareThis(name);
}

string middlewareCalls(string name) {
    string fullName = name ~ "Middleware";
    return objCalls(fullName);
}

template MiddlewareCalls(string name) {
    const char[] MiddlewareCalls = middlewareCalls(name);
}