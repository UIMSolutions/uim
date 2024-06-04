module uim.collections.exceptions.exception;

import uim.collections;

@safe:

// Base collections exception.
class DCollectionsException : DException {
  mixin(ExceptionThis!("Collections"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-collections");

    return true;
  }
}
mixin(ExceptionCalls!("Collections"));
