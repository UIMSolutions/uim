module logging.uim.logging.exceptions.exception;

import uim.logging;

@safe:

// I18n exception.
class DLoggingException : UimException {
  mixin(ExceptionThis!("Logging"));

  bool initialize(IData[string] configData = null) {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-logging");

    return true;
  }
}
mixin(ExceptionCalls!("Logging"));
