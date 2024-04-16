module uim.forms.exceptions.exception;

import uim.forms;

@safe:

// Base ORM exception.
class DORMException : UimException {
  mixin(ExceptionThis!("ORM"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-orm");

    return true;
  }
}
mixin(ExceptionCalls!("ORM"));
