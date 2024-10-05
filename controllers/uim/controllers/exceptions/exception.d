/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.exceptions.exception;

import uim.controllers;

@safe:

// Controller exception.
class DControllersException : UIMException {
  mixin(ExceptionThis!("Controllers"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-controllers");

    return true;
  }
}

mixin(ExceptionCalls!("Controllers"));

unittest {
  testException(ControllersException);
}