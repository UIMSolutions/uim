/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.exceptions.invalidparameter;

import uim.controllers;

@safe:

// Used when a passed parameter or action parameter type declaration is missing or invalid.
class DInvalidParameterException : DControllersException {
  mixin(ExceptionThis!("InvalidParameter"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _stringContents = [
      "failed_coercion": "Unable to coerce `%s` to `%s` for `%s` in action `%s.%s()`.",
      "missing_dependency": "Failed to inject dependency from service container for parameter `%s` with type `%s` in action `%s.%s()`.",
      "missing_parameter": "Missing passed parameter for `%s` in action `%s.%s()`.",
      "unsupported_type": "Type declaration for `%s` in action `%s.%s()` is unsupported.",
    ];

    return true;
  }
  // Switches message template based on `template` key in message array.
  /* this(string messageKey = "default", int errorCode = 0, Throwable previousException = null) {
    super();
    _stringContents["default"] = _stringContents.get(messageKey, null);
  }
  // mixin(ExceptionThis!("InvalidParameterException"));

  } */
}

mixin(ExceptionCalls!("InvalidParameter"));

unittest {
  assert(InvalidParameterException);
}
