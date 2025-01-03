/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.mixins.helper;

import uim.views;
@safe: 

string helperThis(string name = null) {
    string fullName = name ~ "Helper";
    return objThis(fullName);
}

template HelperThis(string name = null) {
    const char[] HelperThis = helperThis(name);
}

string helperCalls(string name) {
    string fullName = name ~ "Helper";
    return objCalls(fullName);
}

template HelperCalls(string name) {
    const char[] HelperCalls = helperCalls(name);
}