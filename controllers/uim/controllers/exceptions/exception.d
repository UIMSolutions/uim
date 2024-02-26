module uim.controllers.exceptions.exception;

import uim.controllers;

@safe:

// Controller exception.
class DControllersException : UimException {
  mixin(ExceptionThis!("Controllers"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .messageTemplate("Error in libary uim-controllers");

    return true;
  }
}
mixin(ExceptionCalls!("Controllers"));
