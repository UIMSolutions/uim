/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.networks.exceptions.exception;

import uim.networks;

@safe:

// Base Networks exception.
class DNetworksException : UIMException {
  mixin(ExceptionThis!("Networks"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("default", "Error in libary uim-networks");

    return true;
  }
}
mixin(ExceptionCalls!("Networks"));
