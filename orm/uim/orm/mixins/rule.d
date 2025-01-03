/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.orm.mixins.rule;

import uim.orm;

@safe:

string ormRuleThis(string name = null) {
    string fullName = name ~ "ORMRule";
    return objThis(fullName);
}

template ORMRuleThis(string name = null) {
    const char[] ORMRuleThis = ormRuleThis(name);
}

string ormRuleCalls(string name) {
    string fullName = name ~ "ORMRule";
    return objCalls(fullName);
}

template ORMRuleCalls(string name) {
    const char[] ORMRuleCalls = ormRuleCalls(name);
}
