module uim.mvc.exceptions.exception;

import uim.mvc;

@safe:

// Base MVC exception.
class DMVCException : UimException {
  mixin(ExceptionThis!("MVC"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-mvc");

    return true;
  }
}
mixin(ExceptionCalls!("MVC"));
