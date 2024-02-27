module css.uim.css.exceptions.exception;

import uim.css;

@safe:

// Base css exception.
class DCssException : UimException {
  mixin(ExceptionThis!("Css"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-css");

    return true;
  }
}
mixin(ExceptionCalls!("Css"));
