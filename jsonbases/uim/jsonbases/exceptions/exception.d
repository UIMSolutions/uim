/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.exceptions.exception;

import uim.jsonbases;

@safe:
class DJsonBaseException : UIMException {
  mixin(ExceptionThis!("JsonBase"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-jsonbases");

    return true;
  }
}

mixin(ExceptionCalls!("JsonBase"));

unittest {
  assert(JsonBaseException);
}
