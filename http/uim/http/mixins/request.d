/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.mixins.request;

import uim.http;
@safe:

string httpRequestThis(string name = null) {
    string fullName = name ~ "HTTPRequest";
    return objThis(fullName);
}

template HTTPRequestThis(string name = null) {
    const char[] HTTPRequestThis = httpRequestThis(name);
}

string httpRequestCalls(string name) {
    string fullName = name ~ "HTTPRequest";
    return objCalls(fullName);
}

template HTTPRequestCalls(string name) {
    const char[] HTTPRequestCalls = httpRequestCalls(name);
}
