module uim.events.exceptions.exception;

import uim.events;

@safe:

// Base events exception.
class DEventsException : UimException {
  mixin(ExceptionThis!("Events"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-events");

    return true;
  }
}
mixin(ExceptionCalls!("Events"));
