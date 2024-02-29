module uim.securities.exceptions.exception;

import uim.securities;

@safe:

// Base Securities exception.
class DSecuritiesException : UimException {
  mixin(ExceptionThis!("Securities"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-securities");

    return true;
  }
}
mixin(ExceptionCalls!("Securities"));
