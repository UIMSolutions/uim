module uim.controllers.tests.controller;

import uim.controllers; 

@safe:

bool testController(IController controllerToTest) {
    assert(!controllerToTest.isNull, "In testController: controllerToTest is null");
    
    return true;
}