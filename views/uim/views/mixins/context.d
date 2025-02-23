/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.mixins.context;

import uim.views;
@safe: 

string contextThis(string name = null) {
    string fullName = name ~ "Context";
    return objThis(fullName);
}

template ContextThis(string name = null) {
    const char[] ContextThis = contextThis(name);
}

string contextCalls(string name) {
    string fullName = name ~ "Context";
    return objCalls(fullName);
}

template ContextCalls(string name) {
    const char[] ContextCalls = contextCalls(name);
}