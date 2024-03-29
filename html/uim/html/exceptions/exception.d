module uim.html.exceptions.exception;

import uim.html;

@safe:

// I18n exception.
class DHtmlException : UimException {
  mixin(ExceptionThis!("Html"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-html");

    return true;
  }
}
mixin(ExceptionCalls!("Html"));
