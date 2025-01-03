/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.mixins.output;

import uim.consoles;

@safe:
string outputThis(string name = null) {
    string fullName = name ~ "Output";
    return objThis(fullName);
}

template OutputThis(string name = null) {
    const char[] OutputThis = outputThis(name);
}

string outputCalls(string name) {
    string fullName = name ~ "Output";
    return objCalls(fullName);
}

template OutputCalls(string name) {
    const char[] OutputCalls = outputCalls(name);
}
