module uim.mvc.uim.mvc.exceptions.exception;

import uim.mvc;

@safe:

// Base MVC exception.
class DMVCException : UimException {
  mixin(ExceptionThis!("MVC"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-mvc");

    return true;
  }
}
mixin(ExceptionCalls!("MVC"));
