/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.mixins.catalog;

import uim.i18n;
@safe:

string catalogThis(string name = null) {
    string fullName = name ~ "Catalog";
    return objThis(fullName);
}

template CatalogThis(string name = null) {
    const char[] CatalogThis = catalogThis(name);
}

string catalogCalls(string name) {
    string fullName = name ~ "Catalog";
    return objCalls(fullName);
}

template CatalogCalls(string name) {
    const char[] CatalogCalls = catalogCalls(name);
}