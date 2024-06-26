module uim.validations.exceptions.exception;

import uim.validations;

@safe:

// Base Validations exception.
class DValidationsException : DException {
  mixin(ExceptionThis!("Validations"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-validations");

    return true;
  }
}
mixin(ExceptionCalls!("Validations"));
