module uim.controllers.exceptions.security;

import uim.controllers;

@safe:

// Security exception - used when SecurityComponent detects any issue with the current request
class SecurityException : ControllerException {
  mixin(ExceptionThis!("SecurityException"));

  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

   _type = "secure";  
  }

  // Reason for request blackhole
  mixin(TProperty!("string", "reason"));

  // Security Exception type
  protected string _type;  
  @property string type() {
    return _type;
  }
}
