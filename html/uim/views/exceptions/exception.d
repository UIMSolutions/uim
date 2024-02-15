module html.uim.html.exceptions.exception;

import uim.html;

@safe:

// I18n exception.
class DFSException : UimException {
  mixin(ExceptionThis!("ViewException"));

  override bool initialize() {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-html");

    return true;
  }
}
mixin(ExceptionCalls!("ViewException"));
