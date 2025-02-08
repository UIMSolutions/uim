/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.orm.mixins.resultset;

import uim.orm;

@safe:

string ormResultsetThis(string name = null) {
    string fullName = name ~ "ORMResultset";
    return objThis(fullName);
}

template ORMResultsetThis(string name = null) {
    const char[] ORMResultsetThis = ormResultsetThis(name);
}

string ormResultsetCalls(string name) {
    string fullName = name ~ "ORMResultset";
    return objCalls(fullName);
}

template ORMResultsetCalls(string name) {
    const char[] ORMResultsetCalls = ormResultsetCalls(name);
}
