/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.mixins.templater;

import uim.views;
@safe: 

string templaterThis(string name = null) {
    string fullName = name ~ "Templater";
    return objThis(fullName);
}

template TemplaterThis(string name = null) {
    const char[] TemplaterThis = templaterThis(name);
}

string templaterCalls(string name) {
    string fullName = name ~ "Templater";
    return objCalls(fullName);
}

template TemplaterCalls(string name) {
    const char[] TemplaterCalls = templaterCalls(name);
}
