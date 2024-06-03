module uim.databases.exceptions.exception;

import uim.databases;

@safe:

// Database exception.
class DDatabaseException : DException {
  mixin(ExceptionThis!("Database"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .messageTemplate("Error in libary uim-databases");

    return true;
  }
}
mixin(ExceptionCalls!("Database"));
