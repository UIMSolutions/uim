module uim.mvc.interfaces.controller;

import uim.mvc;

@safe: 
interface IController {
    void process(HTTPServerRequest request, HTTPServerResponse response);
}

