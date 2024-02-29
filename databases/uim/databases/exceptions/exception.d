module uim.databases.exceptions.exception;

import uim.databases;

@safe:

// Database exception.
class DDatabaseException : UimException {
  mixin(ExceptionThis!("Database"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .messageTemplate("Error in libary uim-databases");

    return true;
  }
}
mixin(ExceptionCalls!("Database"));
