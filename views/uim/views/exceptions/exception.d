module uim.views.exceptions.exception;

import uim.views;

@safe:

// I18n exception.
class DViewException : UimException {
  mixin(ExceptionThis!("View"));

  alias initialize = UimException.initialize;
  bool initialize(IData[string] configData = null) {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-views");

    return true;
  }
}
mixin(ExceptionCalls!("View"));
