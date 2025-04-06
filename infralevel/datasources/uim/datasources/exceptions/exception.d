module uim.datasources.exceptions.exception;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

// Datasource exception.
class DDatasourcesException : DException {
  mixin(ExceptionThis!("Datasources"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .messageTemplate("Error in libary uim-datasources");

    return true;
  }
}
mixin(ExceptionCalls!("Datasources"));
