/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.entitybases.exceptions.exception;

import uim.entitybases;

@safe:

// Datasource exception.
class DEntitybasesException : UIMException {
  mixin(ExceptionThis!("Entitybases"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-entitybases");

    return true;
  }
}

mixin(ExceptionCalls!("Entitybases"));

unittest {
  testException(EntitybasesException);
}
