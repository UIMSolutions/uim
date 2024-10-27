/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.exceptions.forbidden;

import uim.http;

@safe:

// Represents an HTTP 403 error.
class DForbiddenException : DHttpException {
    mixin(ExceptionThis!("Forbidden"));

    protected int _defaultCode = 403;

    /*
    this(string exceptionMessage = null, int statusCode = null, Throwable previousException = null) {
        if (exceptionMessage.isEmpty) {
            exceptionMessage = "Forbidden";
        }
        super(exceptionMessage, statusCode, previousException);
    } */
}

mixin(ExceptionCalls!("Forbidden"));

unittest {
    testException(ForbiddenException);
}
