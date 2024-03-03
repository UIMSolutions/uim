module uim.validations.exceptions.exception;

import uim.validations;

@safe:

// Base Validations exception.
class DValidationsException : UimException {
  mixin(ExceptionThis!("Validations"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-validations");

    return true;
  }
}
mixin(ExceptionCalls!("Validations"));
