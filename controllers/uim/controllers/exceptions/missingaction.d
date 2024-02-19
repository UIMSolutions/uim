module uim.controllers.exceptions.missingaction;

import uim.controllers;

@safe:

// Missing Action exception - used when a controller action
// cannot be found, or when the controller`s isAction() method returns false.
class MissingActionException : ControllerException {
  mixin(ExceptionThis!("MissingActionException"));

  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    messageTemplate("default", "Action `%s.%s()` could not be found, or is not accessible.");
  }
}
