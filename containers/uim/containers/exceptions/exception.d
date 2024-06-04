module uim.containers.exceptions.exception;

import uim.containers;

@safe:

// Base containers exception.
class DContainersException : DException {
  mixin(ExceptionThis!("Containers"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-containers");

    return true;
  }
}
mixin(ExceptionCalls!("Containers"));
