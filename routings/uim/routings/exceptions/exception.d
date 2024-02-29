module uim.routings.exceptions.exception;

import uim.routings;

@safe:

// Base Routings exception.
class DRoutingsException : UimException {
  mixin(ExceptionThis!("Routings"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-routings");

    return true;
  }
}
mixin(ExceptionCalls!("Routings"));
