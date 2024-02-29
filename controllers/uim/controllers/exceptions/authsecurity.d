module uim.controllers.exceptions.authsecurity;

import uim.controllers;

@safe:

// Auth Security exception - used when SecurityComponent detects any issue with the current request
class DAuthSecurityException : DSecurityException {
  mixin(ExceptionThis!("AuthSecurity"));
  
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    // Security Exception type
    _exceptionType = "auth";

    return true;
  }
}
mixin(ExceptionCalls!("AuthSecurity"));
