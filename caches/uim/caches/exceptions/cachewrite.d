/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.caches.exceptions.cachewrite;

import uim.caches;

@safe:

// Exception raised when cache writing failed for some reason. Replaces triggering an error.
class DCacheWriteException : DCachesException {
  mixin(ExceptionThis!("CacheWrite"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in CacheWrite");

    return true;
  }
}

mixin(ExceptionCalls!("CacheWrite"));

unittest {
  testException(CacheWriteException);
}
