module uim.http.exceptions.exception;

import uim.http;

@safe:

// I18n exception.
class DFSException : UimException {
  mixin(ExceptionThis!("View"));

  override bool initialize() {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-http");

    return true;
  }
}
mixin(ExceptionCalls!("View"));
