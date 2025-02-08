/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.mixins.logger;

import uim.logging;
@safe:

string loggerThis(string name = null) {
    string fullName = name ~ "Logger";
    return objThis(fullName);
}

template LoggerThis(string name = null) {
    const char[] LoggerThis = loggerThis(name);
}

string loggerCalls(string name) {
    string fullName = name ~ "Logger";
    return objCalls(fullName);
}

template LoggerCalls(string name) {
    const char[] LoggerCalls = loggerCalls(name);
}
