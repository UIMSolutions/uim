/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.orm.mixins.query;

import uim.orm;

@safe:

string ormQueryThis(string name = null) {
    string fullName = name ~ "ORMQuery";
    return objThis(fullName);
}

template ORMQueryThis(string name = null) {
    const char[] ORMQueryThis = ormQueryThis(name);
}

string ormQueryCalls(string name) {
    string fullName = name ~ "ORMQuery";
    return objCalls(fullName);
}

template ORMQueryCalls(string name) {
    const char[] ORMQueryCalls = ormQueryCalls(name);
}
