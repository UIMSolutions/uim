/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.mixins.statement;

import uim.databases;
@safe:

string statementThis(string name = null) {
    string fullName = name ~ "Statement";
    return objThis(fullName);
}

template StatementThis(string name = null) {
    const char[] StatementThis = statementThis(name);
}

string statementCalls(string name) {
    string fullName = name ~ "Statement";
    return objCalls(fullName);
}

template StatementCalls(string name) {
    const char[] StatementCalls = statementCalls(name);
}
