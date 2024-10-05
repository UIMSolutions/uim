/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.caches.exceptions.exception;

import uim.caches;

@safe:

// Base Caches exception.
class DCachesException : UIMException {
  mixin(ExceptionThis!("Caches"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "default", "Exception in libary uim-caches");

    return true;
  }
}

mixin(ExceptionCalls!("Caches"));

unittest {
  testException(CachesException);
}