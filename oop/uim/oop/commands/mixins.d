/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.commands.mixins;

import uim.oop;
@safe: 

string commandThis(string name = null) {
    string fullName = name ~ "Command";
    return objThis(fullName);
}

template CommandThis(string name = null) {
    const char[] CommandThis = commandThis(name);
}

string commandCalls(string name) {
    string fullName = name ~ "Command";
    return objCalls(fullName);
}

template CommandCalls(string name) {
    const char[] CommandCalls = commandCalls(name);
}