/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.mixins.session;

import uim.http;
@safe:

string sessionThis(string name = null) {
    string fullName = name ~ "Session";
    return objThis(fullName);
}

template SessionThis(string name = null) {
    const char[] SessionThis = sessionThis(name);
}

string sessionCalls(string name) {
    string fullName = name ~ "Session";
    return objCalls(fullName);
}

template SessionCalls(string name) {
    const char[] SessionCalls = sessionCalls(name);
}