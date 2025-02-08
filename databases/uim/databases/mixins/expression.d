/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.mixins.expression;

import uim.databases;
@safe:

string expressionThis(string name = null) {
    string fullName = name ~ "Expression";
    return objThis(fullName);
}

template ExpressionThis(string name = null) {
    const char[] ExpressionThis = expressionThis(name);
}

string expressionCalls(string name) {
    string fullName = name ~ "Expression";
    return objCalls(fullName);
}

template ExpressionCalls(string name) {
    const char[] ExpressionCalls = expressionCalls(name);
}
