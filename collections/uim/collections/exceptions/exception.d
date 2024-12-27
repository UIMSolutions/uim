/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.collections.exceptions.exception;

import uim.collections;

@safe:

// Base collections exception.
class DCollectionsException : UIMException {
  mixin(ExceptionThis!("Collections"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-collections");

    return true;
  }
}

mixin(ExceptionCalls!("Collections"));

unittest {
  testException(new D_CollectionsException);
}
