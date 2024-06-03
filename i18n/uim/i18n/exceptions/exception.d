module uim.i18n.exceptions.exception;

import uim.i18n;

@safe:

// I18n exception.
class DI18nException : DException {
  mixin(ExceptionThis!("I18n"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-i18n");

    return true;
  }
}
mixin(ExceptionCalls!("I18n"));
