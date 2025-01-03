/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.mixins.catalog;

import uim.i18n;
@safe:

string messageCatalogThis(string name = null) {
    string fullName = name ~ "MessageCatalog";
    return objThis(fullName);
}

template MessageCatalogThis(string name = null) {
    const char[] MessageCatalogThis = messageCatalogThis(name);
}

string messageCatalogCalls(string name) {
    string fullName = name ~ "MessageCatalog";
    return objCalls(fullName);
}

template MessageCatalogCalls(string name) {
    const char[] MessageCatalogCalls = messageCatalogCalls(name);
}