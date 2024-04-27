module uim.controllers.exceptions.security;

import uim.controllers;

@safe:

// Security exception - used when SecurityComponent detects any issue with the current request
class DSecurityException : DControllersException {
  mixin(ExceptionThis!("Security"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _exceptionType = "secure";

    return true;
  }

  // Reason for request blackhole
  mixin(TProperty!("string", "reason"));

  // Security Exception type
  protected string _exceptionType;
  @property string exceptionType() {
    return _exceptionType;
  }
}
mixin(ExceptionCalls!("Security"));
