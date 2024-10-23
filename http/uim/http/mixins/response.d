/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.mixins.response;

import uim.http;
@safe:

string responseThis(string name = null) {
    string fullName = name ~ "Response";
    return objThis(fullName);
}

template ResponseThis(string name = null) {
    const char[] ResponseThis = responseThis(name);
}

string responseCalls(string name) {
    string fullName = name ~ "Response";
    return objCalls(fullName);
}

template ResponseCalls(string name) {
    const char[] ResponseCalls = responseCalls(name);
}