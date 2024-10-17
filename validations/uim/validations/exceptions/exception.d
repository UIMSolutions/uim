/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.validations.exceptions.exception;

import uim.validations;

@safe:

// Base Validations exception.
class DValidationsException : UIMException {
  mixin(ExceptionThis!("Validations"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("default", "Error in libary uim-validations");

    return true;
  }
}
mixin(ExceptionCalls!("Validations"));

unittest {
  assert(ValidationsException);
}
