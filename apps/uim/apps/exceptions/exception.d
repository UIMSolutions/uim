module apps.uim.apps.exceptions.exception;

import uim.apps;

@safe:

// I18n exception.
class DAppException : UimException {
  mixin(ExceptionThis!("AppException"));

  override bool initialize() {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-apps");

    return true;
  }
}
mixin(ExceptionCalls!("AppException"));
