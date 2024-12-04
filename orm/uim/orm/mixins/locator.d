/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.orm.mixins.locator;

import uim.orm;

@safe:

string ormLocatorThis(string name = null) {
    string fullName = name ~ "ORMLocator";
    return objThis(fullName);
}

template ORMLocatorThis(string name = null) {
    const char[] ORMLocatorThis = ormLocatorThis(name);
}

string ormLocatorCalls(string name) {
    string fullName = name ~ "ORMLocator";
    return objCalls(fullName);
}

template ORMLocatorCalls(string name) {
    const char[] ORMLocatorCalls = ormLocatorCalls(name);
}
