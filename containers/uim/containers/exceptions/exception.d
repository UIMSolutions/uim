module uim.containers.exceptions.exception;

import uim.containers;

@safe:

// Base containers exception.
class DContainersException : UimException {
  mixin(ExceptionThis!("Containers"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-containers");

    return true;
  }
}
mixin(ExceptionCalls!("Containers"));
