module uim.apps.exceptions.exception;

import uim.apps;

@safe:

// App exception.
class DAppException : UimException {
  mixin(ExceptionThis!("App"));

  override bool initialize() {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-apps");

    return true;
  }
}
mixin(ExceptionCalls!("App"));
