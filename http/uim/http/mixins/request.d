/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.mixins.request;

import uim.http;
@safe:

string requestThis(string name = null) {
    string fullName = name ~ "Request";
    return objThis(fullName);
}

template RequestThis(string name = null) {
    const char[] RequestThis = requestThis(name);
}

string requestCalls(string name) {
    string fullName = name ~ "Request";
    return objCalls(fullName);
}

template RequestCalls(string name) {
    const char[] RequestCalls = requestCalls(name);
}
