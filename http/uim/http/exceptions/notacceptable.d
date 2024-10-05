/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.exceptions.notacceptable;

import uim.http;

@safe:

// Represents an HTTP 406 error.
class DNotAcceptableException : DHttpException {

    protected int _defaultCode = 406;

    /*
    this(string exceptionMessage = null, int statusCode = null, Throwable previousException = null) {
        if (exceptionMessage.isEmpty) {
            exceptionMessage = "Not Acceptable";
        }
        super(exceptionMessage, statusCode, previousException);
    }
}

