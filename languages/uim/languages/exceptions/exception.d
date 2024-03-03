module uim.languages.exceptions.exception;

import uim.languages;

@safe:

// I18n exception.
class DLanguagesException : UimException {
  mixin(ExceptionThis!("Languages"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-languages");

    return true;
  }
}
mixin(ExceptionCalls!("Languages"));
