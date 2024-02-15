module uim.gui.exceptions.exception;

import uim.gui;

@safe:

// I18n exception.
class DFSException : UimException {
  mixin(ExceptionThis!("View"));

  override bool initialize() {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-gui");

    return true;
  }
}
mixin(ExceptionCalls!("View"));
