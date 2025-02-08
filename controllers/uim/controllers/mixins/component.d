/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.mixins.component;

import uim.controllers;

@safe:

string controllerComponentThis(string name = null) {
    string fullName = name ~ "ControllerComponent";
    return objThis(fullName);

}

template ControllerComponentThis(string name = null) {
    const char[] ControllerComponentThis = controllerComponentThis(name);
}

string controllerComponentCalls(string name) {
    string fullName = name ~ "ControllerComponent";
    return objCalls(fullName);
}

template ControllerComponentCalls(string name) {
    const char[] ControllerComponentCalls = controllerComponentCalls(name);
}
