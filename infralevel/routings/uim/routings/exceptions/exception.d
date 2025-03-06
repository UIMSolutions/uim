/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.exceptions.exception;

import uim.routings;
@safe:

unittest { 
  version(test_uim_routings) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

// Base Routings exception.
class DRoutingsException : DException {
  mixin(ExceptionThis!("Routings"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-routings");

    return true;
  }
}

mixin(ExceptionCalls!("Routings"));

unittest {
  assert(RoutingsException);
}
