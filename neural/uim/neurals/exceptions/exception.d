module uim.neurals.exceptions.exception;

import uim.neurals;

@safe:

class DNeuralsException : UimException {
  mixin(ExceptionThis!("Neurals"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-neurals");

    return true;
  }
}
mixin(ExceptionCalls!("Neurals"));
