/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.orm.mixins.behavior;

import uim.orm;

@safe:

string ormBehaviorThis(string name = null) {
    string fullName = name ~ "ORMBehavior";
    return objThis(fullName);
}

template ORMBehaviorThis(string name = null) {
    const char[] ORMBehaviorThis = ormBehaviorThis(name);
}

string ormBehaviorCalls(string name) {
    string fullName = name ~ "ORMBehavior";
    return objCalls(fullName);
}

template ORMBehaviorCalls(string name) {
    const char[] ORMBehaviorCalls = ormBehaviorCalls(name);
}
