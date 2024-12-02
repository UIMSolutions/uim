module uim.controllers.classes.controllers.controller;

import uim.controllers;

@safe:
class DController : UIMObject, IController {
    mixin(ControllerThis!());

    void process(HTTPServerRequest request, HTTPServerResponse response) {
    }
}
