/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.exceptions.gone;

import uim.http;

@safe:

// Represents an HTTP 410 error.
class DGoneException : DHttpException {
    mixin(ExceptionThis!("Gone"));

    protected int _defaultCode = 410;

    this(string message = null, int statusCode = 410, Throwable previousException = null) {
        if (message.isEmpty) {
            message = "Gone";
        }
        super(message, statusCode, previousException);
    }
}

mixin(ExceptionCalls!("Gone"));

unittest {
    testException(ConflictException);
}
