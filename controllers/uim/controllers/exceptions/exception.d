module uim.controllers.exceptions.exception;

import uim.controllers;

@safe:

// Controller exception.
class DControllersException : UimException {
  mixin(ExceptionThis!("Controllers"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .messageTemplate("Error in libary uim-controllers");

    return true;
  }
}
mixin(ExceptionCalls!("Controllers"));
