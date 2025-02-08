/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.mixins.driver;

import uim.databases;
@safe:

string driverThis(string name = null) {
    string fullName = name ~ "Driver";
    return objThis(fullName);
}

template DriverThis(string name = null) {
    const char[] DriverThis = driverThis(name);
}

string driverCalls(string name) {
    string fullName = name ~ "Driver";
    return objCalls(fullName);
}

template DriverCalls(string name) {
    const char[] DriverCalls = driverCalls(name);
}
