/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.mixins.driver;

import uim.databases;
@safe:

string dbDriverThis(string name = null) {
    string fullName = name ~ "Driver";
    return objThis(fullName);
}

template DBDriverThis(string name = null) {
    const char[] DBDriverThis = dbDriverThis(name);
}

string dbDriverCalls(string name) {
    string fullName = name ~ "Driver";
    return objCalls(fullName);
}

template DBDriverCalls(string name) {
    const char[] DBDriverCalls = dbDriverCalls(name);
}
