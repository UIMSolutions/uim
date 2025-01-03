/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.mixins.loader;

import uim.i18n;

@safe:

string loaderThis(string name = null) {
    string fullName = name ~ "Loader";
    return objThis(fullName);
}

template LoaderThis(string name = null) {
    const char[] LoaderThis = loaderThis(name);
}

string loaderCalls(string name) {
    string fullName = name ~ "Loader";
    return objCalls(fullName);
}

template LoaderCalls(string name) {
    const char[] LoaderCalls = loaderCalls(name);
}
