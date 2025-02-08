/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.mixins.formatter;

import uim.logging;

@safe:

string logFormatterThis(string name = null) {
    string fullName = name ~ "LogFormatter";
    return objThis(fullName);
}

template LogFormatterThis(string name = null) {
    const char[] LogFormatterThis = logFormatterThis(name);
}

string logFormatterCalls(string name) {
    string fullName = name ~ "LogFormatter";
    return objCalls(fullName);
}

template LogFormatterCalls(string name) {
    const char[] LogFormatterCalls = logFormatterCalls(name);
}
