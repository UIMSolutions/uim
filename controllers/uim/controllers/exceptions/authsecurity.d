module uim.controllers.exceptions.authsecurity;

import uim.controllers;

@safe:

// Auth Security exception - used when SecurityComponent detects any issue with the current request
class DAuthSecurityException : DSecurityException {
  mixin(ExceptionThis!("AuthSecurity"));
  
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    // Security Exception type
    _exceptionType = "auth";

    return true;
  }
}
mixin(ExceptionCalls!("AuthSecurity"));
