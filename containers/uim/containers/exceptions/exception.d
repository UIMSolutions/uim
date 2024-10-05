/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.containers.exceptions.exception;UIMException

import uim.containers;

@safe:

// Base containers exception.
class DContainersException : DException {
  mixin(ExceptionThis!("Containers"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("default", "Error in libary uim-containers");

    return true;
  }
}
mixin(ExceptionCalls!("Containers"));
