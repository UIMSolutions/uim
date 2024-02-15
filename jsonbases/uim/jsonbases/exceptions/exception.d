module uim.jsonbases.exceptions.exception;

import uim.jsonbases;

@safe:
class DJsonBaseException : UimException {
  mixin(ExceptionThis!("JsonBase"));

  alias initialize = UimException.initialize;
  override bool initialize(IData[string] configData = null) {
		if (!super.initialize()) { return false; }

    this
      .messageTemplate("Error in libary uim-jsonbases");

    return true;
  }
}
mixin(ExceptionCalls!("JsonBase"));
