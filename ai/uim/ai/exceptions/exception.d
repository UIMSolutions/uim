module uim.ai.exceptions.exception;

import uim.ai;

@safe:

// Base AI exception.
class DAIException : UimException {
  mixin(ExceptionThis!("AI"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-ai");

    return true;
  }
}
mixin(ExceptionCalls!("AI"));
