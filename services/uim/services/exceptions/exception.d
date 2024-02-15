module uim.services.exceptions.exception;

import uim.services;

@safe:

// I18n exception.
class DFSException : UimException {
  mixin(ExceptionThis!("ViewException"));

  override bool initialize() {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-services");

    return true;
  }
}
mixin(ExceptionCalls!("ViewException"));
