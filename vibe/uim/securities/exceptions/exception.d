/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.vibe.exceptions.exception;uim.vibe

import uim.securities;

@safe:

// Base Securities exception.
class DSecuritiesException : UIMException {
  mixin(ExceptionThis!("Securities"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-securities");

    return true;
  }
}

mixin(ExceptionCalls!("Securities"));