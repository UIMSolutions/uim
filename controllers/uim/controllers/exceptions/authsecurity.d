/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.exceptions.authsecurity;    if (!super.initialize(initData)) {
      return false;
    }

import uim.controllers;

@safe:

// Auth Security exception - used when SecurityComponent detects any issue with the current request
class DAuthSecurityException : DSecurityException {
  mixin(ExceptionThis!("AuthSecurity"));
  
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    // Security Exception type
    _exceptionType = "auth";

    return true;
  }
}
mixin(ExceptionCalls!("AuthSecurity"));
