module uim.mvc.interfaces.controller;

import uim.mvc;

@safe: 
interface IController {
    string process(HTTPServerRequest request, HTTPServerResponse response);
}

