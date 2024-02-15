module uim.models.exceptions.exception;

import uim.models;

@safe:

// Model exception.
class DModelException : UimException {
  mixin(ExceptionThis!("Model"));

  alias initialize = UimException.initialize;
  bool initialize(IData[string] configData = null) {
		if (!super.initialize()) { return false; }

    this
      .messageTemplate("Error in libary uim-models");

    return true;
  }
}
mixin(ExceptionCalls!("Model"));
