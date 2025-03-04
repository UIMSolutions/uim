/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.orm.mixins.table;

import uim.orm;

@safe:

string ormTableThis(string name = null) {
    string fullName = name ~ "ORMTable";
    return objThis(fullName);
}

template ORMTableThis(string name = null) {
    const char[] ORMTableThis = ormTableThis(name);
}

string ormTableCalls(string name) {
    string fullName = name ~ "ORMTable";
    return objCalls(fullName);
}

template ORMTableCalls(string name) {
    const char[] ORMTableCalls = ormTableCalls(name);
}
