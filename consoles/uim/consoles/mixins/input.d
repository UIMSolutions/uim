/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.mixins.input;

import uim.consoles;

@safe:
string inputThis(string name = null) {
    string fullName = name ~ "Input";
    return objThis(fullName);
}

template InputThis(string name = null) {
    const char[] InputThis = inputThis(name);
}

string inputCalls(string name) {
    string fullName = name ~ "Input";
    return objCalls(fullName);
}

template InputCalls(string name) {
    const char[] InputCalls = inputCalls(name);
}
