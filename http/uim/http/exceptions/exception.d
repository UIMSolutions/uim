module views copy.uim.views.exceptions.exception;

import uim.views;

@safe:

// I18n exception.
class DFSException : UimException {
  mixin(ExceptionThis!("View"));

  override bool initialize() {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-views");

    return true;
  }
}
mixin(ExceptionCalls!("View"));
