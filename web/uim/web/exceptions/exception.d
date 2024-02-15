module uim.web.exceptions.exception;

import uim.web;

@safe:

// Web exception.
class DWebException : UimException {
  mixin(ExceptionThis!("Web"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
        return false;
    }

    this
      .messageTemplate("Error in libary uim-web");

    return true;
  }
}
mixin(ExceptionCalls!("Web"));
