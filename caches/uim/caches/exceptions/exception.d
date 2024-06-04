module uim.caches.exceptions.exception;

import uim.caches;

@safe:

// Base Caches exception.
class DCachesException : DException {
  mixin(ExceptionThis!("Caches"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-caches");

    return true;
  }
}
mixin(ExceptionCalls!("Caches"));
