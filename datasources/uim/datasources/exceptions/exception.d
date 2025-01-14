module uim.datasources.exceptions.exception;

import uim.datasources;

@safe:

// Datasource exception.
class DDatasourcesException : UIMException {
  mixin(ExceptionThis!("Datasources"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .messageTemplate("Error in libary uim-datasources");

    return true;
  }
}
mixin(ExceptionCalls!("Datasources"));
