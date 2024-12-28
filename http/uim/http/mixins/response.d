/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.mixins.response;

import uim.http;
@safe:

string httpResponseThis(string name = null) {
    string fullName = name ~ "HTTPResponse";
    return objThis(fullName);
}

template HTTPResponseThis(string name = null) {
    const char[] HTTPResponseThis = httpResponseThis(name);
}

string httpResponseCalls(string name) {
    string fullName = name ~ "HTTPResponse";
    return objCalls(fullName);
}

template HTTPResponseCalls(string name) {
    const char[] HTTPResponseCalls = httpResponseCalls(name);
}
