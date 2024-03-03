module uim.http.exceptions.exception;

import uim.http;

@safe:

// I18n exception.
class DHttpException : UimException {
  mixin(ExceptionThis!("Http"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-http");

    return true;
  }
}

mixin(ExceptionCalls!("Http"));
