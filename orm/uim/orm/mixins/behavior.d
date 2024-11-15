/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module orm.uim.orm.mixins.behavior;

import uim.orm;

@safe:

string behaviorThis(string name = null) {
    string fullName = name ~ "Behavior";
    return objThis(fullName);
}

template BehaviorThis(string name = null) {
    const char[] BehaviorThis = behaviorThis(name);
}

string behaviorCalls(string name) {
    string fullName = name ~ "Behavior";
    return objCalls(fullName);
}

template BehaviorCalls(string name) {
    const char[] BehaviorCalls = behaviorCalls(name);
}
