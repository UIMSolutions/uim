module uim.http.exceptions.badrequest;

import uim.http;

@safe:

// Represents an HTTP 400 error.
class BadRequestException : DHttpException {
 
    protected int _defaultCode = 400;

    /*
    this(string exceptionMessage = null, int statusCode = null, Throwable previousException = null) {
        if (exceptionMessage.isEmpty) {
            exceptionMessage = "Bad Request";
        }
        super(exceptionMessage, statusCode, previousException);
    } */
}
