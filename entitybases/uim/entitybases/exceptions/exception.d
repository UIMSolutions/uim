module uim.entitybases.exceptions.exception;

import uim.entitybases;

@safe:

// Datasource exception.
class DEntitybasesException : UimException {
  mixin(ExceptionThis!("Entitybases"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .messageTemplate("Error in libary uim-entitybases");

    return true;
  }
}
mixin(ExceptionCalls!("Entitybases"));