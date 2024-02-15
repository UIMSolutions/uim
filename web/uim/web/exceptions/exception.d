module uim.web.exceptions.exception;

import uim.web;

@safe:

// I18n exception.
class DFSException : UimException {
  mixin(ExceptionThis!("View"));

  override bool initialize() {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-web");

    return true;
  }
}
mixin(ExceptionCalls!("View"));
