module uim.collections.uim.collections.exceptions.exception;

import uim.collections;

@safe:

// Base collections exception.
class DCollectionsException : UimException {
  mixin(ExceptionThis!("Collections"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-collections");

    return true;
  }
}
mixin(ExceptionCalls!("Collections"));
