module uim.routings.exceptions.exception;

import uim.routings;

@safe:

// Base Routings exception.
class DRoutingsException : UimException {
  mixin(ExceptionThis!("Routings"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-routings");

    return true;
  }
}
mixin(ExceptionCalls!("Routings"));
