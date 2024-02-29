module uim.datasources.exceptions.exception;

import uim.datasources;

@safe:

// Datasource exception.
class DDatasourcesException : UimException {
  mixin(ExceptionThis!("Datasources"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .messageTemplate("Error in libary uim-datasources");

    return true;
  }
}
mixin(ExceptionCalls!("Datasources"));
