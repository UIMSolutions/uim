module uim.errors.exceptions.exception;

import uim.errors;

@safe:

// Base error exception.
class DErrorsException : UimException {
  mixin(ExceptionThis!("Errors"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-errors");

    return true;
  }
}
mixin(ExceptionCalls!("Errors"));
