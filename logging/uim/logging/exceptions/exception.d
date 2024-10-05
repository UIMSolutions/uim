/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.exceptions.exception;

import uim.logging;

@safe:

// Logging exception.
class DLoggingException : UIMException {
  mixin(ExceptionThis!("Logging"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-logging");

    return true;
  }
}

mixin(ExceptionCalls!("Logging"));

unittest {
  assert(LoggingException);
}
