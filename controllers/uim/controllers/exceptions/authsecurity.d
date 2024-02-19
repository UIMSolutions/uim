module uim.controllers.uim.controllers.exceptions.authsecurity;

import uim.controllers;

@safe:

// Auth Security exception - used when SecurityComponent detects any issue with the current request
class AuthSecurityException : SecurityException {
  mixin(ExceptionThis!("SecurityException"));
  
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    // Security Exception type
    _type = "auth";
  }
}
