/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.exceptions.exception;

import uim.i18n;

@safe:

// I18n exception.
class DI18nException : DException {
  mixin(ExceptionThis!("I18n"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-i18n");

    return true;
  }
}

mixin(ExceptionCalls!("I18n"));

unittest {
  testException(I18nException);
}
