/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.mixins.query;

import uim.databases;
@safe:

string sqlQueryThis(string name = null) {
    string fullName = name ~ "SQLQuery";
    return objThis(fullName);
}

template SQLQueryThis(string name = null) {
    const char[] SQLQueryThis = sqlQueryThis(name);
}

string sqlQueryCalls(string name) {
    string fullName = name ~ "SQLQuery";
    return objCalls(fullName);
}

template SQLQueryCalls(string name) {
    const char[] SQLQueryCalls = sqlQueryCalls(name);
}
