/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.mixins.node;

string errorNodeThis(string name = null) {
    string fullName = name ~ "ErrorNode";
    return objThis(fullName);
}

template ErrorNodeThis(string name = null) {
    const char[] ErrorNodeThis = errorNodeThis(name);
}

string errorCalls(string name) {
    string fullName = name ~ "ErrorNode";
    return objCalls(fullName);
}

template ErrorCalls(string name) {
    const char[] ErrorCalls = errorCalls(name);
}
