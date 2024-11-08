/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.mixins.controller;

import uim.controllers;

@safe:

string controllerThis(string name = null) {
    string fullName = name ~ "Controller";
    return objThis(fullName);

}

template ControllerThis(string name = null) {
    const char[] ControllerThis = controllerThis(name);
}

string controllerCalls(string name) {
    string fullName = name ~ "Controller";
    return objCalls(fullName);
}

template ControllerCalls(string name) {
    const char[] ControllerCalls = controllerCalls(name);
}
