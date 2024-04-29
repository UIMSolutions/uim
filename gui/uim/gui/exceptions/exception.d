module uim.gui.exceptions.exception;

import uim.gui;

@safe:

// I18n exception.
class DGuiException : UimException {
  mixin(ExceptionThis!("Gui"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-gui");

    return true;
  }
}
mixin(ExceptionCalls!("Gui"));
