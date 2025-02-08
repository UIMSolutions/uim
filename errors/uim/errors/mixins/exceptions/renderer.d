/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.mixins.exceptions.renderer;

import uim.errors;

@safe:
string exceptionRendererThis(string name = null) {
    string fullName = name ~ "ExceptionRenderer";
    return objThis(fullName);
}

template ExceptionRendererThis(string name = null) {
    const char[] ExceptionRendererThis = exceptionRendererThis(name);
}

string exceptionRendererCalls(string name) {
    string fullName = name ~ "ExceptionRenderer";
    return objCalls(fullName);
}

template ExceptionRendererCalls(string name) {
    const char[] ExceptionRendererCalls = exceptionRendererCalls(name);
}
