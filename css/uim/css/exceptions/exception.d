module uim.css.exceptions.exception;

import uim.css;

@safe:

// Base css exception.
class DCssException : UimException {
  mixin(ExceptionThis!("Css"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-css");

    return true;
  }
}
mixin(ExceptionCalls!("Css"));
