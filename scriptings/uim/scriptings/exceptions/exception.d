module uim.scriptings.exceptions.exception;

import uim.scriptings;

@safe:

// Base Scriptings exception.
class DScriptingsException : UimException {
  mixin(ExceptionThis!("Scriptings"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-scriptings");

    return true;
  }
}
mixin(ExceptionCalls!("Scriptings"));
