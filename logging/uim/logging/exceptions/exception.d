module uim.logging.exceptions.exception;

import uim.logging;

@safe:

// Logging exception.
class DLoggingException : DException {
  mixin(ExceptionThis!("Logging"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .messageTemplate("Error in libary uim-logging");

    return true;
  }
}
mixin(ExceptionCalls!("Logging"));
