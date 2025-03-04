module uim.controllers.classes.controllers.error;

import uim.controllers;

@safe:

/**
 * Error Handling Controller
 * Controller used by ErrorHandler to render error views.
 */
class DErrorController : DController {
    mixin(ControllerThis!("Error"));
}