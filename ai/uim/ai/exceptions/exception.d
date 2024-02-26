module uim.ai.exceptions.exception;

import uim.ai;

@safe:

// Base AI exception.
class DAIException : UimException {
  mixin(ExceptionThis!("AI"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-ai");

    return true;
  }
}
mixin(ExceptionCalls!("AI"));
