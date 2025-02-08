/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.css.mixins.css;

import uim.css;
@safe:

string cssThis(string name = null) {
    string fullName = name ~ "Css";
    return objThis(fullName);
}

template CssThis(string name = null) {
    const char[] CssThis = cssThis(name);
}

string cssCalls(string name) {
    string fullName = name ~ "Css";
    return objCalls(fullName);
}

template CssCalls(string name) {
    const char[] CssCalls = cssCalls(name);
}
