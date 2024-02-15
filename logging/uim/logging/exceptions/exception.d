module uim.logging.exceptions.exception;

import uim.logging;

@safe:

// Logging exception.
class DLoggingException : UimException {
  mixin(ExceptionThis!("Logging"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .messageTemplate("Error in libary uim-logging");

    return true;
  }
}
mixin(ExceptionCalls!("Logging"));
