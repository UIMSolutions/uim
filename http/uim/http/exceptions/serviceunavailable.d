/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.exceptions.serviceunavailable;

import uim.http;

@safe:

// Represents an HTTP 503 error.
class DServiceUnavailableException : DHttpException {
 
    protected int _defaultCode = 503;
    /*
    this(string exceptionMessage = null, int statusCode = null, Throwable previousException = null) {
        if (exceptionMessage.isEmpty) {
            exceptionMessage = "Service Unavailable";
        }
        super(exceptionMessage, statusCode, previousException);
    } */
}
