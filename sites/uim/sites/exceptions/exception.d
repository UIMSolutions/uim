module uim.sites.uim.sites.exceptions.exception;

import uim.orm;

@safe:

// Base ORM exception.
class DORMException : UimException {
  mixin(ExceptionThis!("ORM"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-orm");

    return true;
  }
}
mixin(ExceptionCalls!("ORM"));
