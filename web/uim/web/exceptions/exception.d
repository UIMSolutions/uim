/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.web.exceptions.exception;UIMException

import uim.web;

@safe:

// Web exception.
class DWebException : DException {
  mixin(ExceptionThis!("Web"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
        return false;
    }

    this
      .messageTemplate("Error in libary uim-web");

    return true;
  }
}
mixin(ExceptionCalls!("Web"));
