module uim.apps.exceptions.exception;

import uim.apps;

@safe:

// App exception.
class DAppException : UimException {
  mixin(ExceptionThis!("App"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .messageTemplate("Error in libary uim-apps");

    return true;
  }
}
mixin(ExceptionCalls!("App"));
