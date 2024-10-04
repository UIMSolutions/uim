/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.mixins.console;

import uim.consoles;

@safe:
string consoleThis(string name = null) {
    string fullName = name ~ "Console";
    return objThis(fullName);
}

template ConsoleThis(string name = null) {
    const char[] ConsoleThis = consoleThis(name);
}

string consoleCalls(string name) {
    string fullName = name ~ "Console";
    return objCalls(fullName);
}

template ConsoleCalls(string name) {
    const char[] ConsoleCalls = consoleCalls(name);
}
