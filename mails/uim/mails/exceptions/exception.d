module uim.mails.exceptions.exception;

import uim.mails;

@safe:

// Base Mails exception.
class DMailsException : UimException {
  mixin(ExceptionThis!("Mails"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-mails");

    return true;
  }
}
mixin(ExceptionCalls!("Mails"));
