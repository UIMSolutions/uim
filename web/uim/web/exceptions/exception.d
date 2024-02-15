module uim.web.exceptions.exception;

import uim.web;

@safe:

// Web exception.
class DWebException : UimException {
  mixin(ExceptionThis!("Web"));

  alias initialize = UimException.initialize;
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize()) {
        return false;
    }

    this
      .messageTemplate("Error in libary uim-web");

    return true;
  }
}
mixin(ExceptionCalls!("Web"));
