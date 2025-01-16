/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.css.exceptions.exception;

import uim.css;

@safe:

// Base css exception.
class DCssException : DException {
  mixin(ExceptionThis!("Css"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-css");

    return true;
  }
}

mixin(ExceptionCalls!("Css"));

unittest {
  assert(CssException);
}
