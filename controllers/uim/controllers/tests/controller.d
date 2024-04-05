module uim.controllers.tests.controller;

import uim.controllers; 

@safe:

bool testController(IController controllerToTest) {
    assert(controllerToTest !is null, "In testController: controllerToTest is null");
    
    return true;
}