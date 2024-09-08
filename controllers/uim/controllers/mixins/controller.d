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
