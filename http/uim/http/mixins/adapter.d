/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.mixins.adapter;

import uim.http;
@safe:

string adapterThis(string name = null) {
    string fullName = name ~ "Adapter";
    return objThis(fullName);
}

template AdapterThis(string name = null) {
    const char[] AdapterThis = adapterThis(name);
}

string adapterCalls(string name) {
    string fullName = name ~ "Adapter";
    return objCalls(fullName);
}

template AdapterCalls(string name) {
    const char[] AdapterCalls = adapterCalls(name);
}