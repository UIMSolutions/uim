module uim.languages.exceptions.exception;

import uim.languages;

@safe:

// I18n exception.
class DLanguagesException : DException {
  mixin(ExceptionThis!("Languages"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-languages");

    return true;
  }
}
mixin(ExceptionCalls!("Languages"));
