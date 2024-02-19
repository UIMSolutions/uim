module uim.controllers.exceptions.invalidparameter;

import uim.controllers;

@safe:

// Used when a passed parameter or action parameter type declaration is missing or invalid.
class InvalidParameterException : ControllerException {
  // Switches message template based on `template` key in message array.
  this(string messageKey = "default", int errorCode = 0, Throwable previousException = null) {
    super();
    _templates["default"] = _templates.get(messageKey, null);
  }
  // mixin(ExceptionThis!("InvalidParameterException"));

  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    _templates = [
      "failed_coercion": "Unable to coerce `%s` to `%s` for `%s` in action `%s::%s()`.",
      "missing_dependency": "Failed to inject dependency from service container for parameter `%s` with type `%s` in action `%s::%s()`.",
      "missing_parameter": "Missing passed parameter for `%s` in action `%s::%s()`.",
      "unsupported_type": "Type declaration for `%s` in action `%s::%s()` is unsupported.",
    ];
  }
}
