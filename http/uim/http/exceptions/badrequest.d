/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.exceptions.badrequest;

import uim.http;

@safe:

// Represents an HTTP 400 error.
class DBadRequestException : DHttpException {
    mixin(ExceptionThis!("BadRequest"));

    protected int _defaultCode = 400;

    /*
    this(string exceptionMessage = null, int statusCode = null, Throwable previousException = null) {
        if (exceptionMessage.isEmpty) {
            exceptionMessage = "Bad Request";
        }
        super(exceptionMessage, statusCode, previousException);
    } */
}

mixin(ExceptionCalls!("BadRequest"));

unittest {
    testException(BadRequestException);
}
