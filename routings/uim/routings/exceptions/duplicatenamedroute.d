/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.exceptions.duplicatenamedroute;

import uim.routings;

@safe:

// Exception raised when a route names used twice.
class DDuplicateNamedRouteException : UIMException {
    mixin(ExceptionThis!("DuplicateNamedRoute"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        messageTemplate("default", "A route named `%s` has already been connected to `%s`.");
        return true;
    }

    this(string[] amessage, int errorCode = 404, Throwable previousException = null) {
        if (message.isArray && message.hasKey("message")) {
            _messageTemplate = message["message"];
        }
        super(message, errorCode, previousException);
    }
}
mixin(ExceptionCalls!("DuplicateNamedRoute"));

unittest {
  assert(testException(DuplicateNamedRouteException));
}