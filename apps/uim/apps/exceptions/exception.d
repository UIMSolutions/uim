/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.apps.exceptions.exception;

import uim.apps;
@safe:

version (test_uim_apps) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}
// App exception.
class DAppException : DException {
  mixin(ExceptionThis!("App"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-apps");

    return true;
  }
}

mixin(ExceptionCalls!("App"));

unittest {
  testException(AppException);
}
