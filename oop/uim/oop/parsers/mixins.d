/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.parsers.mixins;

import uim.oop;
@safe: 

string parserThis(string name = null) {
    string fullName = name ~ "Parser";
    return objThis(fullName);
}

template ParserThis(string name = null) {
    const char[] ParserThis = parserThis(name);
}

string parserCalls(string name) {
    string fullName = name ~ "Parser";
    return objCalls(fullName);
}

template ParserCalls(string name) {
    const char[] ParserCalls = parserCalls(name);
}