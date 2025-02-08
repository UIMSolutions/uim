/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.services.mixins.service;

import uim.services;

@safe:

string serviceThis(string name = null) {
    string fullName = name ~ "Service";
    return objThis(fullName);
}

template ServiceThis(string name = null) {
    const char[] ServiceThis = serviceThis(name);
}

string serviceCalls(string name) {
    string fullName = name ~ "Service";
    return objCalls(fullName);
}

template ServiceCalls(string name) {
    const char[] ServiceCalls = serviceCalls(name);
}