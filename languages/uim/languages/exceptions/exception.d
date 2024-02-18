module uim.consoles.exceptions.exception;

import uim.consoles;

@safe:

// I18n exception.
class DControllerException : UimException {
  mixin(ExceptionThis!("Controller"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-consoles");

    return true;
  }
}
mixin(ExceptionCalls!("Controller"));
