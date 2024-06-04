module uim.apps.exceptions.exception;

import uim.apps;

@safe:

// App exception.
class DAppException : DException {
  mixin(ExceptionThis!("App"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .messageTemplate("Error in libary uim-apps");

    return true;
  }
}
mixin(ExceptionCalls!("App"));
