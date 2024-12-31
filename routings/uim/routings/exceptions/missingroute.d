/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.exceptions.missingroute;

import uim.routings;

@safe:

// Exception raised when a URL cannot be reverse routed or when a URL cannot be parsed.
class DMissingRouteException : UIMException {
  mixin(ExceptionThis!("MissingRoute"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "A route matching `%s` could not be found.");

    return true;
  }

  // Message template to use when the requested method is included.
  protected string _messageTemplateWithMethod = "A `%s` route matching `%s` could not be found.";

  this(string[] errorMessages, int errorCode = 404, Throwable previousException = null) {
    if (errorMessages.isArray) {
      if (errorMessages.hasKey("errorMessages")) {
        _messageTemplate = errorMessages["message"];
      } else if (errorMessages.hasKey("method") && errorMessages["method"]) {
        _messageTemplate = _messageTemplateWithMethod;
      }
    }
    super(errorMessages, errorCode, previousException);
  }
}

mixin(ExceptionCalls!("MissingRoute"));

unittest {
  assert(testException(MissingRouteException));
}