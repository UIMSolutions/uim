module uim.controllers.exceptions.exception;

import uim.controllers;

@safe:

// Used when a component cannot be found.
class ControllerException : DException {
  mixin(ExceptionThis!("ControllerException"));

  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    messageTemplate("default", "Controller exception");
  }
}
