module uim.validations.exceptions.exception;

import uim.validations;

@safe:

// Base Validations exception.
class DValidationsException : UimException {
  mixin(ExceptionThis!("Validations"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-validations");

    return true;
  }
}
mixin(ExceptionCalls!("Validations"));
