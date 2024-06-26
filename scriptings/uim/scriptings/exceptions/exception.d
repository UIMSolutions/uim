module uim.scriptings.exceptions.exception;

import uim.scriptings;

@safe:

// Base Scriptings exception.
class DScriptingsException : DException {
  mixin(ExceptionThis!("Scriptings"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-scriptings");

    return true;
  }
}
mixin(ExceptionCalls!("Scriptings"));
