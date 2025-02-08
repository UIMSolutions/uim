/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.mixins.model;

import uim.models;
@safe:

string modelThis(string name = null) {
    string fullName = name ~ "Model";
    return objThis(fullName);
}

template ModelThis(string name = null) {
    const char[] ModelThis = modelThis(name);
}

string modelCalls(string name) {
    string fullName = name ~ "Model";
    return objCalls(fullName);
}

template ModelCalls(string name) {
    const char[] ModelCalls = modelCalls(name);
}
