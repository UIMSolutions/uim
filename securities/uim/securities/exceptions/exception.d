module uim.securities.exceptions.exception;

import uim.securities;

@safe:

// Base Securities exception.
class DSecuritiesException : DException {
  mixin(ExceptionThis!("Securities"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-securities");

    return true;
  }
}
mixin(ExceptionCalls!("Securities"));
