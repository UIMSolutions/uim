module uim.i18n.exceptions.exception;

import uim.i18n;

@safe:

// I18n exception.
class DI18nException : UimException {
  mixin(ExceptionThis!("I18n"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-i18n");

    return true;
  }
}
mixin(ExceptionCalls!("I18n"));
