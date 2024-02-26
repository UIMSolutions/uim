module uim.caches.exceptions.exception;

import uim.caches;

@safe:

// Base Caches exception.
class DCachesException : UimException {
  mixin(ExceptionThis!("Caches"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-caches");

    return true;
  }
}
mixin(ExceptionCalls!("Caches"));
