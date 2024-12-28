/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.mixins.client;

import uim.http;
@safe:

string httpClientThis(string name = null) {
    string fullName = name ~ "HTTPClient";
    return objThis(fullName);
}

template HTTPClientThis(string name = null) {
    const char[] HTTPClientThis = httpClientThis(name);
}

string httpClientCalls(string name) {
    string fullName = name ~ "HTTPClient";
    return objCalls(fullName);
}

template HTTPClientCalls(string name) {
    const char[] HTTPClientCalls = httpClientCalls(name);
}
