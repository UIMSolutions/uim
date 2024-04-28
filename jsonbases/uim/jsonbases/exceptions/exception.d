module uim.jsonbases.exceptions.exception;

import uim.jsonbases;

@safe:
class DJsonBaseException : UimException {
  mixin(ExceptionThis!("JsonBase"));

  override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }

    this
      .messageTemplate("Error in libary uim-jsonbases");

    return true;
  }
}
mixin(ExceptionCalls!("JsonBase"));
