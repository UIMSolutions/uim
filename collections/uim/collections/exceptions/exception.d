module uim.collections.exceptions.exception;

import uim.collections;

@safe:

// Base collections exception.
class DCollectionsException : UimException {
  mixin(ExceptionThis!("Collections"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-collections");

    return true;
  }
}
mixin(ExceptionCalls!("Collections"));
