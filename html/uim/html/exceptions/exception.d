/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.html.exceptions.exception;

import uim.html;

@safe:

// I18n exception.
class DHtmlException : UIMException {
  mixin(ExceptionThis!("Html"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exeption in libary uim-html");

    return true;
  }
}

mixin(ExceptionCalls!("Html"));

unittest {
  testException(HtmlException);
}
