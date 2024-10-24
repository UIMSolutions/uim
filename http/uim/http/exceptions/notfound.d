/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.exceptions.notfound;

import uim.http;

@safe:

// Represents an HTTP 404 error.
class DNotFoundException : DHttpException {
 
    protected int _defaultCode = 404;
    /* 
    // statusCode: Status code, defaults to 404
    this(string amessage = null, int statusCode = 0, Throwable previousException) {
        if (aMessage.isEmpty) {
            aMessage = "Not Found";
        }
        super(aMessage, statusCode, previousException);
    }  */
}
