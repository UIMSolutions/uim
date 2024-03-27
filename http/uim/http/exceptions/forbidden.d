module uim.http.exceptions.forbidden;

import uim.http;

@safe:

/**
 * Represents an HTTP 403 error.
 */
class DForbiddenException : DHttpException {
 
    protected int _defaultCode = 403;

    /*
    this(string exceptionMessage = null, int statusCode = null, Throwable previousException = null) {
        if (exceptionMessage.isEmpty) {
            exceptionMessage = "Forbidden";
        }
        super(exceptionMessage, statusCode, previousException);
    } */
}
