module uim.controllers.exceptions.exception;

import uim.controllers;

@safe:

// Controller exception.
class DControllerException : UimException {
  mixin(ExceptionThis!("Controller"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .messageTemplate("Error in libary uim-controllers");

    return true;
  }
}
mixin(ExceptionCalls!("Controller"));
