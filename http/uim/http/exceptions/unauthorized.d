/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.exceptions.unauthorized;

import uim.http;

@safe:

// Represents an HTTP 401 error.
class DUnauthorizedException : DHttpException {
    this(string message = null, int statusCode = 0, Throwable previousException = null) {
        if (message.isEmpty) {
            message = "Unauthorized";
        }
        // super(message, statusCode, previousException);
    }

    protected int _defaultCode = 401;
}
