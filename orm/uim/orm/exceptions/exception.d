module uim.orm.exceptions.exception;

import uim.orm;

@safe:

// Base ORM exception.
class DORMException : DException {
  mixin(ExceptionThis!("ORM"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-orm");

    return true;
  }
}
mixin(ExceptionCalls!("ORM"));
