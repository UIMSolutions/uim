module uim.controllers.interfaces.check;

import uim.controllers;
@safe:

interface IControllerCheck {
    bool run(IController controller, Json[string] options = null);
}