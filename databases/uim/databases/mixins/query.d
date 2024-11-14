/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module databases.uim.databases.mixins.query;

import uim.databases;
@safe:

string sqlqueryThis(string name = null) {
    string fullName = name ~ "SQLQuery";
    return objThis(fullName);
}

template SQLQueryThis(string name = null) {
    const char[] SQLQueryThis = sqlqueryThis(name);
}

string sqlqueryCalls(string name) {
    string fullName = name ~ "SQLQuery";
    return objCalls(fullName);
}

template SQLQueryCalls(string name) {
    const char[] SQLQueryCalls = sqlqueryCalls(name);
}
