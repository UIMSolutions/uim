module uim.neurals.exceptions.exception;

import uim.neurals;

@safe:

class DNeuralsException : UimException {
  mixin(ExceptionThis!("Neurals"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-neurals");

    return true;
  }
}
mixin(ExceptionCalls!("Neurals"));
