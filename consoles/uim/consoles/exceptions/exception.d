module uim.consoles.exceptions.exception;

import uim.consoles;

@safe:

// I18n exception.
class DControllerException : UimException {
  mixin(ExceptionThis!("ControllerException"));

  override bool initialize() {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-consoles");

    return true;
  }
}
mixin(ExceptionCalls!("ControllerException"));
