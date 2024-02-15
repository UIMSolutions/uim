module uim.services.exceptions.exception;

import uim.services;

@safe:

// Service exception.
class DServiceException : UimException {
  mixin(ExceptionThis!("Service"));

  override bool initialize(IData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }

    this
      .messageTemplate("Error in libary uim-services");

    return true;
  }
}
mixin(ExceptionCalls!("Service"));
