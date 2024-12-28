/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.mixins.adapter;

import uim.http;
@safe:

string httpAdapterThis(string name = null) {
    string fullName = name ~ "HTTPAdapter";
    return objThis(fullName);
}

template HTTPAdapterThis(string name = null) {
    const char[] HTTPAdapterThis = httpAdapterThis(name);
}

string httpAdapterCalls(string name) {
    string fullName = name ~ "HTTPAdapter";
    return objCalls(fullName);
}

template HTTPAdapterCalls(string name) {
    const char[] HTTPAdapterCalls = httpAdapterCalls(name);
}
