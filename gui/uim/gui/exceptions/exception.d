module uim.gui.exceptions.exception;

import uim.gui;

@safe:

// I18n exception.
class DGuiException : UimException {
  mixin(ExceptionThis!("Gui"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-gui");

    return true;
  }
}
mixin(ExceptionCalls!("Gui"));
