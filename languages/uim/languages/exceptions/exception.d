module uim.languages.exceptions.exception;

import uim.languages;

@safe:

// I18n exception.
class DLanguagesException : UimException {
  mixin(ExceptionThis!("Languages"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-languages");

    return true;
  }
}
mixin(ExceptionCalls!("Languages"));
