/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.languages.exceptions.exception;

import uim.languages;

@safe:

// I18n exception.
class DLanguagesException : DException {
  mixin(ExceptionThis!("Languages"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-languages");

    return true;
  }
}
mixin(ExceptionCalls!("Languages"));

unittest {
  assert(testException(LanguagesException));
}
