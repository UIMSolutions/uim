module logging.uim.logging.exceptions.exception;

import uim.logging;

@safe:

// I18n exception.
class DFSException : UimException {
  mixin(ExceptionThis!("ViewException"));

  override bool initialize() {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-logging");

    return true;
  }
}
mixin(ExceptionCalls!("ViewException"));
