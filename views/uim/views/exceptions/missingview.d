/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.exceptions.missingview;

import uim.views;

@safe:

// Used when a view class file cannot be found.
class DMissingViewException : DViewException {
  mixin(ExceptionThis!("MissingView"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "View class `%s` is missing.");

    return true;
  }
}

mixin(ExceptionCalls!("MissingView"));

unittest {
  testException(MissingViewException);
}