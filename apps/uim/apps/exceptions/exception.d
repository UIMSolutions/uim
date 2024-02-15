module uim.apps.exceptions.exception;

import uim.apps;

@safe:

// App exception.
class DAppException : UimException {
  mixin(ExceptionThis!("App"));

  alias initialize = UimException.initialize;
  bool initialize(IData[string] configData = null) {
    if (!super.initialize()) { return false; }

    this
      .messageTemplate("Error in libary uim-apps");

    return true;
  }
}
mixin(ExceptionCalls!("App"));
