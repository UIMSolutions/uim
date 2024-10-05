/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.sites.exceptions.exception;UIMException

import uim.sites;

@safe:

// Base Sites exception.
class DSitesException : DException {
  mixin(ExceptionThis!("Sites"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-sites");

    return true;
  }
}
mixin(ExceptionCalls!("Sites"));
